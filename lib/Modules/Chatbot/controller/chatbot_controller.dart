import 'dart:async';
import 'dart:io';

import 'package:Gixa/Modules/Chatbot/model/chatbot_model.dart';
import 'package:Gixa/services/chat_services.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  // ===============================
  // STATE
  // ===============================

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isHumanMode = false.obs;
  final RxBool isBotTyping = false.obs;
  bool _hasStartedChat = false;
  bool _isPollingStarted = false;

  String? sessionId;
  Timer? _pollingTimer;

  // ===============================
  // INIT
  // ===============================

  @override
  void onInit() {
    super.onInit();
    startChat();
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

      final response = await ChatApi.startChat(
        userId: 1, // TODO: replace with logged-in user id
      );

      sessionId = response.sessionId;
      messages.assignAll(response.messages);

      isHumanMode.value = response.mode == "human";

      _startPolling();
    } catch (e) {
      Get.snackbar("Error", "Failed to start chat");
    } finally {
      isLoading.value = false;
    }
  }

  // BOT OPTION CLICK

  Future<void> onBotOptionSelected(ChatOption option) async {
    if (sessionId == null) return;
    if (isBotTyping.value) return;

    // show user's selected option
    messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: "user",
        type: "text",
        content: option.label,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );

    if (option.key == "human") {
      await switchToHuman();
      return;
    }

    try {
      isBotTyping.value = true;

      final botMessages = await ChatApi.botResponse(
        sessionId: sessionId!,
        selectedKey: option.key,
      );

      final index = messages.lastIndexWhere((m) => m.type == "options");
      if (index != -1) messages.removeAt(index);

      messages.addAll(botMessages);
    } catch (e) {
      Get.snackbar("Error", "Sorry, this option is no longer available");
    } finally {
      isBotTyping.value = false;
    }
  }

  // SWITCH TO HUMAN
  Future<void> switchToHuman() async {
    if (sessionId == null) return;

    try {
      isLoading.value = true;

      final humanMessages = await ChatApi.switchToHuman(
        sessionId: sessionId!,
        reason: "User requested human support",
      );

      isHumanMode.value = true;
      messages.addAll(humanMessages);

      _startPolling(); // 🔑 start polling here only
    } catch (e) {
      Get.snackbar("Error", "Unable to connect to counselor");
    } finally {
      isLoading.value = false;
    }
  }

  // ===============================
  // SEND TEXT MESSAGE
  // ===============================

  Future<void> sendTextMessage(String text) async {
    if (sessionId == null || text.trim().isEmpty) return;

    final tempMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: "user",
      type: "text",
      content: text,
      createdAt: DateTime.now().toIso8601String(),
    );

    messages.add(tempMessage);

    try {
      await ChatApi.sendMessage(
        sessionId: sessionId!,
        type: "text",
        content: text,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to send message");
    }
  }

  // ===============================
  // SEND MEDIA MESSAGE
  // ===============================

  Future<void> sendMediaMessage(File file, String mediaType) async {
    if (sessionId == null) return;

    final tempMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: "user",
      type: mediaType,
      content: "Uploading...",
      createdAt: DateTime.now().toIso8601String(),
    );

    messages.add(tempMessage);

    try {
      await ChatApi.sendMessage(
        sessionId: sessionId!,
        type: mediaType, // image | video
        file: file,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to send media");
    }
  }

  // ===============================
  // POLLING FOR NEW MESSAGES
  // ===============================

  void _startPolling() {
    if (_isPollingStarted) return; // 🔒 add this
    _isPollingStarted = true;

    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!isHumanMode.value) return;
      if (sessionId == null || messages.isEmpty) return;

      try {
        final lastMessageId = messages.last.id;

        final newMessages = await ChatApi.fetchMessages(
          sessionId: sessionId!,
          lastMessageId: lastMessageId,
        );

        if (newMessages.isNotEmpty) {
          messages.addAll(newMessages);
        }
      } catch (_) {}
    });
  }

  // ===============================
  // CLEAR CHAT
  // ===============================

  Future<void> clearChat() async {
    if (sessionId == null) return;

    try {
      await ChatApi.clearChat(sessionId: sessionId!);
      messages.clear();
    } catch (e) {
      Get.snackbar("Error", "Failed to clear chat");
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
    } catch (e) {
      Get.snackbar("Error", "Failed to close chat");
    }
  }
}
