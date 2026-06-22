import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/counselling_state_model.dart';
import '../widgets/shared_widgets.dart';

class DetailedReservationView extends StatelessWidget {
  final CounsellingStateData state;
  final bool isDark;
  final Color borderColor;

  const DetailedReservationView({
    super.key,
    required this.state,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (state.constitutionalReservation == null &&
        state.detailedReservations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            children: [
              Icon(Icons.hourglass_empty_rounded, size: 48, color: Colors.grey.withOpacity(0.5)),
              const SizedBox(height: 16),
              Text(
                "No reservation data available",
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

    return LayoutBuilder(builder: (context, constraints) {
      final bool isWide = constraints.maxWidth > 800;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── TOP SECTION: BARS & RULES ──
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.constitutionalReservation != null)
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _ConstitutionalBarsCard(
                        data: state.constitutionalReservation!,
                        isDark: isDark,
                        borderColor: borderColor,
                      ),
                    ),
                  ),
                if (state.reservationRules.isNotEmpty)
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: state.reservationRules
                          .map((rule) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _RuleHighlightCard(
                                  data: rule,
                                  isDark: isDark,
                                  borderColor: borderColor,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
              ],
            )
          else ...[
            if (state.constitutionalReservation != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _ConstitutionalBarsCard(
                  data: state.constitutionalReservation!,
                  isDark: isDark,
                  borderColor: borderColor,
                ),
              ),
            if (state.reservationRules.isNotEmpty)
              Column(
                children: state.reservationRules
                    .map((rule) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _RuleHighlightCard(
                            data: rule,
                            isDark: isDark,
                            borderColor: borderColor,
                          ),
                        ))
                    .toList(),
              ),
          ],
          
          const SizedBox(height: 32),

          // ── CATEGORIES GRID ──
          if (state.detailedReservations.isNotEmpty) ...[
            Text(
              "ALL RESERVATION CATEGORIES - AT A GLANCE",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: const Color(0xFFFF6B35),
              ),
            ),
            const SizedBox(height: 16),
            _CategoriesGrid(
              categories: state.detailedReservations,
              isDark: isDark,
              borderColor: borderColor,
              isWide: isWide,
            ),
            const SizedBox(height: 32),
          ],

          // ── CRITICAL ALERT ──
          if (state.reservationCriticalAlert != null) ...[
            _CriticalAlertBox(
              alert: state.reservationCriticalAlert!,
              isDark: isDark,
            ),
            const SizedBox(height: 22),
          ],
        ],
      );
    });
  }
}

class _ConstitutionalBarsCard extends StatelessWidget {
  final ConstitutionalReservationData data;
  final bool isDark;
  final Color borderColor;

  const _ConstitutionalBarsCard({
    required this.data,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: CounsellingUi.cardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : GixaColors.ink,
            ),
          ),
          const SizedBox(height: 20),
          ...data.rows.map((row) => _buildBarRow(row)).toList(),
          const SizedBox(height: 16),
          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarRow(ReservationBarRow row) {
    final double fraction = (row.percentage / 30.0).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              row.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : GixaColors.ink,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              children: [
                Expanded(
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: fraction,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: row.themeColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        row.abbreviation,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 32,
                  child: Text(
                    "${row.percentage.toStringAsFixed(row.percentage.truncateToDouble() == row.percentage ? 0 : 1)}%",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: row.themeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleHighlightCard extends StatelessWidget {
  final RuleHighlightData data;
  final bool isDark;
  final Color borderColor;

  const _RuleHighlightCard({
    required this.data,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? data.themeColor.withOpacity(0.05) : data.themeColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: data.themeColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(data.icon, size: 16, color: data.themeColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? data.themeColor : data.themeColor.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.content,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade800,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesGrid extends StatelessWidget {
  final List<DetailedReservationCategory> categories;
  final bool isDark;
  final Color borderColor;
  final bool isWide;

  const _CategoriesGrid({
    required this.categories,
    required this.isDark,
    required this.borderColor,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 800 ? 3 : (constraints.maxWidth > 500 ? 2 : 1);
        
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: categories.map((cat) {
            double width = (constraints.maxWidth - (12 * (crossAxisCount - 1))) / crossAxisCount;
            return SizedBox(
              width: width,
              child: _buildCategoryCard(cat),
            );
          }).toList(),
        );
      }
    );
  }

  Widget _buildCategoryCard(DetailedReservationCategory cat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: CounsellingUi.cardShadow(isDark),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: cat.themeColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : GixaColors.ink,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cat.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CriticalAlertBox extends StatelessWidget {
  final AlertInfo alert;
  final bool isDark;

  const _CriticalAlertBox({
    required this.alert,
    required this.isDark,
  });

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
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 20),
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
