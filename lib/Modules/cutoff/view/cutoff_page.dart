import 'package:Gixa/Modules/cutoff/controller/cotoff_controller.dart';
import 'package:Gixa/Modules/cutoff/view/widgets/cutoff_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CutoffResultPage extends StatelessWidget {
  const CutoffResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CutoffController>();

    controller.applyFilters();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          "${controller.selectedState.value} - ${controller.selectedCourse.value}",
        )),
      ),
      body: Column(
        children: [
          /// CATEGORY FILTER
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              return DropdownButtonFormField<String>(
                initialValue: controller.selectedCategory.value,
                items: controller.categories
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        ))
                    .toList(),
                onChanged: (v) {
                  controller.selectedCategory.value = v!;
                  controller.applyFilters();
                },
                decoration:
                    const InputDecoration(labelText: "Select Category"),
              );
            }),
          ),

          /// COLLEGE LIST
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.colleges.length,
                itemBuilder: (_, index) {
                  return CutoffCollegeCard(
                    college: controller.colleges[index],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
