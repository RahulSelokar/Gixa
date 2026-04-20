import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiOverlay extends StatefulWidget {
  final List<Map<String, dynamic>> aiSteps;
  final RxInt aiStep;
  final AnimationController pulseCtrl;
  final AnimationController rotateCtrl;

  const AiOverlay({
    super.key,
    required this.aiSteps,
    required this.aiStep,
    required this.pulseCtrl,
    required this.rotateCtrl,
  });

  @override
  State<AiOverlay> createState() => _AiOverlayState();
}

class _AiOverlayState extends State<AiOverlay> {
  static const Color _indigo = Color(0xFF6366F1);
  static const Color _indigoDark = Color(0xFF4338CA);
  static const Color _cyan = Color(0xFF06B6D4);
  static const Color _emerald = Color(0xFF10B981);

  static const Color _darkCard = Color(0xFF0D1526);
  static const Color _darkTrack = Color(0xFF1A2540);

  static const Color _lightCard = Color(0xFFFFFFFF);
  static const Color _lightTrack = Color(0xFFF0F2F9);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? _darkCard : _lightCard;
    final trackColor = isDark ? _darkTrack : _lightTrack;
    final titleColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subtitleColor =
        isDark ? _cyan.withOpacity(0.65) : _indigo.withOpacity(0.55);
    final borderColor =
        isDark ? _indigo.withOpacity(0.22) : _indigo.withOpacity(0.12);
    final barrierColor =
        isDark ? Colors.black.withOpacity(0.72) : Colors.black.withOpacity(0.40);

    return Positioned.fill(
      child: Container(
        color: barrierColor,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 26),
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: borderColor, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: _indigo.withOpacity(isDark ? 0.18 : 0.10),
                    blurRadius: 48,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _emblem(isDark),
                  const SizedBox(height: 14),
                  Text(
                    "Gixa Prediction Engine",
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _indigo.withOpacity(isDark ? 0.12 : 0.07),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: _emerald,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _emerald.withOpacity(0.6),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Powered by AI · Real-time analysis",
                          style: TextStyle(
                            color: subtitleColor,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    color: isDark
                        ? Colors.white.withOpacity(0.07)
                        : Colors.black.withOpacity(0.06),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final step = widget.aiStep.value;
                    return Column(
                      children: [
                        ...widget.aiSteps.asMap().entries.map(
                              (e) => _stepRow(
                                index: e.key,
                                icon: e.value["icon"] as IconData,
                                msg: e.value["msg"] as String,
                                currentStep: step,
                                isDark: isDark,
                                trackColor: trackColor,
                              ),
                            ),
                        const SizedBox(height: 18),
                        _scanBar(
                          currentStep: step,
                          isDark: isDark,
                          trackColor: trackColor,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emblem(bool isDark) {
    return SizedBox(
      width: 68,
      height: 68,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _indigo.withOpacity(isDark ? 0.22 : 0.12),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: widget.rotateCtrl,
            builder: (_, __) => Transform.rotate(
              angle: widget.rotateCtrl.value * 2 * pi,
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      _indigo.withOpacity(0),
                      _indigo.withOpacity(0.7),
                      _cyan.withOpacity(0.4),
                      _indigo.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: widget.pulseCtrl,
            builder: (_, __) {
              final scale = 0.86 + 0.14 * widget.pulseCtrl.value;
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [_indigo, _indigoDark],
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _stepRow({
    required int index,
    required IconData icon,
    required String msg,
    required int currentStep,
    required bool isDark,
    required Color trackColor,
  }) {
    final isDone = index < currentStep;
    final isActive = index == currentStep;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? _indigo.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            isDone
                ? Icons.check_circle
                : isActive
                    ? Icons.autorenew
                    : Icons.circle_outlined,
            size: 14,
            color: isDone
                ? _emerald
                : isActive
                    ? _indigo
                    : Colors.grey,
          ),
          const SizedBox(width: 8),
          Icon(icon, size: 14, color: _indigo),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              msg,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scanBar({
    required int currentStep,
    required bool isDark,
    required Color trackColor,
  }) {
    final progress =
        (currentStep / (widget.aiSteps.length - 1)).clamp(0.02, 1.0);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            children: [
              Container(height: 4, color: trackColor),
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 500),
                widthFactor: progress,
                child: Container(
                  height: 4,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_indigo, _cyan],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}