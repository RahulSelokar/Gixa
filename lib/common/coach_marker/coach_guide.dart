import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/coach_controller.dart';
import 'model/coach_step.dart';
import 'service/coach_service.dart';
import 'view/coach_overlay.dart';

class CoachGuide extends StatefulWidget {
  final String screenKey;
  final List<CoachStep> steps;
  final Widget child;

  const CoachGuide({
    super.key,
    required this.screenKey,
    required this.steps,
    required this.child,
  });

  @override
  State<CoachGuide> createState() => _CoachGuideState();
}

class _CoachGuideState extends State<CoachGuide> {
  final controller = Get.put(CoachController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!await CoachService.hasSeen(widget.screenKey)) {
        controller.start(widget.steps);
        await CoachService.markSeen(widget.screenKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        CoachOverlay(),
      ],
    );
  }
}
