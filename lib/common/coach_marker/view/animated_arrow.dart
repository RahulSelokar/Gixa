import 'package:flutter/material.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:Gixa/utils/constants/colors.dart';

class AnimatedArrow extends StatefulWidget {
  final bool pointsUp;

  const AnimatedArrow({super.key, this.pointsUp = false});

  @override
  State<AnimatedArrow> createState() => _AnimatedArrowState();
}

class _AnimatedArrowState extends State<AnimatedArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, (widget.pointsUp ? -8 : 8) * controller.value),
          child: child,
        );
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          gradient: kHomeBrandGradient,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.7),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: UColors.primary.withOpacity(0.28),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          widget.pointsUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
