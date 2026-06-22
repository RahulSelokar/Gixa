import 'package:Gixa/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBotFloatingButton extends StatefulWidget {
  final VoidCallback onTap;

  const ChatBotFloatingButton({super.key, required this.onTap});

  @override
  State<ChatBotFloatingButton> createState() => _ChatBotFloatingButtonState();
}

class _ChatBotFloatingButtonState extends State<ChatBotFloatingButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hintController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _liftAnimation;

  @override
  void initState() {
    super.initState();
    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _hintController,
      curve: Curves.easeInOut,
    );
    _liftAnimation = Tween<double>(begin: 0, end: -4).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgGradient = isDark
        ? [const Color(0xFF1E2A3A), const Color(0xFF101826)]
        : [const Color(0xFFEAF3FF), const Color(0xFFD6E8FF)];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// ✨ Hint Bubble
            AnimatedBuilder(
              animation: _hintController,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.5 + (_fadeAnimation.value * 0.5),
                  child: Transform.translate(
                    offset: Offset(0, _liftAnimation.value),
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                margin: const EdgeInsets.only(bottom: 0, right: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: bgGradient),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  "Ask Gixa..",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ),

            /// 🧞 Genie Button
            Hero(
              tag: 'home_chat_bot_genie',
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// 🔥 Glow Effect
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          kHomeAccentColor.withOpacity(0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  /// 💎 Glass Circle Background

                  /// 🧞 Genie Image
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Image.asset(
                      'assets/images/genie.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}