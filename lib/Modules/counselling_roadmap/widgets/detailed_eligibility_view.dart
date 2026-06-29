import 'package:flutter/material.dart';
import '../model/counselling_state_model.dart';
import 'extra_sections.dart';

class DetailedEligibilityView extends StatelessWidget {
  final CounsellingStateData state;
  final bool isDark;
  final Color borderColor;

  const DetailedEligibilityView({
    super.key,
    required this.state,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (state.eligibility.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            children: [
              Icon(
                Icons.hourglass_empty_rounded,
                size: 48,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No eligibility data available',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EligibilitySection(
          eligibility: state.eligibility,
          isDark: isDark,
          borderColor: borderColor,
        ),
      ],
    );
  }
}
