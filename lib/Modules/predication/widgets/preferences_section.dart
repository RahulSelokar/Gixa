import 'package:Gixa/Modules/predication/controller/prediction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pill_selector.dart';
import 'ai_dropdown.dart';

class PreferencesSection extends StatelessWidget {
  final bool isDark;
  const PreferencesSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PredictionController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("INSTITUTE TYPE"),
          const SizedBox(height: 8),
          Obx(
            () => PillSelector(
              items: ["Govt", "Pvt", "Both"],
              values: ["Govt", "Pvt", "Both"],
              selected: controller.selectedInstituteType.value,
              onTap: (v) => controller.selectedInstituteType.value = v,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => AiDropdown(
              label: "Quota",
              icon: Icons.account_balance_outlined,
              value: controller.selectedQuota.value,
              items: [
                "State Quota",
                "All India",
                "Government Quota",
                "Management Quota",
                "IQ/Management",
              ],
              onChanged: (v) => controller.selectedQuota.value = v ?? "",
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}
