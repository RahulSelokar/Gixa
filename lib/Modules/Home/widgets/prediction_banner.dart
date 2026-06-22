import 'package:Gixa/common/utils/app_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PredictionBanner extends StatefulWidget {
  final VoidCallback? onTap;

  const PredictionBanner({super.key, this.onTap});

  @override
  State<PredictionBanner> createState() => _PredictionBannerState();
}

class _PredictionBannerState extends State<PredictionBanner>
    with TickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;
  late final AnimationController _floatCtrl;
  late final Animation<Offset> _floatAnim;
  late final AnimationController _shimmerCtrl;
  late final Animation<double> _shimmerAnim;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

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

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _entryCtrl.forward();
    });

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _floatAnim = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.06),
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

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
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.horizontalPadding(context),
      ),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(position: _slideAnim, child: _buildCard()),
      ),
    );
  }

  Widget _buildCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isTablet = width >= 600;
        final imageWidth = isTablet ? width * 0.27 : 130.0;
        final cardHeight = isTablet ? 250.0 : 200.0;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
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
              height: cardHeight,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF8A00),
                    Color(0xFFFF3D6B),
                    Color(0xFF7B3FE4),
                    Color(0xFF3A8DFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF3D6B).withOpacity(
                      _isPressed ? 0.25 : 0.45,
                    ),
                    blurRadius: _isPressed ? 12 : 26,
                    spreadRadius: -6,
                    offset: Offset(0, _isPressed ? 4 : 12),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned(
                    right: -30,
                    top: -30,
                    child: Container(
                      width: isTablet ? 150 : 120,
                      height: isTablet ? 150 : 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.10),
                      ),
                    ),
                  ),
                  Positioned(
                    right: isTablet ? 90 : 60,
                    bottom: -40,
                    child: Container(
                      width: isTablet ? 120 : 90,
                      height: isTablet ? 120 : 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      isTablet ? 24 : 20,
                      isTablet ? 22 : 18,
                      isTablet ? 20 : 12,
                      isTablet ? 22 : 18,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: isTablet ? width * 0.55 : width,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _ShimmerBadge(animation: _shimmerAnim),
                                const SizedBox(height: 8),
                                Text(
                                  isTablet
                                      ? 'College Predictor'
                                      : 'College\nPredictor',
                                  style: GoogleFonts.inter(
                                    fontSize: isTablet ? 24 : 15,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    height: 1.2,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'AI That Predicts Your Perfect Medical College Match',
                                  style: GoogleFonts.inter(
                                    fontSize: isTablet ? 14 : 10.5,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                SizedBox(height: isTablet ? 16 : 8),
                                _AnimatedPredictButton(
                                  onTap: widget.onTap,
                                  isTablet: isTablet,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: isTablet ? 16 : 8),
                        SizedBox(
                          width: imageWidth,
                          child: SlideTransition(
                            position: _floatAnim,
                            child: Hero(
                              tag: 'predict_hero',
                              child: Image.asset(
                                'assets/images/genie2.png',
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Icon(
                                    Icons.auto_awesome_rounded,
                                    size: isTablet ? 90 : 70,
                                    color: Colors.white.withOpacity(0.95),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedPredictButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isTablet;

  const _AnimatedPredictButton({this.onTap, required this.isTablet});

  @override
  State<_AnimatedPredictButton> createState() => _AnimatedPredictButtonState();
}

class _AnimatedPredictButtonState extends State<_AnimatedPredictButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, child) {
        final scale = 1 + (_pulseCtrl.value * 0.05);

        return Transform.scale(scale: scale, child: child);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.isTablet ? 20 : 10,
            vertical: widget.isTablet ? 8 : 4,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/genie.png',
                width: widget.isTablet ? 30 : 32,
                height: widget.isTablet ? 30 : 32,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 4),
              Text(
                "Predict Now",
                style: GoogleFonts.inter(
                  fontSize: widget.isTablet ? 12.5 : 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF3D6B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerBadge extends StatelessWidget {
  final Animation<double> animation;

  const _ShimmerBadge({required this.animation});

  @override
  Widget build(BuildContext context) {
    final isTablet = AppResponsive.isTablet(context);

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
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 10 : 8,
          vertical: isTablet ? 4 : 3,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.28), width: 0.8),
        ),
        child: Text(
          'AI Powered',
          style: GoogleFonts.inter(
            fontSize: isTablet ? 10 : 9,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.95),
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }
}
