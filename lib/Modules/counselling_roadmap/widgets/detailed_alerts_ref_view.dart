import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/counselling_state_model.dart';
import '../widgets/shared_widgets.dart';

class DetailedAlertsRefView extends StatelessWidget {
  final CounsellingStateData state;
  final bool isDark;
  final Color borderColor;

  const DetailedAlertsRefView({
    super.key,
    required this.state,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (state.numberedAlerts.isEmpty && state.abbreviations.isEmpty) {
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
                "No alerts or reference data available",
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
            // ── ALERTS GRID ──
            if (state.numberedAlerts.isNotEmpty) ...[
              _SectionTitle(title: "CRITICAL ALERTS FOR ALL CANDIDATES"),
              const SizedBox(height: 16),
              _NumberedAlertsGrid(
                alerts: state.numberedAlerts,
                isDark: isDark,
                borderColor: borderColor,
              ),
              const SizedBox(height: 32),
            ],

            // ── PROCESS PITFALLS ──
            if (state.processPitfalls != null) ...[
              _ProcessPitfallsCard(
                pitfallsData: state.processPitfalls!,
                isDark: isDark,
                borderColor: borderColor,
              ),
              const SizedBox(height: 32),
            ],

            // ── STRATEGY CARDS ──
            if (state.strategyCards.isNotEmpty) ...[
              _StrategyCardsList(
                cards: state.strategyCards,
                isDark: isDark,
                borderColor: borderColor,
              ),
              const SizedBox(height: 32),
            ],

            // ── CONTACT & DOCUMENTS ──
            if (state.detailedContactInfo != null ||
                state.documentChecklist.isNotEmpty) ...[
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.detailedContactInfo != null)
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _ContactCard(
                            contactInfo: state.detailedContactInfo!,
                            isDark: isDark,
                          ),
                        ),
                      ),
                    if (state.documentChecklist.isNotEmpty)
                      Expanded(
                        flex: 6,
                        child: _DocumentsCard(
                          documents: state.documentChecklist,
                          isDark: isDark,
                        ),
                      ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.detailedContactInfo != null) ...[
                      _ContactCard(
                        contactInfo: state.detailedContactInfo!,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (state.documentChecklist.isNotEmpty)
                      _DocumentsCard(
                        documents: state.documentChecklist,
                        isDark: isDark,
                      ),
                  ],
                ),
              const SizedBox(height: 32),
            ],

