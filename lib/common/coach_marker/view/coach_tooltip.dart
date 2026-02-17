import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/coach_controller.dart';
import '../model/coach_step.dart';

class CoachTooltip extends StatelessWidget {
  final CoachStep step;

  const CoachTooltip({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CoachController>();

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1565C0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              step.description,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: controller.skip,
                  child: const Text("Skip", style: TextStyle(color: Colors.white)),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1565C0),
                  ),
                  onPressed: controller.next,
                  child: const Text("Continue"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
