import 'dart:ui';

import 'package:Gixa/Modules/predication/controller/prediction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatBotPredictionView extends StatefulWidget {
  const ChatBotPredictionView({super.key});

  @override
  State<ChatBotPredictionView> createState() =>
      _ChatBotPredictionViewState();
}

class _ChatBotPredictionViewState
    extends State<ChatBotPredictionView> {

  final controller =
      Get.find<PredictionController>();

  static const Color primary =
      Color(0xFFEC8B04);

  static const Color secondary =
      Color(0xFFFFB347);

  @override
  void initState() {
    super.initState();

    controller.startChatBot();
  }

  @override
  Widget build(BuildContext context) {

    final isDark =
        Theme.of(context).brightness ==
        Brightness.dark;

    return Scaffold(

      backgroundColor: isDark
          ? const Color(0xFF07111F)
          : const Color(0xFFF7F9FC),

      body: Stack(

        children: [

          /// BACKGROUND GLOW
          Positioned(
            top: -120,
            left: -60,
            child: _glowBall(
              primary.withOpacity(0.25),
              260,
            ),
          ),

          Positioned(
            bottom: -120,
            right: -40,
            child: _glowBall(
              secondary.withOpacity(0.18),
              240,
            ),
          ),

          SafeArea(

            child: Column(

              children: [

                _header(isDark),

                Expanded(

                  child: Obx(() {

                    return ListView.builder(

                      controller:
                          controller
                              .chatScrollController,

                      physics:
                          const BouncingScrollPhysics(),

                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior
                              .onDrag,

                      padding:
                          const EdgeInsets.fromLTRB(
                        16,
                        18,
                        16,
                        40,
                      ),

                      itemCount:
                          controller.messages.length +
                          (controller.isBotTyping
                                  .value
                              ? 1
                              : 0),

                      itemBuilder:
                          (context, index) {

                        /// TYPING
                        if (controller
                                .isBotTyping
                                .value &&
                            index ==
                                controller
                                    .messages
                                    .length) {

                          return Padding(

                            padding:
                                const EdgeInsets.only(
                              bottom: 18,
                            ),

                            child:
                                _typingIndicator(
                              isDark,
                            ),
                          );
                        }

                        final msg =
                            controller
                                .messages[index];

                        return AnimatedContainer(

                          duration:
                              const Duration(
                            milliseconds: 300,
                          ),

                          curve: Curves.easeOut,

                          margin:
                              const EdgeInsets.only(
                            bottom: 18,
                          ),

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              if (msg.isBot)
                                _botBubble(
                                  msg.message,
                                  isDark,
                                ),

                              if (!msg.isBot)
                                _userBubble(
                                  msg.message,
                                  isDark,
                                ),

                              /// OPTIONS
                              if (msg.options !=
                                  null)
                                Padding(

                                  padding:
                                      const EdgeInsets.only(
                                    left: 58,
                                    top: 14,
                                  ),

                                  child: Wrap(

                                    spacing: 10,
                                    runSpacing: 10,

                                    children:
                                        msg.options!
                                            .map(
                                      (e) {

                                        return _optionChip(
                                          e,
                                          () {

                                            controller
                                                .handleAnswer(
                                              key: msg
                                                  .questionKey!,
                                              answer:
                                                  e,
                                            );
                                          },
                                          isDark,
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// HEADER
  Widget _header(bool isDark) {

    return ClipRRect(

      borderRadius:
          const BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),

      child: BackdropFilter(

        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),

        child: Container(

          padding:
              const EdgeInsets.fromLTRB(
            18,
            12,
            18,
            20,
          ),

          decoration: BoxDecoration(

            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.75),

            border: Border(

              bottom: BorderSide(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.04),
              ),
            ),
          ),

          child: Row(

            children: [

              /// AVATAR
              Container(

                width: 56,
                height: 56,

                decoration: BoxDecoration(

                  shape: BoxShape.circle,

                  gradient:
                      const LinearGradient(
                    colors: [
                      primary,
                      secondary,
                    ],
                  ),

                  boxShadow: [

                    BoxShadow(
                      color:
                          primary.withOpacity(
                        0.45,
                      ),
                      blurRadius: 24,
                    ),
                  ],
                ),

                child: Padding(
                  padding:
                      const EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/icons/Gixxa1.png",
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      "Gixa AI Counselor",

                      style: TextStyle(

                        color: isDark
                            ? Colors.white
                            : Colors.black87,

                        fontSize: 18,

                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(

                      children: [

                        Container(

                          width: 8,
                          height: 8,

                          decoration:
                              BoxDecoration(

                            color: const Color(
                              0xFF10B981,
                            ),

                            shape:
                                BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 6),

                        Text(

                          "Online • AI Powered",

                          style: TextStyle(

                            color: isDark
                                ? Colors.white60
                                : Colors.black54,

                            fontSize: 12,

                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              GestureDetector(

                onTap: () {
                  Get.back();
                },

                child: Container(

                  padding:
                      const EdgeInsets.all(10),

                  decoration: BoxDecoration(

                    color: isDark
                        ? Colors.white
                            .withOpacity(0.05)
                        : Colors.black
                            .withOpacity(0.04),

                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.close_rounded,
                    color: isDark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// BOT MESSAGE
  Widget _botBubble(
    String text,
    bool isDark,
  ) {

    return Row(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Container(

          width: 42,
          height: 42,

          decoration: BoxDecoration(

            shape: BoxShape.circle,

            gradient:
                const LinearGradient(
              colors: [
                primary,
                secondary,
              ],
            ),
          ),

          child: Padding(
            padding:
                const EdgeInsets.all(8),
            child: Image.asset(
              "assets/icons/Gixxa1.png",
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(

          child: Container(

            padding:
                const EdgeInsets.all(16),

            decoration: BoxDecoration(

              color: isDark
                  ? Colors.white
                      .withOpacity(0.06)
                  : Colors.white,

              borderRadius:
                  BorderRadius.circular(24),

              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.03),
              ),

              boxShadow: [

                BoxShadow(
                  color:
                      Colors.black.withOpacity(
                    isDark ? 0.22 : 0.04,
                  ),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),

            child: Text(

              text,

              style: TextStyle(

                color: isDark
                    ? Colors.white
                    : Colors.black87,

                fontSize: 14,

                fontWeight:
                    FontWeight.w500,

                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// USER BUBBLE
  Widget _userBubble(
    String text,
    bool isDark,
  ) {

    return Align(

      alignment: Alignment.centerRight,

      child: Container(

        constraints:
            const BoxConstraints(
          maxWidth: 280,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),

        decoration: BoxDecoration(

          gradient:
              const LinearGradient(
            colors: [
              primary,
              secondary,
            ],
          ),

          borderRadius:
              BorderRadius.circular(24),

          boxShadow: [

            BoxShadow(
              color:
                  primary.withOpacity(0.28),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Text(

          text,

          style: const TextStyle(

            color: Colors.white,

            fontSize: 14,

            fontWeight: FontWeight.w600,

            height: 1.5,
          ),
        ),
      ),
    );
  }

  /// OPTION CHIP
  Widget _optionChip(
    String text,
    VoidCallback onTap,
    bool isDark,
  ) {

    return InkWell(

      borderRadius:
          BorderRadius.circular(18),

      onTap: onTap,

      child: AnimatedContainer(

        duration:
            const Duration(
          milliseconds: 250,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 13,
        ),

        decoration: BoxDecoration(

          color: isDark
              ? Colors.white
                  .withOpacity(0.05)
              : Colors.white,

          borderRadius:
              BorderRadius.circular(18),

          border: Border.all(
            color:
                primary.withOpacity(0.25),
          ),

          boxShadow: [

            BoxShadow(
              color:
                  Colors.black.withOpacity(
                isDark ? 0.16 : 0.05,
              ),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Text(

          text,

          style: TextStyle(

            color: isDark
                ? Colors.white
                : Colors.black87,

            fontWeight:
                FontWeight.w600,

            fontSize: 13,
          ),
        ),
      ),
    );
  }

  /// TYPING
  Widget _typingIndicator(
    bool isDark,
  ) {

    return Row(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Container(

          width: 42,
          height: 42,

          decoration: const BoxDecoration(

            shape: BoxShape.circle,

            gradient:
                LinearGradient(
              colors: [
                primary,
                secondary,
              ],
            ),
          ),

          child: Padding(
            padding:
                const EdgeInsets.all(8),
            child: Image.asset(
              "assets/icons/Gixxa1.png",
            ),
          ),
        ),

        const SizedBox(width: 12),

        Container(

          padding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),

          decoration: BoxDecoration(

            color: isDark
                ? Colors.white
                    .withOpacity(0.06)
                : Colors.white,

            borderRadius:
                BorderRadius.circular(22),
          ),

          child: Row(

            mainAxisSize:
                MainAxisSize.min,

            children: [

              _dot(),
              const SizedBox(width: 4),

              _dot(),
              const SizedBox(width: 4),

              _dot(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dot() {

    return TweenAnimationBuilder<double>(

      tween: Tween(
        begin: 0.2,
        end: 1,
      ),

      duration:
          const Duration(
        milliseconds: 600,
      ),

      builder:
          (context, value, child) {

        return Opacity(

          opacity: value,

          child: Container(

            width: 7,
            height: 7,

            decoration:
                const BoxDecoration(

              color: primary,

              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  /// GLOW
  Widget _glowBall(
    Color color,
    double size,
  ) {

    return Container(

      width: size,
      height: size,

      decoration: BoxDecoration(

        shape: BoxShape.circle,

        gradient: RadialGradient(

          colors: [
            color,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}