            // ── ABBREVIATIONS GRID ──
            if (state.abbreviations.isNotEmpty) ...[
              _SectionTitle(title: "KEY ABBREVIATIONS"),
              const SizedBox(height: 16),
              _AbbreviationsGrid(
                abbreviations: state.abbreviations,
                isDark: isDark,
                borderColor: borderColor,
              ),
              const SizedBox(height: 32),
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

class _NumberedAlertsGrid extends StatelessWidget {
  final List<NumberedAlertData> alerts;
  final bool isDark;
  final Color borderColor;

  const _NumberedAlertsGrid({
    required this.alerts,
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
          children: alerts.map((alert) {
            double width =
                (constraints.maxWidth - (12 * (crossAxisCount - 1))) /
                crossAxisCount;
            return SizedBox(
              width: width,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? alert.themeColor.withOpacity(0.05)
                      : alert.themeColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: alert.themeColor.withOpacity(0.3)),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: alert.themeColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            alert.severityLabel,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          alert.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: alert.themeColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          alert.content,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: -10,
                      right: 0,
                      child: Text(
                        alert.number.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 64,
                          fontWeight: FontWeight.w900,
                          color: alert.themeColor.withOpacity(0.1),
                          height: 1,
                        ),
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

class _ContactCard extends StatelessWidget {
  final DetailedContactInfo contactInfo;
  final bool isDark;

  const _ContactCard({required this.contactInfo, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: CounsellingUi.cardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.phone_in_talk_rounded,
                color: Color(0xFF6B7280),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "State CET Cell Contact",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _ContactRow(
            icon: Icons.business,
            label: "Office",
            value: contactInfo.officeName,
            isDark: isDark,
          ),
          const Divider(height: 24),
          _ContactRow(
            icon: Icons.location_on,
            label: "Address",
            value: contactInfo.address,
            isDark: isDark,
          ),
          const Divider(height: 24),
          _ContactRow(
            icon: Icons.phone,
            label: "Phone",
            value: contactInfo.phone,
            isDark: isDark,
            isLink: true,
          ),
          const Divider(height: 24),
          _ContactRow(
            icon: Icons.email,
            label: "Email",
            value: contactInfo.email,
            isDark: isDark,
            isLink: true,
          ),
          const Divider(height: 24),
          _ContactRow(
            icon: Icons.language,
            label: "Website (Applications & Merit List)",
            value: contactInfo.websiteUrl,
            isDark: isDark,
            isLink: true,
          ),
          const Divider(height: 24),
          _ContactRow(
            icon: Icons.attach_money,
            label: "Fee Structure (Private/Minority)",
            value: contactInfo.feeStructureUrl,
            isDark: isDark,
            isLink: true,
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final bool isLink;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF9CA3AF), size: 16),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isLink
                      ? const Color(0xFF3B82F6)
                      : (isDark ? Colors.grey.shade300 : Colors.grey.shade800),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DocumentsCard extends StatelessWidget {
  final List<DocumentChecklistItem> documents;
  final bool isDark;

  const _DocumentsCard({required this.documents, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: CounsellingUi.cardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.folder_shared_rounded,
                color: Color(0xFFEAB308),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Documents at Physical Document Verification",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              int cols = constraints.maxWidth > 500 ? 2 : 1;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: documents.map((doc) {
                  double width =
                      (constraints.maxWidth - (16 * (cols - 1))) / cols;
                  return SizedBox(
                    width: width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (doc.isMandatory)
                          const Text(
                            "★",
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 14,
                            ),
                          )
                        else
                          const Text(
                            "✓",
                            style: TextStyle(
                              color: Color(0xFF3B82F6),
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            doc.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            "★ = Mandatory for ALL candidates. Bring originals + 1 attested set.",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }
}

class _AbbreviationsGrid extends StatelessWidget {
  final List<AbbreviationData> abbreviations;
  final bool isDark;
  final Color borderColor;

  const _AbbreviationsGrid({
    required this.abbreviations,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 1000
            ? 5
            : (constraints.maxWidth > 800
                  ? 4
                  : (constraints.maxWidth > 500 ? 3 : 2));

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: abbreviations.map((abbr) {
            double width =
                (constraints.maxWidth - (8 * (crossAxisCount - 1))) /
                crossAxisCount;
            return SizedBox(
              width: width,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.02) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      abbr.abbreviation,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFEF4444), // Red
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      abbr.fullForm,
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                        height: 1.3,
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

class _ProcessPitfallsCard extends StatelessWidget {
  final ProcessPitfallsData pitfallsData;
  final bool isDark;
  final Color borderColor;

  const _ProcessPitfallsCard({
    required this.pitfallsData,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFFD97706).withOpacity(0.05)
            : const Color(0xFFF59E0B).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? const Color(0xFFD97706).withOpacity(0.3)
              : const Color(0xFFD97706).withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFF59E0B),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                pitfallsData.title.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 800
                  ? 3
                  : (constraints.maxWidth > 500 ? 2 : 1);
              return Wrap(
                spacing: 20,
                runSpacing: 16,
                children: pitfallsData.pitfalls.map((pitfall) {
                  double width =
                      (constraints.maxWidth - (20 * (crossAxisCount - 1))) /
                      crossAxisCount;
                  return SizedBox(
                    width: width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            pitfall,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StrategyCardsList extends StatelessWidget {
  final List<StrategyCardData> cards;
  final bool isDark;
  final Color borderColor;

  const _StrategyCardsList({
    required this.cards,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 1000
            ? 5
            : (constraints.maxWidth > 800
                  ? 4
                  : (constraints.maxWidth > 500 ? 3 : 2));
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: cards.map((card) {
            double width =
                (constraints.maxWidth - (12 * (crossAxisCount - 1))) /
                crossAxisCount;
            return SizedBox(
              width: width,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? card.themeColor.withOpacity(0.05)
                      : card.themeColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? card.themeColor.withOpacity(0.2)
                        : card.themeColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(card.icon, size: 24, color: card.themeColor),
                    const SizedBox(height: 12),
                    Text(
                      card.title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: card.themeColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      card.description,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: isDark ? Colors.white70 : Colors.black87,
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
