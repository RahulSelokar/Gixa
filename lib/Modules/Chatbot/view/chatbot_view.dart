import 'dart:io';
import 'package:Gixa/Modules/Chatbot/controller/chatbot_controller.dart';
import 'package:Gixa/Modules/Chatbot/model/chatbot_model.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatController controller = Get.find<ChatController>();
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  static const _botGradient = LinearGradient(
    colors: [Color(0xFFFFC857), Color(0xFFE68A00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPreviousSessions('general');
    });
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

      final offset = scrollController.position.maxScrollExtent;
      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = _ChatPalette.of(context);

    return Scaffold(
      backgroundColor: palette.scaffoldBackground,
      appBar: _buildAppBar(palette),
      endDrawer: Drawer(
        backgroundColor: palette.scaffoldBackground,
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
                        color: palette.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline_rounded, color: palette.accent),
                      tooltip: 'New Chat',
                      onPressed: () {
                        Get.back();
                        controller.startNewSession();
                        if (controller.autoStart) {
                          controller.startChat().then((_) {
                            controller.loadPreviousSessions('general');
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              Divider(color: palette.borderColor),
              Expanded(
                child: Obx(() {
                  if (controller.isFetchingSessions.value) {
                    return Center(child: CircularProgressIndicator(color: palette.accent));
                  }
                  
                  if (controller.previousSessions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 48, color: palette.secondaryText.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          Text(
                            'No previous chats found.',
                            style: TextStyle(color: palette.secondaryText),
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
                            color: palette.accent.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.chat_bubble_outline, color: palette.accent, size: 18),
                        ),
                        title: Text(
                          session.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: palette.primaryText, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            session.formattedDate,
                            style: TextStyle(color: palette.secondaryText, fontSize: 12),
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
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              palette.backgroundHighlight,
              palette.scaffoldBackground,
              palette.scaffoldBackground,
            ],
          ),
        ),
        child: Column(
          children: [
            _ChatStatusBanner(
              palette: palette,
              isHumanMode: controller.isHumanMode,
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.messages.isEmpty) {
                  return _LoadingState(palette: palette);
                }

                if (controller.messages.isEmpty) {
                  return _EmptyState(palette: palette);
                }

                _scrollToBottom();

                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
                  itemCount: controller.messages.length,
                  itemBuilder: (_, index) {
                    final msg = controller.messages[index];
                    final validOptions = msg.options
                        ?.where((option) => option.label.trim().isNotEmpty)
                        .toList();
                    final hasOptions =
                        validOptions != null && validOptions.isNotEmpty;

                    if (controller.isHumanMode.value && hasOptions) {
                      return const SizedBox.shrink();
                    }

                    if (hasOptions && !controller.isHumanMode.value) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((msg.content ?? '').trim().isNotEmpty)
                            _ChatBubble(message: msg, palette: palette),
                          _QuickReplies(
                            options: validOptions!,
                            onTap: controller.onBotOptionSelected,
                            isDisabled: controller.isBotTyping.value,
                            palette: palette,
                          ),
                        ],
                      );
                    }

                    if (controller.isHumanMode.value &&
                        hasOptions &&
                        (msg.content ?? '').trim().isNotEmpty) {
                      return _ChatBubble(message: msg, palette: palette);
                    }

                    return _ChatBubble(message: msg, palette: palette);
                  },
                );
              }),
            ),
            Obx(
              () => controller.isHumanMode.value
                  ? _InputBar(
                      controller: controller,
                      textController: textController,
                      palette: palette,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(_ChatPalette palette) {
    return AppBar(
      backgroundColor: palette.appBarBackground,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: palette.iconColor,
        ),
        onPressed: Get.back,
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _botGradient,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/images/genie.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                right: -1,
                bottom: -1,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: palette.appBarBackground,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gixa',
                style: TextStyle(
                  color: palette.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Online • AI assistant',
                style: TextStyle(
                  color: palette.secondaryText,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Builder(
          builder: (context) {
            return TextButton.icon(
              icon: Icon(Icons.history_rounded, color: palette.iconColor, size: 16),
              label: Text(
                'History',
                style: TextStyle(
                  color: palette.primaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
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
          icon: Icon(Icons.more_vert_rounded, color: palette.iconColor),
          color: palette.cardBackground,
          onSelected: (value) async {
            if (value != 'clear') return;

            final shouldClear = await Get.dialog<bool>(
              AlertDialog(
                backgroundColor: palette.cardBackground,
                title: Text(
                  'Clear chat?',
                  style: TextStyle(
                    color: palette.primaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                content: Text(
                  'This will remove all messages in this conversation.',
                  style: TextStyle(color: palette.secondaryText),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: palette.secondaryText),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: true),
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        color: palette.accent,
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
                  Icon(Icons.delete_outline_rounded, color: palette.accent),
                  const SizedBox(width: 8),
                  Text(
                    'Clear chat',
                    style: TextStyle(color: palette.primaryText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChatStatusBanner extends StatelessWidget {
  const _ChatStatusBanner({required this.palette, required this.isHumanMode});

  final _ChatPalette palette;
  final RxBool isHumanMode;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final humanMode = isHumanMode.value;

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: palette.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: palette.borderColor),
          boxShadow: [
            BoxShadow(
              color: palette.shadowColor,
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: palette.badgeBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                humanMode ? Icons.support_agent_rounded : Icons.auto_awesome,
                color: palette.accent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    humanMode ? 'Connected to support' : 'Smart admission help',
                    style: TextStyle(
                      color: palette.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    humanMode
                        ? 'Send your message below and continue the conversation.'
                        : 'Choose a quick reply or ask for a human counselor anytime.',
                    style: TextStyle(
                      color: palette.secondaryText,
                      fontSize: 12.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.palette});

  final _ChatPalette palette;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.6,
              valueColor: AlwaysStoppedAnimation<Color>(palette.accent),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Preparing your chat...',
            style: TextStyle(
              color: palette.secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.palette});

  final _ChatPalette palette;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: palette.badgeBackground,
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/images/genie.png'),
            ),
            const SizedBox(height: 16),
            Text(
              'Start a conversation',
              style: TextStyle(
                color: palette.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Ask about colleges, counselling, eligibility, or connect with support.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: palette.secondaryText,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, required this.palette});

  final ChatMessage message;
  final _ChatPalette palette;

  static const _userGradient = LinearGradient(
    colors: [Color(0xFFFFB545), Color(0xFFE47D00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == "user";
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                Container(
                  width: 34,
                  height: 34,
                  margin: const EdgeInsets.only(right: 12, bottom: 10),
                  decoration: BoxDecoration(
                    color: palette.badgeBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Image.asset(
                      'assets/images/genie.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: screenWidth * 0.72),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: message.type == "image" ? 8 : 14,
                    vertical: message.type == "image" ? 8 : 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: isUser ? _userGradient : null,
                    color: isUser ? null : palette.botBubbleBackground,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(22),
                      topRight: const Radius.circular(22),
                      bottomLeft: Radius.circular(isUser ? 22 : 8),
                      bottomRight: Radius.circular(isUser ? 8 : 22),
                    ),
                    border: Border.all(
                      color: isUser ? Colors.transparent : palette.borderColor,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isUser
                            ? kHomeAccentColor.withOpacity(0.18)
                            : palette.shadowColor,
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: message.type == "image"
                      ? _buildImage(message)
                      : message.type == "typing"
                      ? _TypingIndicator(palette: palette)
                      : SelectableText(
                          message.content ?? "",
                          style: TextStyle(
                            color: isUser
                                ? const Color(0xFF3D2500)
                                : palette.primaryText,
                            fontSize: 14,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ],
          ),
          // Padding(
          //   padding: EdgeInsets.only(
          //     top: 6,
          //     left: isUser ? 0 : 44,
          //     right: isUser ? 6 : 0,
          //   ),
          //   child: Text(
          //     isUser
          //         ? '${_formatTime(message.createdAt)} • You'
          //         : 'Genie • ${_formatTime(message.createdAt)}',
          //     style: TextStyle(
          //       fontSize: 11,
          //       color: palette.tertiaryText,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  String _formatTime(String? source) {
    final parsed = DateTime.tryParse(source ?? "");
    final dateTime = parsed?.toLocal() ?? DateTime.now();
    return DateFormat('h:mm a').format(dateTime);
  }

  Widget _buildImage(ChatMessage message) {
    final url = message.mediaUrl ?? "";

    if (url.isNotEmpty && !url.startsWith("http")) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(url),
          width: 220,
          height: 220,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.broken_image_outlined,
            size: 46,
            color: Colors.white54,
          ),
        ),
      );
    }

    if (url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          url,
          width: 220,
          height: 220,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.broken_image_outlined,
            size: 46,
            color: Colors.white54,
          ),
        ),
      );
    }

    return const Icon(Icons.image_outlined, size: 46, color: Colors.white54);
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator({required this.palette});

  final _ChatPalette palette;

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (_) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 550),
      )..repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => AnimatedBuilder(
          animation: _controllers[index],
          builder: (_, __) {
            final value = _controllers[index].value;
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.palette.accent.withOpacity(0.35 + (value * 0.55)),
              ),
              transform: Matrix4.translationValues(0, -3 * value, 0),
            );
          },
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
    required this.palette,
  });

  final List<ChatOption> options;
  final Function(ChatOption) onTap;
  final bool isDisabled;
  final _ChatPalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 44, right: 12, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick replies',
            style: TextStyle(
              color: palette.secondaryText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
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
                      color: palette.quickReplyBackground,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: palette.quickReplyBorder),
                    ),
                    child: Text(
                      option.label,
                      style: TextStyle(
                        color: palette.quickReplyText,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatefulWidget {
  const _InputBar({
    required this.controller,
    required this.textController,
    required this.palette,
  });

  final ChatController controller;
  final TextEditingController textController;
  final _ChatPalette palette;

  @override
  State<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<_InputBar> {
  bool get _hasText => widget.textController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    widget.textController.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    widget.textController.removeListener(_handleTextChanged);
    super.dispose();
  }

  void _handleTextChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      await widget.controller.sendMediaMessage(File(file.path), "image");
    }
  }

  void _sendMessage() {
    final text = widget.textController.text.trim();
    if (text.isEmpty) return;

    widget.controller.sendTextMessage(text);
    widget.textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        decoration: BoxDecoration(
          color: palette.inputBarBackground,
          border: Border(top: BorderSide(color: palette.borderColor)),
          boxShadow: [
            BoxShadow(
              color: palette.shadowColor,
              blurRadius: 16,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // _CircleActionButton(
            //   icon: Icons.attach_file_rounded,
            //   onTap: _pickImage,
            //   palette: palette,
            // ),
            // const SizedBox(width: 10),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 54),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: palette.inputBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _hasText
                        ? palette.accent.withOpacity(0.35)
                        : palette.borderColor,
                  ),
                ),
                child: TextField(
                  controller: widget.textController,
                  minLines: 1,
                  maxLines: 4,
                  cursorColor: palette.accent,
                  style: TextStyle(
                    color: palette.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Type your message',
                    hintStyle: TextStyle(
                      color: palette.tertiaryText,
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
            AnimatedOpacity(
              opacity: _hasText ? 1 : 0.7,
              duration: const Duration(milliseconds: 180),
              child: _CircleActionButton(
                icon: Icons.send_rounded,
                onTap: _sendMessage,
                palette: palette,
                isPrimary: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.icon,
    required this.onTap,
    required this.palette,
    this.isPrimary = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final _ChatPalette palette;
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
            color: isPrimary ? null : palette.badgeBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isPrimary ? Colors.transparent : palette.borderColor,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isPrimary ? Colors.white : palette.iconColor,
          ),
        ),
      ),
    );
  }
}

class _ChatPalette {
  const _ChatPalette({
    required this.scaffoldBackground,
    required this.backgroundHighlight,
    required this.appBarBackground,
    required this.cardBackground,
    required this.botBubbleBackground,
    required this.inputBarBackground,
    required this.inputBackground,
    required this.badgeBackground,
    required this.borderColor,
    required this.shadowColor,
    required this.primaryText,
    required this.secondaryText,
    required this.tertiaryText,
    required this.iconColor,
    required this.accent,
    required this.quickReplyBackground,
    required this.quickReplyBorder,
    required this.quickReplyText,
  });

  final Color scaffoldBackground;
  final Color backgroundHighlight;
  final Color appBarBackground;
  final Color cardBackground;
  final Color botBubbleBackground;
  final Color inputBarBackground;
  final Color inputBackground;
  final Color badgeBackground;
  final Color borderColor;
  final Color shadowColor;
  final Color primaryText;
  final Color secondaryText;
  final Color tertiaryText;
  final Color iconColor;
  final Color accent;
  final Color quickReplyBackground;
  final Color quickReplyBorder;
  final Color quickReplyText;

  factory _ChatPalette.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return _ChatPalette(
        scaffoldBackground: const Color(0xFF0B1120),
        backgroundHighlight: const Color(0xFF15213A),
        appBarBackground: const Color(0xFF0B1120),
        cardBackground: const Color(0xFF121A2B),
        botBubbleBackground: const Color(0xFF162033),
        inputBarBackground: const Color(0xFF0B1120),
        inputBackground: const Color(0xFF162033),
        badgeBackground: const Color(0xFF1A2438),
        borderColor: Colors.white.withOpacity(0.08),
        shadowColor: Colors.black.withOpacity(0.25),
        primaryText: Colors.white,
        secondaryText: Colors.white.withOpacity(0.7),
        tertiaryText: Colors.white.withOpacity(0.48),
        iconColor: Colors.white.withOpacity(0.82),
        accent: const Color(0xFFFFB545),
        quickReplyBackground: const Color(0xFF1A2438),
        quickReplyBorder: const Color(0xFFFFB545).withOpacity(0.22),
        quickReplyText: const Color(0xFFFFD38A),
      );
    }

    return _ChatPalette(
      scaffoldBackground: const Color(0xFFF4F7FB),
      backgroundHighlight: const Color(0xFFFFF3DE),
      appBarBackground: Colors.white,
      cardBackground: Colors.white,
      botBubbleBackground: Colors.white,
      inputBarBackground: Colors.white,
      inputBackground: const Color(0xFFF6F8FC),
      badgeBackground: const Color(0xFFFFF1D8),
      borderColor: const Color(0xFFE4E9F2),
      shadowColor: Colors.black.withOpacity(0.05),
      primaryText: const Color(0xFF132238),
      secondaryText: const Color(0xFF596579),
      tertiaryText: const Color(0xFF8591A6),
      iconColor: const Color(0xFF334155),
      accent: kHomeAccentColor,
      quickReplyBackground: const Color(0xFFFFF6E8),
      quickReplyBorder: const Color(0xFFFFD9A6),
      quickReplyText: const Color(0xFF9A5A00),
    );
  }
}
