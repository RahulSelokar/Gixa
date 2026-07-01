import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/counselling_state_model.dart';
import '../widgets/shared_widgets.dart';

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
    if (state.percentiles.isEmpty &&
        state.coreRequirements.isEmpty &&
        state.eligibilityHighlights.isEmpty) {
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
                "No eligibility data available",
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
        if (state.percentiles.isNotEmpty) ...[
          _SectionTitle(
            title:
                "NEET UG 2025 MINIMUM PERCENTILE (PCB) - MBBS/BDS/BAMS/BHMS/BUMS",
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _PercentilesSection(
            percentiles: state.percentiles,
            isDark: isDark,
            borderColor: borderColor,
          ),
          const SizedBox(height: 32),
        ],

        if (state.coreRequirements.isNotEmpty) ...[
          _SectionTitle(title: "CORE ELIGIBILITY REQUIREMENTS", isDark: isDark),
          const SizedBox(height: 12),
          _CoreRequirementsSection(
            requirements: state.coreRequirements,
            isDark: isDark,
            borderColor: borderColor,
          ),
          const SizedBox(height: 32),
        ],

        if (state.eligibilityHighlights.isNotEmpty) ...[
          _SectionTitle(
            title: "IMPORTANT ELIGIBILITY HIGHLIGHTS",
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _EligibilityHighlightsSection(
            highlights: state.eligibilityHighlights,
            isDark: isDark,
            borderColor: borderColor,
          ),
          const SizedBox(height: 22),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionTitle({required this.title, required this.isDark});

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

class _PercentilesSection extends StatelessWidget {
  final List<PercentileData> percentiles;
  final bool isDark;
  final Color borderColor;

  const _PercentilesSection({
    required this.percentiles,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: percentiles
                .map(
                  (p) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: p == percentiles.last ? 0 : 12,
                      ),
                      child: _buildPercentileCard(p),
                    ),
                  ),
                )
                .toList(),
          );
        } else {
          return Column(
            children: percentiles
                .map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildPercentileCard(p),
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildPercentileCard(PercentileData data) {
    final String numPart = data.percentile.replaceAll(RegExp(r'[^0-9]'), '');
    final String textPart = data.percentile.replaceAll(RegExp(r'[0-9]'), '');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? data.themeColor.withOpacity(0.05)
            : data.themeColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: data.themeColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                numPart,
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: data.themeColor,
                  height: 1,
                ),
              ),
              if (textPart.isNotEmpty)
                Text(
                  textPart,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: data.themeColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.category,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : GixaColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.description,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoreRequirementsSection extends StatelessWidget {
  final List<CoreRequirementData> requirements;
  final bool isDark;
  final Color borderColor;

  const _CoreRequirementsSection({
    required this.requirements,
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
          children: requirements.map((req) {
            double width =
                (constraints.maxWidth - (12 * (crossAxisCount - 1))) /
                crossAxisCount;
            return SizedBox(width: width, child: _buildRequirementCard(req));
          }).toList(),
        );
      },
    );
  }

  Widget _buildRequirementCard(CoreRequirementData data) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: CounsellingUi.cardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                Icon(data.icon, size: 18, color: data.themeColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : GixaColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: data.rows.map((row) => _buildRow(row)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(RequirementRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              row.label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: row.isValueHighlight
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            row.highlightColor?.withOpacity(0.15) ??
                            Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        row.value,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: row.highlightColor ?? Colors.green,
                        ),
                      ),
                    ),
                  )
                : Text(
                    row.value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : GixaColors.ink,
                      height: 1.3,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _EligibilityHighlightsSection extends StatelessWidget {
  final List<EligibilityHighlightData> highlights;
  final bool isDark;
  final Color borderColor;

  const _EligibilityHighlightsSection({
    required this.highlights,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: highlights
                .map(
                  (h) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: h == highlights.last ? 0 : 12,
                      ),
                      child: _buildHighlightCard(h),
                    ),
                  ),
                )
                .toList(),
          );
        } else {
          return Column(
            children: highlights
                .map(
                  (h) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildHighlightCard(h),
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildHighlightCard(EligibilityHighlightData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? data.themeColor.withOpacity(0.08)
            : data.themeColor.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
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
                    color: data.themeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (data.content.isNotEmpty)
            Text(
              data.content,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade800,
                height: 1.4,
              ),
            ),
          if (data.tags != null && data.tags!.isNotEmpty) ...[
            if (data.content.isNotEmpty) const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: data.tags!
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                        ),
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tag.split('→').first.trim(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFFFCA5A5)
                                  : const Color(0xFFC2410C), // Reddish/Orange
                            ),
                          ),
                          if (tag.contains('→')) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Text(
                                "→",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ),
                            Text(
                              tag.split('→').last.trim(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? const Color(0xFF5EEAD4)
                                    : const Color(0xFF0F766E), // Teal/Green
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
