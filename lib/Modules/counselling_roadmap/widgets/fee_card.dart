import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/counselling_state_model.dart';
import '../widgets/shared_widgets.dart';

class FeeCard extends StatelessWidget {
  final CounsellingFees fees;
  final bool isDark;
  final Color borderColor;

  const FeeCard({
    required this.fees,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = CounsellingUi.cardBg(context, isDark);
    final textColor = CounsellingUi.textPrimary(isDark);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: CounsellingUi.cardShadow(isDark),
      ),
      child: Column(
        children: [
          FeeRow(
            icon: Icons.receipt_long_outlined,
            iconColor: GixaColors.orange,
            label: "Application Fee",
            value: fees.applicationFee ?? "Not Disclosed",
            badge: null,
            isDark: isDark,
            textColor: textColor,
          ),
          const SizedBox(height: 14),
          FeeRow(
            icon: Icons.receipt_outlined,
            iconColor: GixaColors.blue,
            label: "Registration Fee",
            value: fees.registrationFee,
            badge: null,
            isDark: isDark,
            textColor: textColor,
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 14),
          FeeRow(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: GixaColors.violet,
            label: "Security Deposit",
            value: fees.securityDeposit,
            badge: fees.isSecurityRefundable ? "Refundable" : "Non-Refundable",
            badgeColor:
                fees.isSecurityRefundable ? GixaColors.green : GixaColors.pink,
            isDark: isDark,
            textColor: textColor,
          ),
        ],
      ),
    );
  }
}

class FeeRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? badge;
  final Color? badgeColor;
  final bool isDark;
  final Color textColor;

  const FeeRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.badge,
    this.badgeColor,
    required this.isDark,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 19),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CounsellingUi.textSecondary(isDark),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  height: 1.3,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: badgeColor!.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: badgeColor!.withOpacity(0.3)),
            ),
            child: Text(
              badge!,
              style: TextStyle(
                color: badgeColor,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}