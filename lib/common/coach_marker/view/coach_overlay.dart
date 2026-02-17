import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/coach_controller.dart';
import 'coach_tooltip.dart';
import 'animated_arrow.dart';

class CoachOverlay extends StatelessWidget {
  CoachOverlay({super.key});

  final controller = Get.find<CoachController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.visible.value || controller.current == null) {
        return const SizedBox.shrink();
      }

      final step = controller.current!;
      final box =
          step.targetKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) return const SizedBox.shrink();

      final pos = box.localToGlobal(Offset.zero);
      final size = box.size;

      return Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _SpotlightPainter(pos, size),
            ),
          ),
          Positioned(
            top: pos.dy - 40,
            left: pos.dx + size.width / 2 - 16,
            child: const AnimatedArrow(),
          ),
          Positioned(
            left: 24,
            right: 24,
            top: pos.dy + size.height + 24,
            child: CoachTooltip(step: step),
          ),
        ],
      );
    });
  }
}

class _SpotlightPainter extends CustomPainter {
  final Offset pos;
  final Size size;

  _SpotlightPainter(this.pos, this.size);

  @override
  void paint(Canvas canvas, Size screen) {
    final paint = Paint()..color = Colors.black54;
    canvas.drawRect(Offset.zero & screen, paint);

    paint.blendMode = BlendMode.clear;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(pos.dx - 8, pos.dy - 8, size.width + 16, size.height + 16),
        const Radius.circular(16),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_) => true;
}
