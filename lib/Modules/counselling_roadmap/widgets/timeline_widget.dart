import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/counselling_state_model.dart';
import '../widgets/shared_widgets.dart';

class Timeline extends StatelessWidget {
  final List<CounsellingStep> steps;
  final bool isDark;
  final Color borderColor;

  const Timeline({
    required this.steps,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = CounsellingUi.cardBg(context, isDark);
    final textColor = CounsellingUi.textPrimary(isDark);

    return ListView.builder(
      itemCount: steps.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final step = steps[index];
        final bool isLast = index == steps.length - 1;
        final Color stepColor = _stepColor(step.title);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline connector
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: GixaColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: GixaColors.pink.withOpacity(0.32),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2.5,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                GixaColors.pink.withOpacity(0.55),
                                GixaColors.violet.withOpacity(0.12),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Step card
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                    boxShadow: CounsellingUi.cardShadow(isDark),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: stepColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Icon(
                          _stepIcon(step.title),
                          color: stepColor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              step.description,
                              style: TextStyle(
                                color: CounsellingUi.textSecondary(isDark),
                                fontSize: 11.5,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: stepColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _stepColor(String title) {
    final t = title.toLowerCase();
    if (t.contains("registr")) return GixaColors.orange;
    if (t.contains("verif") || t.contains("document")) return GixaColors.blue;
    if (t.contains("choice") || t.contains("applic")) return GixaColors.violet;
    if (t.contains("allot") || t.contains("rank") || t.contains("merit")) {
      return GixaColors.green;
    }
    if (t.contains("report") || t.contains("joining") || t.contains("lock")) {
      return GixaColors.pink;
    }
    if (t.contains("admission") || t.contains("join")) return GixaColors.orange;
    return GixaColors.pink;
  }

  IconData _stepIcon(String title) {
    final t = title.toLowerCase();
    if (t.contains("registr")) return Icons.app_registration_outlined;
    if (t.contains("document") || t.contains("upload")) {
      return Icons.description_outlined;
    }
    if (t.contains("verif")) return Icons.verified_user_outlined;
    if (t.contains("choice")) return Icons.checklist_outlined;
    if (t.contains("lock")) return Icons.lock_outline;
    if (t.contains("allot") || t.contains("seat")) {
      return Icons.how_to_reg_outlined;
    }
    if (t.contains("report")) return Icons.location_city_outlined;
    if (t.contains("admission") || t.contains("joining") || t.contains("join")) {
      return Icons.school_outlined;
    }
    if (t.contains("rank") || t.contains("merit")) {
      return Icons.emoji_events_outlined;
    }
    if (t.contains("eligib")) return Icons.verified_outlined;
    if (t.contains("applic")) return Icons.edit_document;
    if (t.contains("domicile")) return Icons.home_outlined;
    if (t.contains("mop")) return Icons.refresh;
    if (t.contains("supplementary")) return Icons.add_circle_outline;
    return Icons.circle_outlined;
  }
}

