import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:Gixa/Modules/Chatbot/model/chatbot_model.dart';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/services/chat_services.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';
import 'package:get_storage/get_storage.dart';

class ChatController extends GetxController {
  final bool autoStart;
  final String? storagePrefix;

  ChatController({this.autoStart = true, this.storagePrefix});
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  final RxList<ChatSession> previousSessions = <ChatSession>[].obs;
  final RxBool isFetchingSessions = false.obs;

  final RxBool isLoading = false.obs;
  final RxBool isHumanMode = false.obs;
  final RxBool isBotTyping = false.obs;
  bool _hasStartedChat = false;
  bool _isPollingStarted = false;
  final Set<String> _suppressedHumanEchoTexts = <String>{};
  final ProfileController profileController = Get.find<ProfileController>();
  final GetStorage _box = GetStorage();

  String? sessionId;
  Timer? _pollingTimer;

  void _logRequest(String action, Map<String, dynamic> payload) {
    print('========== CHAT API REQUEST: $action ==========');
    print(const JsonEncoder.withIndent('  ').convert(payload));
    print('==============================================');
  }

  void _logResponse(String action, Object? payload) {
    print('========== CHAT API RESPONSE: $action ==========');

    if (payload is ChatStartResponse) {
      print(
        const JsonEncoder.withIndent('  ').convert({
          'session_id': payload.sessionId,
          'mode': payload.mode,
          'messages_count': payload.messages.length,
          'messages': payload.messages.map((m) => m.toJson()).toList(),
        }),
      );
    } else if (payload is Iterable<ChatMessage>) {
      print(
        const JsonEncoder.withIndent(
          '  ',
        ).convert(payload.map((m) => m.toJson()).toList()),
      );
    } else {
      print(payload);
    }

    print('==============================================');
  }

