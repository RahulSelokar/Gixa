import 'package:flutter/material.dart';
import '../model/counselling_state_model.dart';
import 'shared_widgets.dart';

class ReRegistrationSection extends StatelessWidget {
  final List<ReRegistrationInfo> rules;
  final bool isDark;
  final Color borderColor;

  const ReRegistrationSection({
    super.key,
    required this.rules,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (rules.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            "WHO RE-REGISTERS FOR ROUND 3?",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: GixaColors.orange,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rules.map((rule) {
                return Container(
                  width: 260,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: rule.themeColor.withOpacity(isDark ? 0.1 : 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: rule.themeColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rule.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? rule.themeColor : rule.themeColor.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...rule.points.map((point) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (rule.icon != null) ...[
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Icon(rule.icon, size: 14, color: isDark ? rule.themeColor : rule.themeColor.withOpacity(0.8)),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Expanded(
                                child: Text(
                                  point,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? Colors.white70 : Colors.black87,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class SeatDistributionSection extends StatelessWidget {
  final List<SeatDistributionInfo> distributions;
  final bool isDark;
  final Color borderColor;

  const SeatDistributionSection({
    super.key,
    required this.distributions,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (distributions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            "SEAT DISTRIBUTION AT A GLANCE",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: GixaColors.orange,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: distributions.map((dist) {
                return Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                    boxShadow: CounsellingUi.cardShadow(isDark),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dist.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: dist.themeColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...dist.distributionPoints.map((point) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  point,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                                    height: 1.3,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (dist.highlightBoxText.isNotEmpty)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: dist.themeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            dist.highlightBoxText,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: dist.themeColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
