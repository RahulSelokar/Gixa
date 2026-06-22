import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AiActivationDialog extends StatefulWidget {
  final VoidCallback onCompleted;

  const AiActivationDialog({super.key, required this.onCompleted});

  @override
  State<AiActivationDialog> createState() => _AiActivationDialogState();
}

class _AiActivationDialogState extends State<AiActivationDialog>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _particleController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isCompleting = false;

  final List<_ParticleData> particles = List.generate(
    20,
    (index) => _ParticleData.random(),
  );

  @override
  void initState() {
    super.initState();

    HapticFeedback.mediumImpact();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.82, end: 1).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeOut));

    _mainController.forward();

    _startFlow();
  }

  Future<void> _startFlow() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    setState(() {
      _isCompleting = true;
    });

    HapticFeedback.heavyImpact();

    await Future.delayed(const Duration(milliseconds: 700));

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    widget.onCompleted();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.black.withOpacity(0.82),

      child: Stack(
        children: [
          /// PARTICLES
          AnimatedBuilder(
            animation: _particleController,

            builder: (_, __) {
              return CustomPaint(
                painter: _ParticlePainter(
                  particles: particles,
                  progress: _particleController.value,
                ),
                child: const SizedBox.expand(),
              );
            },
          ),

          /// MAIN CARD
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,

              child: ScaleTransition(
                scale: _scaleAnimation,

                child: Container(
                  width: MediaQuery.of(context).size.width * 0.88,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),

                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(36),

                  //   gradient: LinearGradient(
                  //     begin: Alignment.topLeft,
                  //     end: Alignment.bottomRight,
                  //     colors: isDark
                  //         ? [const Color(0xFF0F172A), const Color(0xFF111827)]
                  //         : [Colors.white, const Color(0xFFF8FAFC)],
                  //   ),

                  //   border: Border.all(color: Colors.white.withOpacity(0.08)),

                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: const Color(0xFFFF8C00).withOpacity(0.20),

                  //       blurRadius: 60,
                  //       spreadRadius: 6,
                  //     ),
                  //   ],
                  // ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      /// TOP TAG
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9800).withOpacity(0.12),

                          borderRadius: BorderRadius.circular(30),
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: Color(0xFFFFA726),
                              size: 16,
                            ),

                            const SizedBox(width: 8),

                            Text(
                              "GIXA AI ACTIVATED",

                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,

                                fontSize: 11,

                                fontWeight: FontWeight.w700,

                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// AI ORB
                      SizedBox(
                        width: 220,
                        height: 220,

                        child: Stack(
                          alignment: Alignment.center,

                          children: [
                            /// OUTER GLOW
                            AnimatedBuilder(
                              animation: _pulseController,

                              builder: (_, __) {
                                return Container(
                                  width: 190 + (_pulseController.value * 20),

                                  height: 190 + (_pulseController.value * 20),

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,

                                    gradient: RadialGradient(
                                      colors: [
                                        const Color(
                                          0xFFFF9800,
                                        ).withOpacity(0.35),

                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            /// ROTATING RING
                            AnimatedBuilder(
                              animation: _rotateController,

                              builder: (_, child) {
                                return Transform.rotate(
                                  angle: _rotateController.value * math.pi * 2,

                                  child: child,
                                );
                              },

                              child: Container(
                                width: 170,
                                height: 170,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,

                                  border: Border.all(
                                    color: const Color(
                                      0xFFFFB74D,
                                    ).withOpacity(0.35),

                                    width: 1.2,
                                  ),
                                ),
                              ),
                            ),

                            /// MAIN ORB
                            AnimatedBuilder(
                              animation: _pulseController,

                              builder: (_, child) {
                                return Transform.scale(
                                  scale: 1 + (_pulseController.value * 0.06),

                                  child: child,
                                );
                              },

                              child: Container(
                                width: 130,
                                height: 130,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,

                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,

                                    end: Alignment.bottomRight,

                                    colors: [
                                      Color(0xFFFF9800),
                                      Color(0xFFFFC107),
                                    ],
                                  ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFF9800,
                                      ).withOpacity(0.50),

                                      blurRadius: 40,
                                      spreadRadius: 6,
                                    ),
                                  ],
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.all(16),

                                  child: Image.asset(
                                    "assets/icons/gixxa5.png",

                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// TITLE
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [Color(0xFFFFB300), Color(0xFFFF7043)],
                          ).createShader(bounds);
                        },

                        child: const Text(
                          "Gixa AI",

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: Colors.white,

                            fontSize: 28,

                            fontWeight: FontWeight.w900,

                            letterSpacing: -1,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// SUBTITLE
                      Text(
                        "Analyzing your profile and finding the best colleges tailored for your future.",

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,

                          fontSize: 14,

                          height: 1.7,

                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// PROGRESS BAR
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),

                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: _isCompleting ? 1 : 0.76),

                          duration: const Duration(seconds: 3),

                          builder: (context, value, child) {
                            return LinearProgressIndicator(
                              value: value,

                              minHeight: 10,

                              backgroundColor: Colors.white.withOpacity(0.08),

                              valueColor: const AlwaysStoppedAnimation(
                                Color(0xFFFF9800),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// STATUS
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),

                        child: Row(
                          key: ValueKey(_isCompleting),

                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Container(
                              width: 10,
                              height: 10,

                              decoration: BoxDecoration(
                                color: _isCompleting
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFFF9800),

                                shape: BoxShape.circle,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Text(
                              _isCompleting
                                  ? "Opening AI Experience..."
                                  : "Scanning preferences...",

                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,

                                fontSize: 13,

                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _ParticleData {
  final double x;
  final double y;
  final double size;
  final double speed;

  _ParticleData({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });

  factory _ParticleData.random() {
    final random = math.Random();

    return _ParticleData(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 4 + 1,
      speed: random.nextDouble() * 0.5 + 0.2,
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_ParticleData> particles;
  final double progress;

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFFF9800).withOpacity(0.18);

    for (final particle in particles) {
      final dx = particle.x * size.width;

      final dy = ((particle.y + (progress * particle.speed)) % 1) * size.height;

      canvas.drawCircle(Offset(dx, dy), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
