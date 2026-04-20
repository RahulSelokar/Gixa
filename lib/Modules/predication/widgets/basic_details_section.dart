import 'package:Gixa/Modules/predication/controller/prediction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ai_input.dart';

class BasicDetailsSection extends StatelessWidget {
  final bool isDark;
  final TextEditingController stateController;
  final TextEditingController categoryController;
  final TextEditingController courseController;
  final TextEditingController yearController;

  const BasicDetailsSection({
    super.key,
    required this.isDark,
    required this.stateController,
    required this.categoryController,
    required this.courseController,
    required this.yearController,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PredictionController>();

    return Column(
      children: [
        AiInput(
          label: "State",
          icon: Icons.map_outlined,
          controller: stateController,
          onChanged: (v) => controller.selectedState.value = v,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        AiInput(
          label: "Category",
          icon: Icons.group_outlined,
          controller: categoryController,
          onChanged: (v) => controller.selectedCategory.value = v,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: AiInput(
                label: "Course",
                icon: Icons.school_outlined,
                controller: courseController,
                onChanged: (v) => controller.selectedCourse.value = v,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AiInput(
                label: "Year",
                icon: Icons.calendar_today_outlined,
                controller: yearController,
                onChanged: (v) =>
                    controller.selectedYear.value = int.tryParse(v),
                isDark: isDark,
                keyboard: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }
}