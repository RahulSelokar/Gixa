import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/counselling_state_model.dart';
import '../widgets/shared_widgets.dart';
import '../controller/counselling_roadmap_controller.dart';

class UGPGToggle extends StatelessWidget {
  final CounsellingRoadmapController controller;
  final bool isDark;

  const UGPGToggle({super.key, required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}