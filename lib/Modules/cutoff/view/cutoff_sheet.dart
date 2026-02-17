import 'package:Gixa/Modules/cutoff/controller/cotoff_controller.dart';
import 'package:Gixa/Modules/cutoff/view/cutoff_page.dart';
import 'package:Gixa/Modules/cutoff/view/widgets/dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CutoffSelectionSheet extends StatelessWidget {
  const CutoffSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CutoffController());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Check College Cutoff",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          AppDropdown(
            label: "Select State",
            items: controller.states,
            onChanged: (v) => controller.selectedState.value = v!,
          ),

          const SizedBox(height: 12),

          AppDropdown(
            label: "Select Course",
            items: controller.courses,
            onChanged: (v) => controller.selectedCourse.value = v!,
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Get.back(); // close bottom sheet
                Get.to(() => const CutoffResultPage());
              },
              child: const Text("View Cutoff"),
            ),
          ),
        ],
      ),
    );
  }
}
