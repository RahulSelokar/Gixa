import 'package:Gixa/Modules/predication/controller/prediction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pill_selector.dart';

class ReservationSection extends StatelessWidget {
  final bool isDark;
  const ReservationSection({super.key, required this.isDark});

  List<String> _horizontalOptions(String gender) {
    return gender == "M"
        ? ["None", "PWD", "Defence", "Orphan", "HA", "IQ"]
        : ["None", "Women", "PWD", "Defence", "Orphan", "HA", "IQ"];
  }

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
          Obx(() => PillSelector(
                items: ["Male", "Female"],
                values: ["M", "F"],
                selected: controller.selectedGender.value,
                onTap: (v) => controller.selectedGender.value = v,
                isDark: isDark,
              )),
          const SizedBox(height: 14),
          Obx(() {
            final options =
                _horizontalOptions(controller.selectedGender.value);
            controller.selectedHorizontals.length;
            return Column(
              children: options
                  .map((e) => CheckboxListTile(
                        value:
                            controller.selectedHorizontals.contains(e),
                        title: Text(e),
                        onChanged: (_) =>
                            controller.handleHorizontalSelection(e),
                      ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}