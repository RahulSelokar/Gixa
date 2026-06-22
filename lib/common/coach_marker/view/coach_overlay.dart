import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:Gixa/utils/constants/colors.dart';
import '../controller/coach_controller.dart';
import 'coach_tooltip.dart';
import 'animated_arrow.dart';

class CoachOverlay extends StatelessWidget {
  CoachOverlay({super.key});

  final controller = Get.put(CoachController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.visible.value ||
          controller.transitioning.value ||
          controller.current == null) {
        return const SizedBox.shrink();
      }

      final step = controller.current!;
      final box =
          step.targetKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) return const SizedBox.shrink();

      final pos = box.localToGlobal(Offset.zero);
      final size = box.size;
      final mediaQuery = MediaQuery.of(context);
      final screenSize = mediaQuery.size;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final isTablet = screenSize.width >= 600;
      final horizontalPadding = isTablet ? 24.0 : 16.0;
      final topSafe = mediaQuery.padding.top + 16;
      final bottomSafe = mediaQuery.padding.bottom + 16;
      final tooltipTop = pos.dy + size.height + 24;
      final tooltipBottomSpace = screenSize.height - tooltipTop;
      final showTooltipAbove =
          tooltipBottomSpace < (isTablet ? 280 : 230) &&
          pos.dy > (isTablet ? 260 : 220);
      final tooltipWidth = math.min(
        isTablet
            ? (screenSize.width >= 900 ? 460.0 : 400.0)
            : 360.0,
        screenSize.width - (horizontalPadding * 2),
      );
      final tooltipMaxHeight =
          (showTooltipAbove
                  ? pos.dy - topSafe - 24
                  : screenSize.height - tooltipTop - bottomSafe)
              .clamp(180.0, screenSize.height * 0.72)
              .toDouble();
      final tooltipLeft = (pos.dx + (size.width / 2) - (tooltipWidth / 2))
          .clamp(
            horizontalPadding,
            screenSize.width - tooltipWidth - horizontalPadding,
          )
          .toDouble();

      return Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _SpotlightPainter(
                  pos,
                  size,
                  isDark: isDark,
                ),
              ),
            ),
          ),
          Positioned(
            top: showTooltipAbove ? pos.dy + size.height + 8 : pos.dy - 46,
            left: pos.dx + size.width / 2 - 21,
            child: AnimatedArrow(
              pointsUp: showTooltipAbove,
            ),
          ),
          Positioned(
            left: tooltipLeft,
            width: tooltipWidth,
            top: showTooltipAbove
                ? null
                : math.min(
                    tooltipTop,
                    screenSize.height - tooltipMaxHeight - bottomSafe,
                  ),
            bottom: showTooltipAbove
                ? math.max((screenSize.height - pos.dy) + 24, bottomSafe)
                : null,
            child: CoachTooltip(
              step: step,
              maxHeight: tooltipMaxHeight,
            ),
          ),
        ],
      );
    });
  }
}

class _SpotlightPainter extends CustomPainter {
  final Offset pos;
  final Size size;
  final bool isDark;

  _SpotlightPainter(this.pos, this.size, {required this.isDark});

  @override
  void paint(Canvas canvas, Size screen) {
    final overlayRect = Offset.zero & screen;
    final targetRect = Rect.fromLTWH(
      pos.dx - 12,
      pos.dy - 12,
      size.width + 24,
      size.height + 24,
    );
    final targetCenter = targetRect.center;

      final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [
                const Color(0x9911141D),
                const Color(0x8A172032),
                const Color(0x80222C40),
              ]
            : [
                const Color(0x66141B28),
                const Color(0x591C2738),
                const Color(0x4D263245),
              ],
      ).createShader(overlayRect);
    canvas.drawRect(Offset.zero & screen, paint);

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          UColors.primaryLight.withOpacity(isDark ? 0.26 : 0.16),
          UColors.secondary.withOpacity(isDark ? 0.16 : 0.08),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: targetCenter,
          radius: math.max(targetRect.width, targetRect.height) * 1.15,
        ),
      );
    canvas.drawCircle(
      targetCenter,
      math.max(targetRect.width, targetRect.height) * 0.75,
      glowPaint,
    );

    paint.blendMode = BlendMode.clear;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        targetRect,
        const Radius.circular(24),
      ),
      paint,
    );

    final ringPaint = Paint()
      ..shader = kHomeBrandGradient.createShader(targetRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..blendMode = BlendMode.srcOver;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        targetRect,
        const Radius.circular(24),
      ),
      ringPaint,
    );

    final outerRingPaint = Paint()
      ..color = Colors.white.withOpacity(isDark ? 0.14 : 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        targetRect.inflate(6),
        const Radius.circular(28),
      ),
      outerRingPaint,
    );
  }

  @override
  bool shouldRepaint(_) => true;
}
