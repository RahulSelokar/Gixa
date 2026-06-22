import 'dart:io';

import 'package:Gixa/Modules/Chatbot/controller/chatbot_controller.dart';
import 'package:Gixa/Modules/Chatbot/model/chatbot_model.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:Gixa/services/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class AdmissionChatView extends StatefulWidget {
  const AdmissionChatView({super.key});

  @override
  State<AdmissionChatView> createState() => _AdmissionChatViewState();
}

class _AdmissionChatViewState extends State<AdmissionChatView> {
  static const String _controllerTag = 'admission-chat';

  late final ChatController controller;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void _logRequest(String action, Map<String, dynamic> payload) {
    print('========== ADMISSION CHAT REQUEST: $action ==========');
    print(const JsonEncoder.withIndent('  ').convert(payload));
    print('====================================================');
  }

  void _logResponse(String action, Object? payload) {
    print('========== ADMISSION CHAT RESPONSE: $action ==========');

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

    print('====================================================');
  }

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ChatController>(tag: _controllerTag)
        ? Get.find<ChatController>(tag: _controllerTag)
        : Get.put(
            ChatController(autoStart: false, storagePrefix: _controllerTag),
            tag: _controllerTag,
            permanent: true,
          );
    _startAdmissionChat();
    
    // Load previous history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPreviousSessions('admission');
    });
  }

  Future<void> _startAdmissionChat() async {
    try {
      if (controller.sessionId != null || controller.messages.isNotEmpty) {
        return;
      }

      final userId = controller.profileController.profile.value?.user.id;
      if (userId == null) return;

      _logRequest('admissionStart', {'userId': userId.toString()});

      final response = await ChatApi.admissionStart(userId: userId.toString());

      _logResponse('admissionStart', response);

      controller.applyStartResponse(
        response,
        userId: controller.profileController.profile.value?.user.id,
      );

      // Debug: log session and mode to help trace missing messages
      try {
        print(
          'AdmissionChat: sessionId=${controller.sessionId} isHuman=${controller.isHumanMode.value} messages=${controller.messages.length}',
        );
      } catch (_) {}
    } catch (_) {
      // ignore errors here; fallback to existing chat state
    }
  }

  Future<void> _handleAdmissionOptionSelected(ChatOption option) async {
    if (controller.sessionId == null || controller.isBotTyping.value) return;

    controller.suppressHumanEchoText(option.label);

    if (option.key.toLowerCase() == 'human') {
      // Show selected option in chat
      controller.messages.add(
        ChatMessage(
          id: '${DateTime.now().millisecondsSinceEpoch}_local',
          sender: 'user',
          type: 'text',
          content: option.label,
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      // Remove all chatbot option messages, including text bubbles carrying quick replies
      controller.messages.removeWhere(
        (m) =>
            m.type == 'options' || (m.options != null && m.options!.isNotEmpty),
      );

      // // Optional support connection message
      // controller.messages.add(
      //   ChatMessage(
      //     id: DateTime.now().millisecondsSinceEpoch.toString(),
      //     sender: 'bot',
      //     type: 'text',
      //     content: 'You are now connected with human support.',
      //     createdAt: DateTime.now().toIso8601String(),
      //   ),
      // );

      // Enable human mode
      controller.isHumanMode.value = true;

      // Call backend human support API
      await controller.switchToHuman(
        reason: _optionReason(option),
        selectedKey: option.key,
        selectedLabel: option.label,
        suppressEchoTexts: [option.label],
      );

      return;
    }

    controller.messages.add(
      ChatMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}_local',
        sender: 'user',
        type: 'text',
        content: option.label,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );

    try {
      controller.isBotTyping.value = true;

      _logRequest('botResponse', {
        'userId': controller.profileController.profile.value!.user.id
            .toString(),
        'sessionId': controller.sessionId!,
        'selectedKey': option.key,
        'selectedLabel': option.label,
      });

      final botMessages = await ChatApi.botResponse(
        userId: controller.profileController.profile.value!.user.id.toString(),
        sessionId: controller.sessionId!,
        selectedKey: option.key,
        selectedLabel: option.label,
      );

      _logResponse('botResponse', botMessages);

      final index = controller.messages.lastIndexWhere(
        (m) =>
            m.type == 'options' || (m.options != null && m.options!.isNotEmpty),
      );
      if (index != -1) {
        controller.messages.removeAt(index);
      }

      controller.messages.removeWhere(
        (m) =>
            m.type == 'options' || (m.options != null && m.options!.isNotEmpty),
      );

      final existingIds = controller.messages.map((m) => m.id.toString()).toSet();
      final newMsgs = botMessages.where((m) => !existingIds.contains(m.id.toString())).toList();
      
      final hasEcho = newMsgs.any((m) => m.sender == 'user' && m.content == option.label);
      if (hasEcho) {
        controller.messages.removeWhere((m) => m.id.toString().contains('_local') && m.content == option.label);
      }

      controller.messages.addAll(newMsgs);
    } catch (_) {
      // ignore errors and keep the current conversation state
    } finally {
      controller.isBotTyping.value = false;
    }
  }

  String _optionReason(ChatOption option) {
    final label = option.label.trim();
    if (label.isNotEmpty) return label;

    final key = option.key.trim();
    return key.isNotEmpty ? key : 'human';
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF10141C) : const Color(0xFFF7F9FD);
    final surfaceColor = isDark ? const Color(0xFF171C26) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF10131A);
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final borderColor = isDark ? Colors.white12 : const Color(0xFFE7ECF4);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Admission Help'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: surfaceColor,
        foregroundColor: textColor,
        scrolledUnderElevation: 0,
        actions: [
          Builder(
            builder: (context) {
              return TextButton.icon(
                icon: Icon(Icons.history_rounded, color: textColor, size: 20),
                label: Text(
                  'History',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            }
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: textColor),
            color: surfaceColor,
            onSelected: (value) async {
              if (value != 'clear') return;

              final shouldClear = await Get.dialog<bool>(
                AlertDialog(
                  backgroundColor: surfaceColor,
                  title: Text(
                    'Clear chat?',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  content: Text(
                    'This will remove all admission chat messages.',
                    style: TextStyle(color: subTextColor),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: subTextColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(result: true),
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          color: kHomeAccentColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              );

              if (shouldClear == true) {
                await controller.clearChat();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded, color: kHomeAccentColor),
                    const SizedBox(width: 8),
                    Text('Clear chat', style: TextStyle(color: textColor)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      endDrawer: Drawer(
        backgroundColor: bgColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Previous Chats',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline_rounded, color: kHomeAccentColor),
                      tooltip: 'New Chat',
                      onPressed: () {
                        Get.back();
                        controller.startNewSession();
                        _startAdmissionChat();
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: Obx(() {
                  if (controller.isFetchingSessions.value) {
                    return Center(child: CircularProgressIndicator(color: kHomeAccentColor));
                  }
                  
                  if (controller.previousSessions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 48, color: subTextColor.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          Text(
                            'No previous chats found.',
                            style: TextStyle(color: subTextColor),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: controller.previousSessions.length,
                    itemBuilder: (context, index) {
                      final session = controller.previousSessions[index];
                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: kHomeAccentColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.chat_bubble_outline, color: kHomeAccentColor, size: 18),
                        ),
                        title: Text(
                          session.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            session.formattedDate,
                            style: TextStyle(color: subTextColor, fontSize: 12),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        onTap: () {
                          Get.back(); // close drawer
                          controller.loadSessionHistory(session.sessionId);
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: kHomeAccentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: kHomeAccentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admission assistance',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Ask about documents, counselling, deadlines, fees, and admission steps.',
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 12.5,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.messages.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(color: kHomeAccentColor),
                );
              }

              if (controller.messages.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 52,
                          color: kHomeAccentColor.withOpacity(0.8),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Start asking admission questions',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You can ask anything related to the admission process here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: subTextColor,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              _scrollToBottom();

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                itemCount: controller.messages.length,
                itemBuilder: (_, index) {
                  final msg = controller.messages[index];
                  final hasOptions =
                      msg.options != null && msg.options!.isNotEmpty;

                  if (controller.isHumanMode.value && hasOptions) {
                    return const SizedBox.shrink();
                  }

                  if (hasOptions &&
                      !controller.isBotTyping.value &&
                      !controller.isHumanMode.value) {
                    return _QuickReplies(
                      options: msg.options!,
                      onTap: _handleAdmissionOptionSelected,
                      isDisabled: controller.isBotTyping.value,
                      isDark: isDark,
                    );
                  }

                  if (hasOptions && controller.isHumanMode.value) {
                    return _AdmissionBubble(message: msg, isDark: isDark);
                  }

                  return _AdmissionBubble(message: msg, isDark: isDark);
                },
              );
            }),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 54),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E2430)
                            : const Color(0xFFF6F8FC),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: borderColor),
                      ),
                      child: TextField(
                        controller: textController,
                        minLines: 1,
                        maxLines: 4,
                        cursorColor: kHomeAccentColor,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Ask about admission',
                          hintStyle: TextStyle(
                            color: subTextColor,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _CircleActionButton(
                    icon: Icons.send_rounded,
                    onTap: _sendMessage,
                    isPrimary: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      await controller.sendMediaMessage(File(file.path), 'image');
    }
  }

  void _sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    controller.sendTextMessage(text);
    textController.clear();
  }
}

class _AdmissionBubble extends StatelessWidget {
  const _AdmissionBubble({required this.message, required this.isDark});

  final ChatMessage message;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == 'user';
    final bg = isUser
        ? const LinearGradient(
            colors: [Color(0xFFFFB545), Color(0xFFE47D00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : null;
    final bubbleColor = isUser
        ? null
        : (isDark ? const Color(0xFF1B2230) : Colors.white);
    final textColor = isUser
        ? const Color(0xFF3D2500)
        : (isDark ? Colors.white : const Color(0xFF10131A));

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: message.type == 'image' ? 8 : 14,
              vertical: message.type == 'image' ? 8 : 12,
            ),
            decoration: BoxDecoration(
              gradient: bg,
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(22),
                topRight: const Radius.circular(22),
                bottomLeft: Radius.circular(isUser ? 22 : 8),
                bottomRight: Radius.circular(isUser ? 8 : 22),
              ),
              border: Border.all(
                color: isUser
                    ? Colors.transparent
                    : (isDark ? Colors.white12 : const Color(0xFFE7ECF4)),
              ),
            ),
            child: SelectableText(
              message.content ?? '',
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickReplies extends StatelessWidget {
  const _QuickReplies({
    required this.options,
    required this.onTap,
    required this.isDisabled,
    required this.isDark,
  });

  final List<ChatOption> options;
  final Function(ChatOption) onTap;
  final bool isDisabled;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : const Color(0xFF10131A);

    return Padding(
      padding: const EdgeInsets.only(left: 44, right: 12, bottom: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((option) {
          return InkWell(
            onTap: isDisabled ? null : () => onTap(option),
            borderRadius: BorderRadius.circular(999),
            child: AnimatedOpacity(
              opacity: isDisabled ? 0.45 : 1,
              duration: const Duration(milliseconds: 180),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1B2230)
                      : const Color(0xFFFFF6E8),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: kHomeAccentColor.withOpacity(0.18)),
                ),
                child: Text(
                  option.label,
                  style: TextStyle(
                    color: isDark ? Colors.white : textColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: isPrimary
                ? const LinearGradient(
                    colors: [Color(0xFFFFB545), Color(0xFFE47D00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isPrimary ? null : const Color(0xFFF6F8FC),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isPrimary ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
