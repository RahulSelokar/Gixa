import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:Gixa/utils/constants/colors.dart';
import '../controller/coach_controller.dart';
import '../model/coach_step.dart';

class CoachTooltip extends StatelessWidget {
  final CoachStep step;
  final double maxHeight;

  const CoachTooltip({
    super.key,
    required this.step,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CoachController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.textScaleFactorOf(
      context,
    ).clamp(1.0, 1.15).toDouble();
    final isTablet = screenWidth >= 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFFF7F3EC) : const Color(0xFFFFFCF8);
    final titleColor = UColors.primaryDark;
    final bodyColor = isDark
        ? const Color(0xFF5B6472)
        : const Color(0xFF5B6472);
    final accentColor = isDark ? UColors.primaryLight : UColors.primary;
    final borderColor = isDark
        ? const Color(0xFFE5D8C6)
        : UColors.border;

    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF8A00).withOpacity(0.12),
                blurRadius: 26,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.12 : 0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      isTablet ? 18 : 14,
                      12,
                      isTablet ? 18 : 14,
                      12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFF1D8),
                          const Color(0xFFFFE6EA),
                          const Color(0xFFEAF0FF),
                        ],
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.82),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.88),
                                ),
                              ),
                              child: Text(
                                "Guide ${controller.currentStepNumber}/${controller.totalSteps}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textScaler: TextScaler.linear(textScale),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: accentColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: isTablet ? 48 : 42,
                          height: isTablet ? 48 : 42,
                          decoration: BoxDecoration(
                            gradient: kHomeBrandGradient,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                step.imageAsset ?? 'assets/icons/gixxa2.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(isTablet ? 18 : 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          textScaler: TextScaler.linear(textScale),
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w800,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step.description,
                          textScaler: TextScaler.linear(textScale),
                          style: TextStyle(
                            color: bodyColor,
                            height: 1.45,
                            fontSize: isTablet ? 13.5 : 12.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4E6),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: Icon(
                                  Icons.lightbulb_rounded,
                                  size: 16,
                                  color: accentColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.isLastStep
                                      ? "Tap Done to finish this page guide."
                                      : "Tap Next to continue to the next section.",
                                  textScaler: TextScaler.linear(textScale),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: accentColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: controller.totalSteps == 0
                                ? 0
                                : controller.currentStepNumber /
                                      controller.totalSteps,
                            minHeight: 5,
                            backgroundColor: accentColor.withOpacity(
                              isDark ? 0.12 : 0.08,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                controller.skip();
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: titleColor,
                                side: BorderSide(color: borderColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                              ),
                              child: Text(
                                "Skip",
                                textScaler: TextScaler.linear(textScale),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: titleColor,
                                ),
                              ),
                            ),
                            Obx(
                              () => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  disabledBackgroundColor: accentColor.withOpacity(
                                    0.55,
                                  ),
                                  disabledForegroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                ),
                                onPressed: controller.transitioning.value
                                    ? null
                                    : () {
                                        controller.next();
                                      },
                                child: Text(
                                  controller.isLastStep ? "Done" : "Next",
                                  textScaler: TextScaler.linear(textScale),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
