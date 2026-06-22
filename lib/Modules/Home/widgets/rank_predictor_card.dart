import 'dart:math' as math;

import 'package:Gixa/Modules/Home/constants/home_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RankPredictorShortcutCard extends StatefulWidget {
  final VoidCallback onTap;

  const RankPredictorShortcutCard({super.key, required this.onTap});

  @override
  State<RankPredictorShortcutCard> createState() =>
      _RankPredictorShortcutCardState();
}

class _RankPredictorShortcutCardState extends State<RankPredictorShortcutCard>
    with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _pressCtrl;
  late final AnimationController _entranceCtrl;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    // Pulse glow
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _pulseAnim = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);

    // Shimmer sweep
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Press scale
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.965,
    ).animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut));

    // Entrance
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceCtrl,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entranceCtrl.forward();
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _shimmerCtrl.dispose();
    _pressCtrl.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    _pressCtrl.forward();
    setState(() => _isHovered = true);
  }

  void _onTapUp(_) {
    _pressCtrl.reverse();
    setState(() => _isHovered = false);
  }

  void _onTapCancel() {
    _pressCtrl.reverse();
    setState(() => _isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onTap();
            },
            child: AnimatedBuilder(
              animation: Listenable.merge([_pulseCtrl, _shimmerCtrl]),
              builder: (context, child) {
                return _CardBody(
                  isDark: isDark,
                  isHovered: _isHovered,
                  pulseValue: _pulseAnim.value,
                  shimmerValue: _shimmerCtrl.value,
                  child: child!,
                );
              },
              child: const _GradientRankPredictorContent(),
            ),
          ),
        ),
      ),
    );
  }
}
class _CardBody extends StatelessWidget {
  final bool isDark;
  final bool isHovered;
  final double pulseValue;
  final double shimmerValue;
  final Widget child;

  const _CardBody({
    required this.isDark,
    required this.isHovered,
    required this.pulseValue,
    required this.shimmerValue,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final glowOpacity = 0.16 + pulseValue * (isDark ? 0.18 : 0.12);
    final borderOpacity = isHovered ? 0.78 : (0.36 + pulseValue * 0.18);
    final cardGradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF1A2240), Color(0xFF311A53), Color(0xFF5A1E4D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFFF9D2F), Color(0xFFFF5B7C), Color(0xFF7B3FE4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8A00).withOpacity(glowOpacity),
            blurRadius: 24 + pulseValue * 16,
            spreadRadius: 1 + pulseValue * 2,
          ),
          BoxShadow(
            color: const Color(0xFF7B3FE4).withOpacity(glowOpacity * 0.85),
            blurRadius: 28 + pulseValue * 12,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.38 : 0.14),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: CustomPaint(
          painter: _ShimmerBorderPainter(
            shimmerValue: shimmerValue,
            borderOpacity: borderOpacity,
            isDark: isDark,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: cardGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(isDark ? 0.06 : 0.14),
                          Colors.transparent,
                          Colors.black.withOpacity(isDark ? 0.10 : 0.04),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -28,
                  right: -24,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(isDark ? 0.18 : 0.22),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -36,
                  left: -18,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(
                            0xFFFF8A00,
                          ).withOpacity(isDark ? 0.24 : 0.28),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 18,
                  top: 18,
                  child: Transform.rotate(
                    angle: 0.28,
                    child: Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                    ),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shimmer border painter
// ─────────────────────────────────────────────────────────────────────────────
class _ShimmerBorderPainter extends CustomPainter {
  final double shimmerValue;
  final double borderOpacity;
  final bool isDark;

  const _ShimmerBorderPainter({
    required this.shimmerValue,
    required this.borderOpacity,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(24),
    );

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.35
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(borderOpacity * 0.95),
          kBrandColors[1].withOpacity(borderOpacity * 0.9),
          Colors.white.withOpacity(borderOpacity * 0.88),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size);
    canvas.drawRRect(rect, basePaint);

    final shimmerAngle = shimmerValue * math.pi * 2;
    final cx = size.width / 2 + math.cos(shimmerAngle) * size.width * 0.55;
    final cy = size.height / 2 + math.sin(shimmerAngle) * size.height * 0.55;
    final shimmerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(isDark ? 0.55 : 0.80),
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: 60));
    canvas.drawRRect(rect, shimmerPaint);
  }

  @override
  bool shouldRepaint(_ShimmerBorderPainter old) =>
      old.shimmerValue != shimmerValue ||
      old.borderOpacity != borderOpacity ||
      old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated icon box — rotates gradient + uses app image
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedIconBox extends StatefulWidget {
  @override
  State<_AnimatedIconBox> createState() => _AnimatedIconBoxState();
}

class _AnimatedIconBoxState extends State<_AnimatedIconBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _rotate = CurvedAnimation(parent: _ctrl, curve: Curves.linear);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotate,
      builder: (_, child) {
        return Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF3D6B).withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
            gradient: SweepGradient(
              colors: [
                const Color(0xFFFF8A00),
                const Color(0xFFFF3D6B),
                const Color(0xFF7B3FE4),
                const Color(0xFF3D7FFF),
                const Color(0xFFFF8A00),
              ],
              transform: GradientRotation(_rotate.value * math.pi * 2),
            ),
          ),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Image.asset('assets/icons/gixxa4.png', fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _GradientRankPredictorContent extends StatelessWidget {
  const _GradientRankPredictorContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isTablet = width >= 600;
        final cardHeight = isTablet ? 240.0 : 200.0;
        final imageWidth = isTablet ? width * 0.28 : 128.0;

        return SizedBox(
          height: cardHeight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isTablet ? 24 : 22,
              isTablet ? 22 : 20,
              isTablet ? 18 : 16,
              isTablet ? 22 : 20,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? width * 0.56 : width,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _PredictorTag(),
                        const SizedBox(height: 10),
                        Text(
                          isTablet ? 'Rank Predictor' : 'Rank\nPredictor',
                          style: GoogleFonts.inter(
                            fontSize: isTablet ? 20 : 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.4,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Estimate your NEET rank and move straight into smarter college planning.',
                          style: GoogleFonts.inter(
                            fontSize: isTablet ? 14 : 10,
                            color: Colors.white.withOpacity(0.88),
                            height: 1.20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: isTablet ? 14 : 10),
                        // Wrap(
                        //   spacing: 8,
                        //   runSpacing: 8,
                        //   children: const [
                        //     _PredictorMiniPill(label: 'AI powered'),
                        //     _PredictorMiniPill(label: 'Fast result'),
                        //   ],
                        // ),
                        // SizedBox(height: isTablet ? 18 : 14),
                        const _PredictorCta(),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 8),
                SizedBox(
                  width: imageWidth,
                  child: Image.asset(
                    'assets/icons/gixxa5.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.auto_graph_rounded,
                      size: isTablet ? 92 : 70,
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PredictorTag extends StatelessWidget {
  const _PredictorTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE2A8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFE2A8).withOpacity(0.45),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'Smart predictor',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _PredictorCta extends StatelessWidget {
  const _PredictorCta();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFFFF1F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Try now',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF24123B),
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.arrow_forward_rounded,
            color: Color(0xFFFF5B7C),
            size: 14,
          ),
        ],
      ),
    );
  }
}