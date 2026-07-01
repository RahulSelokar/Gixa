import 'package:flutter/material.dart';
import '../model/counselling_state_model.dart';
import 'shared_widgets.dart';

class EligibilitySection extends StatelessWidget {
  final List<EligibilityCriteria> eligibility;
  final bool isDark;
  final Color borderColor;

  const EligibilitySection({
    super.key,
    required this.eligibility,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (eligibility.isEmpty) return const SizedBox.shrink();
    return Column(
      children: eligibility.map((item) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: CounsellingUi.cardShadow(isDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.category,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : GixaColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.requirement,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class ReservationsSection extends StatelessWidget {
  final List<ReservationCategory> reservations;
  final bool isDark;
  final Color borderColor;

  const ReservationsSection({
    super.key,
    required this.reservations,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (reservations.isEmpty) return const SizedBox.shrink();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final res = reservations[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: CounsellingUi.cardShadow(isDark),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: GixaColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  res.percentage,
                  style: const TextStyle(
                    color: GixaColors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      res.category,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : GixaColors.ink,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      res.description,
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AlertsSection extends StatelessWidget {
  final List<AlertInfo> alerts;
  final bool isDark;
  final Color borderColor;

  const AlertsSection({
    super.key,
    required this.alerts,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: alerts.map((alert) {
        Color bgColor;
        Color iconColor;

        switch (alert.type) {
          case AlertType.critical:
            bgColor = Colors.red.withOpacity(0.1);
            iconColor = Colors.red;
            break;
          case AlertType.warning:
            bgColor = Colors.orange.withOpacity(0.1);
            iconColor = Colors.orange;
            break;
          case AlertType.info:
          default:
            bgColor = Colors.blue.withOpacity(0.1);
            iconColor = Colors.blue;
            break;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: iconColor.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: iconColor, size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  alert.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : GixaColors.ink,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class ContactInfoSection extends StatelessWidget {
  final ContactInfo? contactInfo;
  final bool isDark;
  final Color borderColor;

  const ContactInfoSection({
    super.key,
    required this.contactInfo,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (contactInfo == null) return const SizedBox.shrink();
    final info = contactInfo!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: CounsellingUi.cardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            info.officeName,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : GixaColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.location_on_outlined, info.address, isDark),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.phone_outlined, info.phone, isDark),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.email_outlined, info.email, isDark),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.language, info.website, isDark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isDark) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: GixaColors.blue),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
