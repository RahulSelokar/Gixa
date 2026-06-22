import 'dart:async';

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
  final controller = Get.isRegistered<CoachController>()
      ? Get.find<CoachController>()
      : Get.put(CoachController());
  Worker? _indexWorker;
  Worker? _visibleWorker;
  int _scrollTicket = 0;

  @override
  void initState() {
    super.initState();
    _indexWorker = ever<int>(controller.index, (_) {
      unawaited(_ensureCurrentStepVisible());
    });
    _visibleWorker = ever<bool>(controller.visible, (isVisible) {
      if (isVisible) {
        unawaited(_ensureCurrentStepVisible());
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!await CoachService.hasSeen(widget.screenKey)) {
        controller.start(widget.screenKey, widget.steps);
        unawaited(_ensureCurrentStepVisible());
      }
    });
  }

  Future<void> _ensureCurrentStepVisible() async {
    if (!mounted || controller.activeScreenKey.value != widget.screenKey) {
      return;
    }

    final step = controller.current;
    if (step == null) return;

    final ticket = ++_scrollTicket;
    controller.transitioning.value = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (controller.activeScreenKey.value != widget.screenKey) return;

      final context = step.targetKey.currentContext;
      if (context == null) {
        if (ticket == _scrollTicket) {
          controller.transitioning.value = false;
        }
        return;
      }

      await Scrollable.ensureVisible(
        context,
        duration: step.scrollDuration,
        curve: Curves.easeInOutCubic,
        alignment: step.scrollAlignment,
      );

      if (!mounted) return;
      if (ticket != _scrollTicket) return;

      await Future<void>.delayed(const Duration(milliseconds: 90));
      if (!mounted) return;
      if (ticket != _scrollTicket) return;

      controller.transitioning.value = false;
    });
  }

  @override
  void dispose() {
    _indexWorker?.dispose();
    _visibleWorker?.dispose();
    super.dispose();
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
