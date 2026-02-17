import 'package:Gixa/Modules/dailyUpdates/model/daily_update_model.dart';
import 'package:flutter/material.dart';

class UpdateCard extends StatelessWidget {
  final UpdateModel update;

  const UpdateCard({super.key, required this.update});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color accent;
    IconData icon;

    switch (update.type) {
      case UpdateType.offer:
        accent = Colors.green;
        icon = Icons.local_offer;
        break;
      case UpdateType.alert:
        accent = Colors.red;
        icon = Icons.notifications_active;
        break;
      case UpdateType.promo:
        accent = theme.colorScheme.primary;
        icon = Icons.star;
        break;
      default:
        accent = Colors.blue;
        icon = Icons.newspaper;
    }

    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      // decoration: BoxDecoration(
      //   color: theme.cardColor,
      //   borderRadius: BorderRadius.circular(18),
      //   border: Border.all(color: theme.dividerColor),
      // ),
      child: Row(
        children: [
          /// ICON
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accent),
          ),

          const SizedBox(width: 12),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  update.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  update.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