  @override
  void onInit() {
    super.onInit();
    if (storagePrefix != null) {
      final restored = _restoreStoredChatState();
      if (restored) {
        _hasStartedChat = true;
      }
      ever(messages, (_) => _persistStoredChatState());
      ever(isHumanMode, (value) {
        _persistStoredChatState();
        if (value && sessionId != null) {
          _startPolling();
        }
      });

      if (sessionId != null && isHumanMode.value) {
        _startPolling();
      }
    }

    if (autoStart) startChat();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  // ===============================
  // START CHAT
  // ===============================

  Future<void> startChat() async {
    if (_hasStartedChat) return;

    _hasStartedChat = true;

    try {
      isLoading.value = true;

      /// 🔥 DYNAMIC LOGGED-IN USER ID
      final userId = profileController.profile.value?.user.id;

      if (userId == null) {
        AppSnackbar.show("Error", "User profile not found");

        return;
      }

      _logRequest('startChat', {'userId': userId});

      final response = await ChatApi.startChat(userId: userId);

      _logResponse('startChat', response);

      sessionId = response.sessionId;

      // Debug: print parsed start response summary
      try {
        print(
          'ChatController.startChat - sessionId: ${response.sessionId}, mode: ${response.mode}, messagesCount: ${response.messages.length}',
        );
      } catch (_) {}

      messages.assignAll(response.messages);

      isHumanMode.value = response.mode == "human";

      // _startPolling();
    } catch (e) {
      AppSnackbar.show("Error", "Failed to start chat");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onBotOptionSelected(ChatOption option) async {
    if (sessionId == null) return;
    if (isBotTyping.value) return;

    // Prevent polling from re-adding the user's selected option as a new message
    suppressHumanEchoText(option.label);

    if (option.key.toLowerCase() == 'admission') {
      Get.toNamed(AppRoutes.admissionChat);
      return;
    }

    messages.add(
      ChatMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}_local',
        sender: "user",
        type: "text",
        content: option.label,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );

    if (option.key == "human") {
      await switchToHuman(
        reason: _optionReason(option),
        selectedKey: option.key,
        selectedLabel: option.label,
        suppressEchoTexts: [option.label],
      );
      return;
    }

    try {
      isBotTyping.value = true;

      _logRequest('botResponse', {
        'userId': profileController.profile.value!.user.id.toString(),
        'sessionId': sessionId!,
        'selectedKey': option.key,
        'selectedLabel': option.label,
      });

      final botMessages = await ChatApi.botResponse(
        userId: profileController.profile.value!.user.id.toString(),
        sessionId: sessionId!,
        selectedKey: option.key,
        selectedLabel: option.label,
      );

      _logResponse('botResponse', botMessages);

      // Debug: print parsed bot messages
      try {
        print(
          'ChatController.onBotOptionSelected - botMessages count: ${botMessages.length}',
        );
        for (final m in botMessages) {
          print('  -> message: ${m.toJson()}');
        }
      } catch (_) {}

      final index = messages.lastIndexWhere(
        (m) =>
            m.type == "options" || (m.options != null && m.options!.isNotEmpty),
      );
      if (index != -1) messages.removeAt(index);

      messages.removeWhere(
        (m) =>
            m.type == 'options' || (m.options != null && m.options!.isNotEmpty),
      );

      final existingIds = messages.map((m) => m.id.toString()).toSet();
      final newMsgs = botMessages.where((m) => !existingIds.contains(m.id.toString())).toList();
      
      // Remove local echo if the backend returned it
      final hasEcho = newMsgs.any((m) => m.sender == 'user' && m.content == option.label);
      if (hasEcho) {
        messages.removeWhere((m) => m.id.toString().contains('_local') && m.content == option.label);
      }

      messages.addAll(newMsgs);
    } catch (e) {
      AppSnackbar.show("Error", "Sorry, this option is no longer available");
    } finally {
      isBotTyping.value = false;
    }
  }

  // SWITCH TO HUMAN
  Future<void> switchToHuman({
    required String reason,
    String? selectedKey,
    String? selectedLabel,
    List<String> suppressEchoTexts = const [],
  }) async {
    if (sessionId == null) return;

    _recordHumanEchoTexts(suppressEchoTexts);

    try {
      isLoading.value = true;

      _logRequest('switchToHuman', {'sessionId': sessionId!, 'reason': reason});

      final humanMessages = await ChatApi.switchToHuman(
        sessionId: sessionId!,
        reason: reason,
        selectedKey: selectedKey,
        selectedLabel: selectedLabel,
      );

      _logResponse('switchToHuman', humanMessages);

      isHumanMode.value = true;
      _removeOptionMessages();

      final existingIds = messages.map((m) => m.id.toString()).toSet();
      final newMsgs = humanMessages.where((m) => !existingIds.contains(m.id.toString())).where(_shouldKeepInHumanMode).toList();

      // Remove local echo if backend returned it
      if (selectedLabel != null) {
        messages.removeWhere((m) => m.id.toString().contains('_local') && m.content == selectedLabel);
      }

      messages.addAll(newMsgs);

      // Ensure polling starts so human/admin messages are fetched
      try {
        _startPolling();
      } catch (_) {}

      // _startPolling();
    } catch (e) {
      AppSnackbar.show("Error", "Unable to connect to counselor");
    } finally {
      isLoading.value = false;
    }
  }

  // ===============================
  // SEND TEXT MESSAGE
  // ===============================

  Future<void> sendTextMessage(String text) async {
    if (sessionId == null || text.trim().isEmpty) return;

    // When in human mode, suppress server-side echo of this message
    if (isHumanMode.value) {
      suppressHumanEchoText(text);
    }

    final tempId = '${DateTime.now().millisecondsSinceEpoch}_temp';

    final tempMessage = ChatMessage(
      id: tempId,
      sender: "user",
      type: "text",
      content: text,
      createdAt: DateTime.now().toIso8601String(),
    );

    messages.add(tempMessage);

    // Remove any lingering option messages so quick replies don't persist
    _removeOptionMessages();

    try {
      _logRequest('sendTextMessage', {
        'sessionId': sessionId!,
        'type': 'text',
        'content': text,
      });

      final messageId = await ChatApi.sendMessage(
        sessionId: sessionId!,
        type: "text",
        content: text,
      );

      _logResponse('sendTextMessage', {'message_id': messageId});

      if (messageId != null) {
        final idx = messages.indexWhere((m) => m.id == tempId);
        if (idx != -1) {
          messages[idx] = ChatMessage(
            id: messageId,
            sender: "user",
            type: "text",
            content: text,
            createdAt: tempMessage.createdAt,
          );
        }
      }
    } catch (e) {
      AppSnackbar.show("Error", "Failed to send message");
    }
  }

  // ===============================
  // SEND MEDIA MESSAGE
  // ===============================

  Future<void> sendMediaMessage(File file, String mediaType) async {
    if (sessionId == null) return;

    final tempId = '${DateTime.now().millisecondsSinceEpoch}_temp';

    final tempMessage = ChatMessage(
      id: tempId,
      sender: "user",
      type: mediaType,
      content: null,
      mediaUrl: file.path,
      createdAt: DateTime.now().toIso8601String(),
    );

    messages.add(tempMessage);

    // Remove any lingering option messages so quick replies don't persist
    _removeOptionMessages();

    try {
      _logRequest('sendMediaMessage', {
        'sessionId': sessionId!,
        'type': mediaType,
        'filePath': file.path,
      });

      final messageId = await ChatApi.sendMessage(
        sessionId: sessionId!,
        type: mediaType,
        file: file,
      );

      _logResponse('sendMediaMessage', {'message_id': messageId});

      if (messageId != null) {
        final idx = messages.indexWhere((m) => m.id == tempId);
        if (idx != -1) {
          messages[idx] = ChatMessage(
            id: messageId,
            sender: "user",
            type: mediaType,
            content: null,
            mediaUrl: file.path,
            createdAt: tempMessage.createdAt,
          );
        }
      }
    } catch (e) {
      AppSnackbar.show("Error", "Failed to send media");
    }
  }

  void _removeOptionMessages() {
    messages.removeWhere(
      (m) =>
          m.type == 'options' || (m.options != null && m.options!.isNotEmpty),
    );
  }

  // ===============================
  // POLLING FOR NEW MESSAGES
  // ===============================

  void _startPolling() {
    if (_isPollingStarted) return;
    _isPollingStarted = true;

    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!isHumanMode.value) return;
      if (sessionId == null) return;

      try {
        _logRequest('fetchMessages', {
          'sessionId': sessionId!,
          'lastMessageId': messages.isNotEmpty ? messages.last.id : null,
        });

        /// Only use real server message ids
        final validMessages = messages.where(
          (m) =>
              m.id.toString().isNotEmpty &&
              !m.id.toString().contains('_temp') &&
              !m.id.toString().contains('_local'),
        );

        final lastMessageId = validMessages.isNotEmpty
            ? validMessages.last.id
            : null;
        final newMessages = await ChatApi.fetchMessages(
          sessionId: sessionId!,
          lastMessageId: lastMessageId,
        );

        if (newMessages.isNotEmpty) {
          final existingIds = messages.map((m) => m.id.toString()).toSet();
          final filtered = newMessages
              .where((m) => !existingIds.contains(m.id.toString()))
              .where(_shouldKeepInHumanMode)
              .toList();
          _logResponse('fetchMessages', filtered);
          if (filtered.isNotEmpty) {
            try {
              print(
                'ChatController._startPolling - fetched ${filtered.length} new messages',
              );
              for (final m in filtered)
                print('  -> polled message: ${m.toJson()}');
            } catch (_) {}

            messages.addAll(filtered);
          }
        }
      } catch (_) {}
    });
  }

  void clearLocalChatState() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isPollingStarted = false;
    _hasStartedChat = false;
    sessionId = null;
    isHumanMode.value = false;
    isBotTyping.value = false;
    _suppressedHumanEchoTexts.clear();
    messages.clear();
    _clearStoredChatState();
  }

  // ===============================
  // CLEAR CHAT
  // ===============================

  Future<void> clearChat() async {
    var serverClearFailed = false;

    try {
      if (sessionId != null) {
        await ChatApi.clearChat(sessionId: sessionId!);
      }
    } catch (e) {
      serverClearFailed = true;
    }

    clearLocalChatState();

    if (serverClearFailed) {
      AppSnackbar.show("Success", "Chat cleared locally");
    } else {
      AppSnackbar.show("Success", "Chat cleared");
    }
  }

  // ===============================
  // CLOSE CHAT
  // ===============================

  Future<void> closeChat() async {
    if (sessionId == null) return;

    try {
      await ChatApi.closeChat(sessionId: sessionId!);
      _pollingTimer?.cancel();
      _isPollingStarted = false;
    } catch (e) {
      AppSnackbar.show("Error", "Failed to close chat");
    }
  }

  Future<void> _syncHistoryFromServer() async {
    if (sessionId == null) return;

    try {
      final serverMessages = await ChatApi.fetchMessages(sessionId: sessionId!);
      if (serverMessages.isNotEmpty) {
        messages.assignAll(serverMessages);
      }
    } catch (_) {
      // Keep cached history if sync fails.
    }
  }

  /// Apply a start response (used for admission-specific flow).
  /// This is public so other views can initialize the controller
  /// without calling private members directly.
  void applyStartResponse(ChatStartResponse response, {int? userId}) {
    _hasStartedChat = true;
    sessionId = response.sessionId;
    isHumanMode.value = response.mode == 'human';
    messages.assignAll(response.messages.where(_shouldKeepInHumanMode));
    _persistStoredChatState();
    if (isHumanMode.value) {
      _startPolling();
    }
  }

  bool _shouldKeepInHumanMode(ChatMessage message) {
    if (!isHumanMode.value) return true;

    if (message.type == 'options' ||
        (message.options != null && message.options!.isNotEmpty)) {
      return false;
    }

    if (message.sender.toLowerCase() != 'user') {
      return true;
    }

    final normalizedContent = _normalizeMessageText(message.content);
    if (normalizedContent.isEmpty) return true;

    return !_suppressedHumanEchoTexts.contains(normalizedContent);
  }

  void _recordHumanEchoTexts(Iterable<String> texts) {
    for (final text in texts) {
      final normalized = _normalizeMessageText(text);
      if (normalized.isNotEmpty) {
        _suppressedHumanEchoTexts.add(normalized);
      }
    }
  }

  void suppressHumanEchoText(String text) {
    _recordHumanEchoTexts([text]);
  }

  void suppressHumanEchoTexts(Iterable<String> texts) {
    _recordHumanEchoTexts(texts);
  }

  String _optionReason(ChatOption option) {
    final label = option.label.trim();
    if (label.isNotEmpty) return label;

    final key = option.key.trim();
    return key.isNotEmpty ? key : 'human';
  }

  String _normalizeMessageText(String? text) {
    return text?.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ') ?? '';
  }

  String get _storageKeyBase {
    final userId = profileController.profile.value?.user.id;
    return '${storagePrefix ?? 'chat_controller_default_state'}_${userId ?? 'guest'}';
  }

  String get _messagesStorageKey => '$_storageKeyBase.messages';
  String get _sessionStorageKey => '$_storageKeyBase.session_id';
  String get _humanModeStorageKey => '$_storageKeyBase.is_human_mode';

  void _persistStoredChatState() {
    if (storagePrefix == null) return;

    _box.write(
      _messagesStorageKey,
      messages.map((message) => message.toJson()).toList(),
    );
    _box.write(_sessionStorageKey, sessionId);
    _box.write(_humanModeStorageKey, isHumanMode.value);
  }

  bool _restoreStoredChatState() {
    if (storagePrefix == null) return false;

    var restored = false;

    final rawMessages = _box.read(_messagesStorageKey);
    if (rawMessages is List) {
      final storedMessages = rawMessages
          .whereType<Map>()
          .map((item) => ChatMessage.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      if (storedMessages.isNotEmpty) {
        messages.assignAll(storedMessages);
        restored = true;
      }
    }

    final storedSessionId = _box.read(_sessionStorageKey);
    if (storedSessionId is String && storedSessionId.isNotEmpty) {
      sessionId = storedSessionId;
      restored = true;
    }

    final storedHumanMode = _box.read(_humanModeStorageKey);
    if (storedHumanMode is bool) {
      isHumanMode.value = storedHumanMode;
      restored = true;
    }

    return restored;
  }

  // ===============================
  // CHAT HISTORY & SESSIONS
  // ===============================

  Future<void> loadPreviousSessions(String entryFlow) async {
    try {
      isFetchingSessions.value = true;
      final sessions = await ChatApi.fetchChatSessions(entryFlow: entryFlow);
      previousSessions.assignAll(sessions);
    } catch (e) {
      debugPrint("Failed to load previous sessions: $e");
    } finally {
      isFetchingSessions.value = false;
    }
  }

  void startNewSession() {
    _pollingTimer?.cancel();
    _isPollingStarted = false;
    sessionId = null;
    _hasStartedChat = false;
    messages.clear();
    isHumanMode.value = false;
    _clearStoredChatState();
  }

  Future<void> loadSessionHistory(String id) async {
    try {
      isLoading.value = true;

      // Stop polling for the old session if any
      _pollingTimer?.cancel();
      _isPollingStarted = false;

      final history = await ChatApi.fetchChatHistory(sessionId: id);
      messages.assignAll(history);

      sessionId = id;
      _hasStartedChat = true;

      // Determine human mode:
      // If any message is from an agent, it's definitely human mode.
      // Alternatively, if the chat history doesn't end with bot options, 
      // we must enable the text input field so the user can continue the chat.
      final lastMsg = history.isNotEmpty ? history.last : null;
      final hasOptionsAtEnd = lastMsg != null && (lastMsg.type == 'options' || (lastMsg.options != null && lastMsg.options!.isNotEmpty));
      
      isHumanMode.value = history.any((m) => m.sender == 'agent') || !hasOptionsAtEnd;

      if (isHumanMode.value) {
        _startPolling();
      }

      _persistStoredChatState();
    } catch (e) {
      debugPrint("Failed to load session history: $e");
      AppSnackbar.show("Error", "Failed to load chat history");
    } finally {
      isLoading.value = false;
    }
  }

  void _clearStoredChatState() {
    if (storagePrefix == null) return;

    _box.remove(_messagesStorageKey);
    _box.remove(_sessionStorageKey);
    _box.remove(_humanModeStorageKey);
  }
}
