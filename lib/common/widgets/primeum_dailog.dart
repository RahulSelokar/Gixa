import 'package:Gixa/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// ── Show helper ──────────────────────────────────────────────────────────────
void showPremiumLockDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'premium_lock',
    barrierColor: Colors.black.withOpacity(0.55),
    transitionDuration: const Duration(milliseconds: 360),
    transitionBuilder: (_, anim, __, child) {
      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.85,
          end: 1.0,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutBack)),
        child: FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: child,
        ),
      );
    },
    pageBuilder: (_, __, ___) => const PremiumLockDialog(),
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class PremiumLockDialog extends StatefulWidget {
  const PremiumLockDialog({super.key});

  @override
  State<PremiumLockDialog> createState() => _PremiumLockDialogState();
}

class _PremiumLockDialogState extends State<PremiumLockDialog>
    with TickerProviderStateMixin {
  // Controllers
  late final AnimationController _iconCtrl;
  late final AnimationController _contentCtrl;
  late final AnimationController _shimmerCtrl;

  // Icon
  late final Animation<double> _iconScale;
  late final Animation<double> _iconRotate;

  // Content stagger
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subFade;
  late final Animation<Offset> _subSlide;
  late final Animation<double> _btnsFade;
  late final Animation<Offset> _btnsSlide;

  // Shimmer
  late final Animation<double> _shimmerAnim;

  // Press
  bool _ctaPressed = false;

  static const _kGold = Color(0xFFE6A817);
  static const _kGoldDark = Color(0xFFB8850F);

  @override
  void initState() {
    super.initState();

    // ── Icon bounce ───────────────────────────────────────────
    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 580),
    );
    _iconScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _iconCtrl, curve: Curves.elasticOut));
    _iconRotate = Tween<double>(
      begin: -0.12,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _iconCtrl, curve: Curves.easeOutCubic));

    // ── Staggered content ─────────────────────────────────────
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _titleFade = _fade(_contentCtrl, 0.00, 0.50);
    _titleSlide = _slide(_contentCtrl, 0.00, 0.50);
    _subFade = _fade(_contentCtrl, 0.20, 0.70);
    _subSlide = _slide(_contentCtrl, 0.20, 0.70);
    _btnsFade = _fade(_contentCtrl, 0.45, 1.00);
    _btnsSlide = _slide(_contentCtrl, 0.45, 1.00);

    // ── CTA shimmer ───────────────────────────────────────────
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -2.0, end: 3.0).animate(
      CurvedAnimation(
        parent: _shimmerCtrl,
        curve: const Interval(0.0, 0.42, curve: Curves.easeInOut),
      ),
    );

    // Fire after dialog entrance settles
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _iconCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 220), () {
      if (mounted) _contentCtrl.forward();
    });
  }

  Animation<double> _fade(AnimationController c, double b, double e) =>
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: c,
          curve: Interval(b, e, curve: Curves.easeOutCubic),
        ),
      );

  Animation<Offset> _slide(AnimationController c, double b, double e) =>
      Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
        CurvedAnimation(
          parent: c,
          curve: Interval(b, e, curve: Curves.easeOutCubic),
        ),
      );

  @override
  void dispose() {
    _iconCtrl.dispose();
    _contentCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Use screen width to keep dialog comfortably sized on all phones
    final screenW = MediaQuery.of(context).size.width;
    final dialogW = screenW.clamp(0.0, 380.0);

    return Dialog(
      backgroundColor: Colors.transparent,
      // No horizontal insetPadding — we size ourselves
      insetPadding: EdgeInsets.symmetric(
        horizontal: ((screenW - dialogW) / 2).clamp(20.0, 60.0),
        vertical: 24,
      ),
      child: Container(
        width: dialogW,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C2E) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.50 : 0.16),
              blurRadius: 36,
              spreadRadius: -6,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        // ClipRRect must wrap ALL children so decorative elements are cropped
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── top banner (fixed height, no Positioned needed) ──
              _TopBanner(isDark: isDark),

              // ── scrollable body (prevents overflow on tiny screens) ──
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // icon sits half over the banner
                      Transform.translate(
                        offset: const Offset(0, -34),
                        child: _buildIcon(),
                      ),

                      // pull content up to compensate for the translate
                      const SizedBox(height: 0),
                      Transform.translate(
                        offset: const Offset(0, -28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title
                            FadeTransition(
                              opacity: _titleFade,
                              child: SlideTransition(
                                position: _titleSlide,
                                child: Text(
                                  'Unlock Premium',
                                  style: GoogleFonts.inter(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF1A1A2E),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Subtitle
                            FadeTransition(
                              opacity: _subFade,
                              child: SlideTransition(
                                position: _subSlide,
                                child: Text(
                                  'This feature is exclusive to Premium\nmembers. Upgrade to get full access.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    height: 1.55,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Perk chips — Wrap instead of Row to never overflow
                            // FadeTransition(
                            //   opacity: _subFade,
                            //   child: SlideTransition(
                            //     position: _subSlide,
                            //     child: Wrap(
                            //       alignment: WrapAlignment.center,
                            //       spacing: 7,
                            //       runSpacing: 7,
                            //       children: [
                            //         _perkChip('Unlimited Access', isDark),
                            //         _perkChip('AI Features', isDark),
                            //         _perkChip('Priority Support', isDark),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 20),

                            // Buttons
                            FadeTransition(
                              opacity: _btnsFade,
                              child: SlideTransition(
                                position: _btnsSlide,
                                child: _buildButtons(isDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Icon ────────────────────────────────────────────────────────────────────
  Widget _buildIcon() {
    return AnimatedBuilder(
      animation: _iconCtrl,
      builder: (_, child) => Transform.rotate(
        angle: _iconRotate.value,
        child: Transform.scale(scale: _iconScale.value, child: child),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer halo
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _kGold.withOpacity(0.12),
            ),
          ),
          // Inner gold circle
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFB300), Color(0xFFE65100)],
              ),
              boxShadow: [
                BoxShadow(
                  color: _kGold.withOpacity(0.42),
                  blurRadius: 20,
                  spreadRadius: -4,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ── Buttons ─────────────────────────────────────────────────────────────────
  Widget _buildButtons(bool isDark) {
    return Row(
      children: [
        // Later
        Expanded(
          child: TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  width: 1.2,
                ),
              ),
            ),
            child: Text(
              'Later',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white60 : Colors.grey.shade600,
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Go Premium
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTapDown: (_) {
              HapticFeedback.lightImpact();
              setState(() => _ctaPressed = true);
            },
            onTapUp: (_) {
              setState(() => _ctaPressed = false);
              Get.back();
              Get.toNamed(AppRoutes.subscription);
            },
            onTapCancel: () => setState(() => _ctaPressed = false),
            child: AnimatedScale(
              scale: _ctaPressed ? 0.96 : 1.0,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              child: AnimatedBuilder(
                animation: _shimmerCtrl,
                builder: (_, child) => ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (bounds) {
                    final x = _shimmerAnim.value;
                    return LinearGradient(
                      begin: Alignment(x - 1, 0),
                      end: Alignment(x, 0),
                      colors: const [
                        Colors.transparent,
                        Color(0x40FFFFFF),
                        Colors.transparent,
                      ],
                    ).createShader(bounds);
                  },
                  child: child,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFB300), Color(0xFFE65100)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: _kGold.withOpacity(_ctaPressed ? 0.18 : 0.38),
                        blurRadius: _ctaPressed ? 6 : 16,
                        spreadRadius: -4,
                        offset: Offset(0, _ctaPressed ? 2 : 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.workspace_premium_rounded,
                        size: 15,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Go Premium',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Perk chip ────────────────────────────────────────────────────────────────
  Widget _perkChip(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _kGold.withOpacity(isDark ? 0.15 : 0.10),
        border: Border.all(
          color: _kGold.withOpacity(isDark ? 0.30 : 0.22),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isDark ? _kGold : _kGoldDark,
        ),
      ),
    );
  }
}

// ── Top banner (self-contained, no Positioned needed) ──────────────────────────
class _TopBanner extends StatelessWidget {
  final bool isDark;
  const _TopBanner({required this.isDark});

  static const _kGold = Color(0xFFE6A817);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Gradient fill
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFFB300).withOpacity(isDark ? 0.22 : 0.18),
                    const Color(0xFFFF8F00).withOpacity(isDark ? 0.10 : 0.07),
                  ],
                ),
              ),
            ),
          ),
          // Deco circle top-right
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kGold.withOpacity(0.10),
              ),
            ),
          ),
          // Deco circle top-left
          Positioned(
            top: 20,
            left: -18,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kGold.withOpacity(0.07),
              ),
            ),
          ),
          // Star particles — all within this 96px height, safe from overflow
          ..._stars(),
        ],
      ),
    );
  }

  List<Widget> _stars() {
    final list = [
      (l: 22.0, t: 18.0, s: 8.0, o: 0.55),
      (l: 58.0, t: 10.0, s: 5.0, o: 0.35),
      (l: 130.0, t: 14.0, s: 7.0, o: 0.40),
      (l: 190.0, t: 8.0, s: 6.0, o: 0.45),
      (l: 230.0, t: 26.0, s: 4.0, o: 0.30),
    ];
    return list
        .map(
          (p) => Positioned(
            left: p.l,
            top: p.t,
            child: Opacity(
              opacity: p.o,
              child: Icon(Icons.star_rounded, size: p.s, color: _kGold),
            ),
          ),
        )
        .toList();
  }
}
