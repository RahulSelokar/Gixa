import 'package:Gixa/Modules/predication/controller/prediction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankCard extends StatelessWidget {
  final bool isDark;
  const RankCard({super.key, required this.isDark});

  static const Color indigo = Color(0xFF6366F1);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color emerald = Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PredictionController>();

    return Obx(() => Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: indigo.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "YOUR MERIT RANK",
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "#${controller.userAir.value}",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: indigo,
                  ),
                ),
                const Text(
                  "All India Rank",
                  style: TextStyle(fontSize: 10, color: cyan),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified_rounded, color: indigo),
        ],
      ),
    ));
  }
}