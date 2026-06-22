import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/counselling_state_model.dart';
import '../widgets/shared_widgets.dart';
import 'package:intl/intl.dart';

class DetailedCapFeesView extends StatelessWidget {
  final CounsellingStateData state;
  final bool isDark;
  final Color borderColor;

  const DetailedCapFeesView({
    super.key,
    required this.state,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (state.applicationFees.isEmpty && state.penalties.isEmpty) {
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
                "No fee data available",
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 800;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── APPLICATION FORM FEES ──
            if (state.applicationFees.isNotEmpty) ...[
              _SectionTitle(title: "APPLICATION FORM FEES (NON-REFUNDABLE)"),
              const SizedBox(height: 16),
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: state.applicationFees
                      .map(
                        (fee) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: fee == state.applicationFees.first
                                  ? 16
                                  : 0,
                              left:
                                  fee == state.applicationFees.last &&
                                      state.applicationFees.length > 1
                                  ? 16
                                  : 0,
                            ),
                            child: _ApplicationFeeCard(
                              fee: fee,
                              isDark: isDark,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                )
              else
                Column(
                  children: state.applicationFees
                      .map(
                        (fee) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _ApplicationFeeCard(fee: fee, isDark: isDark),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 32),
            ],

            // ── PREFERENCE FORM CODE ALERT ──
            if (state.feePreferenceAlert != null) ...[
              _YellowAlertBox(alert: state.feePreferenceAlert!),
              const SizedBox(height: 32),
            ],

            // ── FEES REFUND POLICY ──
            if (state.refundPolicies.isNotEmpty) ...[
              _SectionTitle(title: "FEES REFUND & CANCELLATION POLICY"),
              const SizedBox(height: 16),
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: state.refundPolicies
                      .map(
                        (policy) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: policy == state.refundPolicies.first
                                  ? 16
                                  : 0,
                              left:
                                  policy == state.refundPolicies.last &&
                                      state.refundPolicies.length > 1
                                  ? 16
                                  : 0,
                            ),
                            child: _RefundPolicyCard(
                              policy: policy,
                              isDark: isDark,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                )
              else
                Column(
                  children: state.refundPolicies
                      .map(
                        (policy) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _RefundPolicyCard(
                            policy: policy,
                            isDark: isDark,
                          ),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 32),
            ],

            // ── PENALTIES GRID ──
            if (state.penalties.isNotEmpty) ...[
              _SectionTitle(title: "PENALTIES FOR LAPSING / RESIGNING SEATS"),
              const SizedBox(height: 16),
              _PenaltiesGrid(
                penalties: state.penalties,
                isDark: isDark,
                borderColor: borderColor,
              ),
              const SizedBox(height: 32),
            ],

            // ── DISQUALIFICATION ALERT ──
            if (state.feeDisqualificationAlert != null) ...[
              _CriticalAlertBox(alert: state.feeDisqualificationAlert!),
              const SizedBox(height: 22),
            ],
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: const Color(0xFFFF6B35),
      ),
    );
  }
}

class _ApplicationFeeCard extends StatelessWidget {
  final ApplicationFeeData fee;
  final bool isDark;

  const _ApplicationFeeCard({required this.fee, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'en_IN',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: fee.themeColor, width: 2),
        boxShadow: CounsellingUi.cardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fee.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: fee.themeColor,
            ),
          ),
          const SizedBox(height: 24),
          ...fee.rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      row.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: row.isTotal
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isDark ? Colors.white70 : GixaColors.ink,
                      ),
                    ),
                  ),
                  Text(
                    formatCurrency.format(row.amount),
                    style: TextStyle(
                      fontSize: row.isTotal ? 16 : 14,
                      fontWeight: FontWeight.w800,
                      color: row.isTotal
                          ? fee.themeColor
                          : (isDark ? Colors.white : Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (fee.footnote != null) ...[
            const Divider(height: 32),
            Text(
              fee.footnote!,
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RefundPolicyCard extends StatelessWidget {
  final FeeRefundPolicyData policy;
  final bool isDark;

  const _RefundPolicyCard({required this.policy, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? policy.themeColor.withOpacity(0.05)
            : policy.themeColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: policy.themeColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(policy.icon, color: policy.themeColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  policy.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: policy.themeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...policy.points.map((point) {
            final parts = point.split("→");
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(policy.icon, color: policy.themeColor, size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: parts.length > 1
                        ? Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: parts[0] + "→",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade800,
                                  ),
                                ),
                                TextSpan(
                                  text: parts[1],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Text(
                            point,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade800,
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
  }
}

class _PenaltiesGrid extends StatelessWidget {
  final List<PenaltyCardData> penalties;
  final bool isDark;
  final Color borderColor;

  const _PenaltiesGrid({
    required this.penalties,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 800
            ? 3
            : (constraints.maxWidth > 500 ? 2 : 1);

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: penalties.map((penalty) {
            double width =
                (constraints.maxWidth - (12 * (crossAxisCount - 1))) /
                crossAxisCount;
            return SizedBox(
              width: width,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.02) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                  boxShadow: CounsellingUi.cardShadow(isDark),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      penalty.title,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: penalty.themeColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      penalty.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      penalty.penaltyAmount,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: penalty.themeColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _YellowAlertBox extends StatelessWidget {
  final AlertInfo alert;

  const _YellowAlertBox({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9C3), // Light Yellow background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE047)), // Yellow border
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: Color(0xFFCA8A04),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${alert.title} ",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF854D0E), // Dark Yellow
                    ),
                  ),
                  TextSpan(
                    text: alert.description,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF854D0E), // Dark Yellow
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CriticalAlertBox extends StatelessWidget {
  final AlertInfo alert;

  const _CriticalAlertBox({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2), // Light Red background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFCA5A5)), // Red border
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFEF4444),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${alert.title} ",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF991B1B), // Dark red
                    ),
                  ),
                  TextSpan(
                    text: alert.description,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF991B1B), // Dark red
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
