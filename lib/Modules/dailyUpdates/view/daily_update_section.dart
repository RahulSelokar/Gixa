import 'package:Gixa/Modules/dailyUpdates/controller/daily_update_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'update_card.dart';

class DailyUpdatesSection extends StatelessWidget {
  const DailyUpdatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdatesController());
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Daily Updates",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 12),

        /// CAROUSEL
        SizedBox(
          height: 110,
          child: Obx(
            () => PageView.builder(
              controller: controller.pageController,
              itemCount: controller.updates.length,
              itemBuilder: (_, index) {
                return UpdateCard(
                  update: controller.updates[index],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
