import 'package:Gixa/Modules/faq/controller/faq_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqSection extends StatelessWidget {
  final FaqController faqController;
  final double horizontalPadding;

  const FaqSection({
    super.key,
    required this.faqController,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (faqController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (faqController.faqList.isEmpty) {
        return const SizedBox();
      }

      final faqs = faqController.displayedFaqs;

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
        ),
        child: Column(
          children: [
            // your faq ui here
          ],
        ),
      );
    });
  }
}