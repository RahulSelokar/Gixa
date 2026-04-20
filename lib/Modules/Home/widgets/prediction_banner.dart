import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class PredictionBanner extends StatefulWidget {
  final VoidCallback? onTap;

  const PredictionBanner({super.key, this.onTap});

  @override
  State<PredictionBanner> createState() => _PredictionBannerState();
}

class _PredictionBannerState extends State<PredictionBanner>
    with TickerProviderStateMixin {
  // ── #1 Entry: slide-up + fade ─────────────────────────────────
  late final AnimationController _entryCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  // ── #2 Idle: rocket float loop ────────────────────────────────
  late final AnimationController _floatCtrl;
  late final Animation<Offset> _floatAnim;

  // ── #3 Idle: badge shimmer sweep ──────────────────────────────
  late final AnimationController _shimmerCtrl;
  late final Animation<double> _shimmerAnim;

  // ── #4 Press: scale feedback ──────────────────────────────────
  bool _isPressed = false;

  static const _kAccent = Color(0xFF1A56DB);

  @override
  void initState() {
    super.initState();

    // ── #1 Entry ─────────────────────────────────────────────────
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
    // Delay so it fires after the screen transition settles
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _entryCtrl.forward();
    });

    // ── #2 Rocket float ──────────────────────────────────────────
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _floatAnim = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.06),
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    // ── #3 Badge shimmer ──────────────────────────────────────────
    // Full cycle = 3400ms: 1400ms sweep + 2000ms pause via Interval
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(
        parent: _shimmerCtrl,
        curve: const Interval(0.0, 0.42, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _floatCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // ── #1 Entry ────────────────────────────────────────────────
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(position: _slideAnim, child: _buildCard()),
      ),
    );
  }

  Widget _buildCard() {
    return GestureDetector(
      // ── #4 Press ─────────────────────────────────────────────────
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 130,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A56DB), Color(0xFF1044B2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _kAccent.withOpacity(_isPressed ? 0.20 : 0.38),
                blurRadius: _isPressed ? 10 : 20,
                spreadRadius: -4,
                offset: Offset(0, _isPressed ? 4 : 10),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // ── decorative circles ──────────────────────────────
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.055),
                  ),
                ),
              ),
              Positioned(
                right: 60,
                bottom: -40,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),

              // ── left content ────────────────────────────────────
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 130, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── #3 Shimmer badge ────────────────────────
                      _ShimmerBadge(animation: _shimmerAnim),

                      const SizedBox(height: 6),

                      Text(
                        'College\nPredictor',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.15,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Find your best-fit colleges →',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.72),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── #2 Floating rocket ──────────────────────────────
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: SlideTransition(
                  position: _floatAnim,
                  child: Hero(
                    tag: 'predict_hero',
                    child: Image.asset(
                      'assets/images/genie2.png',
                      width: 128,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Icon(
                          Icons.rocket_launch_rounded,
                          size: 72,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shimmer badge widget ─────────────────────────────────────────────────────

class _ShimmerBadge extends StatelessWidget {
  final Animation<double> animation;

  const _ShimmerBadge({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final x = animation.value;
            return LinearGradient(
              begin: Alignment(x - 1.0, 0),
              end: Alignment(x, 0),
              colors: const [
                Colors.transparent,
                Color(0x35FFFFFF),
                Colors.transparent,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.22), width: 0.8),
        ),
        child: Text(
          'AI Powered',
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.9),
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }
}
