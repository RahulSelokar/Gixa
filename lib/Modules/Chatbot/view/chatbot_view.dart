import 'dart:io';

import 'package:Gixa/Modules/Chatbot/controller/chatbot_controller.dart';
import 'package:Gixa/Modules/Chatbot/model/chatbot_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatView extends StatelessWidget {
  ChatView({super.key});

  /// ✅ Correct way: find existing controller
  final ChatController controller = Get.find<ChatController>();

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 80), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(
          scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Gixa Support"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: controller.clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          /// CHAT LIST
          Expanded(
            child: Obx(() {
              _scrollToBottom();

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: controller.messages.length,
                itemBuilder: (_, index) {
                  final message = controller.messages[index];

                  /// QUICK REPLIES (BOT MODE ONLY)
                  if (message.type == "options" &&
                      message.options != null &&
                      !controller.isHumanMode.value) {
                    return _QuickReplies(
                      options: message.options!,
                      onTap: controller.onBotOptionSelected,
                      isDark: isDark,
                      isDisabled: controller.isBotTyping.value,
                    );
                  }

                  return _ChatBubble(
                    message: message,
                    isDark: isDark,
                  );
                },
              );
            }),
          ),

          /// INPUT BAR (ONLY WHEN HUMAN MODE)
          Obx(() {
            if (!controller.isHumanMode.value) {
              return const SizedBox();
            }

            return _InputBar(
              controller: controller,
              textController: textController,
              isDark: isDark,
            );
          }),
        ],
      ),
    );
  }
}

// =========================================================
// CHAT BUBBLE
// =========================================================

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;

  const _ChatBubble({
    required this.message,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == "user";

    final bubbleColor = isUser
        ? Colors.indigo
        : isDark
            ? const Color(0xFF1E293B)
            : Colors.white;

    final textColor =
        isUser ? Colors.white : (isDark ? Colors.white : Colors.black87);

    final alignment =
        isUser ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft:
                isUser ? const Radius.circular(14) : Radius.zero,
            bottomRight:
                isUser ? Radius.zero : const Radius.circular(14),
          ),
        ),
        child: message.type == "image"
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  message.mediaUrl ?? "",
                  fit: BoxFit.cover,
                ),
              )
            : Text(
                message.content ?? "",
                style: TextStyle(color: textColor, fontSize: 15),
              ),
      ),
    );
  }
}

// =========================================================
// QUICK REPLIES
// =========================================================

class _QuickReplies extends StatelessWidget {
  final List<ChatOption> options;
  final Function(ChatOption) onTap;
  final bool isDark;
  final bool isDisabled;

  const _QuickReplies({
    required this.options,
    required this.onTap,
    required this.isDark,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((option) {
          return ActionChip(
            label: Text(option.label),
            backgroundColor: isDisabled
                ? Colors.grey.shade400
                : isDark
                    ? const Color(0xFF334155)
                    : Colors.grey.shade200,
            labelStyle: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: isDisabled ? null : () => onTap(option),
          );
        }).toList(),
      ),
    );
  }
}

// =========================================================
// INPUT BAR
// =========================================================

class _InputBar extends StatelessWidget {
  final ChatController controller;
  final TextEditingController textController;
  final bool isDark;

  const _InputBar({
    required this.controller,
    required this.textController,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF020617) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            )
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () async {
                final picker = ImagePicker();
                final file = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (file != null) {
                  controller.sendMediaMessage(File(file.path), "image");
                }
              },
            ),
            Expanded(
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: "Type your message...",
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF1E293B)
                      : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              color: Colors.indigo,
              onPressed: () {
                controller.sendTextMessage(textController.text);
                textController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
