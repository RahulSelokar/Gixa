import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controller/profile_progress_controller.dart';
import '../model/profile_section_model.dart';

// ─────────────────────────────────────────────
//  ENTRY WIDGET
// ─────────────────────────────────────────────
class ProfileCompletionSlider extends StatefulWidget {
  const ProfileCompletionSlider({super.key});

  @override
  State<ProfileCompletionSlider> createState() =>
      _ProfileCompletionSliderState();
}

class _ProfileCompletionSliderState extends State<ProfileCompletionSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.94);
  Timer? _autoScrollTimer;
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_totalPages > 1 && _pageController.hasClients) {
        final next = (_currentPage + 1) % _totalPages;
        _pageController.animateToPage(
          next,
          duration: Duration(milliseconds: next == 0 ? 800 : 600),
          curve: next == 0 ? Curves.fastOutSlowIn : Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() => _autoScrollTimer?.cancel();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileProgressController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      if (controller.isProfileComplete) return const SizedBox.shrink();

      final cards = controller.incompleteSectionCards;
      _totalPages = 1 + cards.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Listener(
            onPointerDown: (_) => _stopAutoScroll(),
            onPointerUp: (_) => _startAutoScroll(),
            child: SizedBox(
              height: 110,
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                physics: const BouncingScrollPhysics(),
                children: [
                  _MainProgressCard(controller),
                  ...cards.map((e) => _SectionCard(e)),
                ],
              ),
            ),
          ),
          if (_totalPages > 1) ...[
            const SizedBox(height: 10),
            SmoothPageIndicator(
              controller: _pageController,
              count: _totalPages,
              effect: WormEffect(
                dotHeight: 5,
                dotWidth: 5,
                activeDotColor: theme.primaryColor,
                dotColor: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
          ],
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────
//  MAIN PROGRESS CARD  — Naukri-style
// ─────────────────────────────────────────────
class _MainProgressCard extends StatelessWidget {
  final ProfileProgressController controller;
  const _MainProgressCard(this.controller);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final pct = controller.completionPercentInt;

    final cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.07)
        : Colors.black.withOpacity(0.07);
    final subtitleColor = isDark ? Colors.white38 : Colors.black38;
    final titleColor = isDark ? Colors.white : const Color(0xFF111111);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => Get.toNamed('/profile'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Circular avatar with arc progress ──
                _CircularProgressAvatar(
                  percent: controller.completionPercent,
                  percentInt: pct,
                  primaryColor: theme.primaryColor,
                  isDark: isDark,
                ),

                const SizedBox(width: 14),

                // ── Text block ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Your profile",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _subtext(pct),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: subtitleColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _actionLabel(pct),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Right chevron ──
                Icon(
                  Icons.chevron_right_rounded,
                  color: subtitleColor,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _subtext(int pct) {
    if (pct >= 90) return "Almost complete!";
    if (pct >= 60) return "Looking good, keep going";
    if (pct >= 30) return "Add more to stand out";
    return "Complete your profile";
  }

  String _actionLabel(int pct) {
    final remaining = controller.incompleteSectionCards.length;
    if (remaining == 0) return "View profile →";
    return "$remaining pending action${remaining > 1 ? 's' : ''}";
  }
}

// ─────────────────────────────────────────────
//  CIRCULAR PROGRESS AVATAR
// ─────────────────────────────────────────────
class _CircularProgressAvatar extends StatelessWidget {
  final double percent;
  final int percentInt;
  final Color primaryColor;
  final bool isDark;

  const _CircularProgressAvatar({
    required this.percent,
    required this.percentInt,
    required this.primaryColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arc painter
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: percent),
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeOutCubic,
            builder: (_, value, __) => CustomPaint(
              size: const Size(72, 72),
              painter: _ArcPainter(
                progress: value,
                primaryColor: primaryColor,
                trackColor: isDark
                    ? Colors.white10
                    : Colors.black.withOpacity(0.08),
              ),
            ),
          ),

          // Avatar image
          ClipOval(
            child: Image.asset(
              "assets/images/student.png",
              width: 52,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),

          // Percent label at bottom
          Positioned(
            bottom: 0,
            child: TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: percentInt),
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeOutCubic,
              builder: (_, val, __) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "$val%",
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  ARC PAINTER
// ─────────────────────────────────────────────
class _ArcPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color trackColor;

  _ArcPainter({
    required this.progress,
    required this.primaryColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 4;
    const strokeWidth = 4.0;
    const startAngle = math.pi * 0.75;
    const sweepTotal = math.pi * 1.5;

    // Track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal,
      false,
      Paint()
        ..color = trackColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Progress
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepTotal * progress.clamp(0.0, 1.0),
        false,
        Paint()
          ..color = primaryColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────
//  SECTION CARD  — Naukri-style (clean, light)
// ─────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final ProfileSectionCard data;
  const _SectionCard(this.data);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.07)
        : Colors.black.withOpacity(0.07);
    final titleColor = isDark ? Colors.white : const Color(0xFF111111);
    final subtitleColor = isDark ? Colors.white54 : Colors.black54;
    final boostColor = isDark
        ? const Color(0xFF4CAF50)
        : const Color(0xFF2E7D32);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => Get.toNamed(data.route),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Icon block ──
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(data.image, fit: BoxFit.contain),
                ),

                const SizedBox(width: 14),

                // ── Text ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Boost badge + title row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Boost ${data.boostPercent ?? 5}%",
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: boostColor,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Icon(
                            Icons.arrow_upward_rounded,
                            size: 11,
                            color: boostColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.title,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        data.description,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: subtitleColor,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // ── Action button ──
                OutlinedButton(
                  onPressed: () => Get.toNamed(data.route),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.primaryColor,
                    side: BorderSide(color: theme.primaryColor, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    data.actionLabel ?? "Add",
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BASE CARD  (kept for compatibility)
// ─────────────────────────────────────────────
class _BaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _BaseCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.07),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: child,
    );
  }
}
