import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/counselling_state_model.dart';
import '../widgets/shared_widgets.dart';

class RoundsSection extends StatelessWidget {
  final List<String> rounds;

  const RoundsSection({required this.rounds});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = CounsellingUi.cardBg(context, isDark);
    final borderColor = CounsellingUi.border(isDark);

    final List<Color> roundColors = [
      GixaColors.orange,
      GixaColors.pink,
      GixaColors.violet,
      GixaColors.blue,
    ];

    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(vertical: 2),
        itemCount: rounds.length,
        separatorBuilder: (_, __) => const SizedBox(width: 11),
        itemBuilder: (context, index) {
          final color = roundColors[index % roundColors.length];
          return Container(
            width: 118,
            padding: const EdgeInsets.fromLTRB(13, 14, 13, 13),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
              boxShadow: CounsellingUi.cardShadow(isDark),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.repeat_one_rounded,
                    color: color,
                    size: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  rounds[index],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5,
                    height: 1.2,
                    color: CounsellingUi.textPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Counselling",
                  style: TextStyle(
                    fontSize: 9.5,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}