import 'package:flutter/material.dart';
import 'package:Gixa/common/app_colors.dart';

class TipsCard extends StatefulWidget {
  const TipsCard({super.key});

  @override
  State<TipsCard> createState() => _TipsCardState();
}

class _TipsCardState extends State<TipsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kHomeAccentColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Icon(Icons.lightbulb_outline, color: kHomeAccentColor),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "Tip: Update your profile to get better predictions.",
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
