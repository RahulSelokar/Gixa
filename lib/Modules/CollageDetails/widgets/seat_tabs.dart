import 'package:Gixa/Modules/seatMatrix/model/seat_matrix_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
//  DESIGN TOKENS
// ─────────────────────────────────────────────
class _T {
  // Brand
  static const accent   = Color(0xFF4F8EF7);
  static const accentLo = Color(0x1A4F8EF7);
  static const accentMid = Color(0x334F8EF7);

  // Quota palette  (rotates by index)
  static const List<Color> quotaColors = [
    Color(0xFF4F8EF7), // blue
    Color(0xFF7C4DFF), // violet
    Color(0xFF00BFA5), // teal
    Color(0xFFFF6D40), // coral
    Color(0xFFFFCA28), // amber
  ];

  // Dark surface
  static const bg        = Color(0xFF0D0F14);
  static const surface   = Color(0xFF161A22);
  static const surface2  = Color(0xFF1C2130);
  static const border    = Color(0xFF252C3D);
  static const textPrimary   = Color(0xFFEAEDF5);
  static const textSecondary = Color(0xFF7A869A);
  static const textMuted     = Color(0xFF4A5568);

  // Light surface
  static const bgLight       = Color(0xFFF4F6FB);
  static const surfaceLight  = Color(0xFFFFFFFF);
  static const surface2Light = Color(0xFFF0F4FF);
  static const borderLight   = Color(0xFFE2E8F4);
  static const textPrimaryLight   = Color(0xFF0D1117);
  static const textSecondaryLight = Color(0xFF6B7A99);
}

// ─────────────────────────────────────────────
//  MAIN WIDGET
// ─────────────────────────────────────────────
class SeatsTab extends StatelessWidget {
  final List<SeatMatrixModel> seatMatrix;

  const SeatsTab({super.key, required this.seatMatrix});

  @override
  Widget build(BuildContext context) {
    if (seatMatrix.isEmpty) {
      return _EmptyState();
    }

    final dark = Theme.of(context).brightness == Brightness.dark;

    final Map<String, List<SeatMatrixModel>> byCourse = {};
    for (final s in seatMatrix) {
      byCourse.putIfAbsent(s.courseName, () => []).add(s);
    }

    return _ThemeScope(
      dark: dark,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryBanner(seatMatrix: seatMatrix, dark: dark),
            const SizedBox(height: 28),
            ...byCourse.entries.toList().asMap().entries.map((e) {
              return _CourseBlock(
                dark: dark,
                courseName: e.value.key,
                seats: e.value.value,
                colorIndex: e.key,
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  THEME SCOPE  (inherited widget for dark flag)
// ─────────────────────────────────────────────
class _ThemeScope extends InheritedWidget {
  final bool dark;
  const _ThemeScope({required this.dark, required super.child});

  static _ThemeScope of(BuildContext c) =>
      c.dependOnInheritedWidgetOfExactType<_ThemeScope>()!;

  @override
  bool updateShouldNotify(_ThemeScope o) => o.dark != dark;

  Color get bg        => dark ? _T.bg        : _T.bgLight;
  Color get surface   => dark ? _T.surface   : _T.surfaceLight;
  Color get surface2  => dark ? _T.surface2  : _T.surface2Light;
  Color get border    => dark ? _T.border    : _T.borderLight;
  Color get text      => dark ? _T.textPrimary   : _T.textPrimaryLight;
  Color get subText   => dark ? _T.textSecondary : _T.textSecondaryLight;
  Color get muted     => dark ? _T.textMuted     : _T.borderLight;
}

// ─────────────────────────────────────────────
//  SUMMARY BANNER
// ─────────────────────────────────────────────
class _SummaryBanner extends StatelessWidget {
  final List<SeatMatrixModel> seatMatrix;
  final bool dark;
  const _SummaryBanner({required this.seatMatrix, required this.dark});

  @override
  Widget build(BuildContext context) {
    final totalSeats   = seatMatrix.fold<int>(0, (s, e) => s + e.totalSeats);
    final totalCourses = seatMatrix.map((e) => e.courseName).toSet().length;
    final totalQuotas  = seatMatrix.map((e) => e.quota).toSet().length;
    final theme = _ThemeScope.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: dark
              ? [const Color(0xFF1A2340), const Color(0xFF0F1829)]
              : [const Color(0xFFEBF0FF), const Color(0xFFDDE6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _T.accent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _T.accentMid,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'SEAT MATRIX',
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _T.accent,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatPill(label: 'Total Seats', value: '$totalSeats', icon: Icons.event_seat_rounded),
              const SizedBox(width: 12),
              _StatPill(label: 'Courses', value: '$totalCourses', icon: Icons.school_rounded),
              const SizedBox(width: 12),
              _StatPill(label: 'Quotas', value: '$totalQuotas', icon: Icons.layers_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StatPill({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = _ThemeScope.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: theme.dark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _T.accent.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: _T.accent),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.dmMono(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.dark ? Colors.white : _T.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: theme.subText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  COURSE BLOCK
// ─────────────────────────────────────────────
class _CourseBlock extends StatelessWidget {
  final bool dark;
  final String courseName;
  final List<SeatMatrixModel> seats;
  final int colorIndex;

  const _CourseBlock({
    required this.dark,
    required this.courseName,
    required this.seats,
    required this.colorIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = _ThemeScope.of(context);
    final accentColor = _T.quotaColors[colorIndex % _T.quotaColors.length];

    final Map<String, List<SeatMatrixModel>> byQuota = {};
    for (final s in seats) {
      byQuota.putIfAbsent(s.quota, () => []).add(s);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Course Header ──────────────────────────
          Row(
            children: [
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  courseName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: theme.text,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${seats.fold<int>(0, (s, e) => s + e.totalSeats)} seats',
                  style: GoogleFonts.dmMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Quota Cards ────────────────────────────
          ...byQuota.entries.toList().asMap().entries.map((entry) {
            final idx  = entry.key;
            final quota = entry.value.key;
            final quotaSeats = entry.value.value;
            final qColor = _T.quotaColors[(colorIndex + idx) % _T.quotaColors.length];
            final maxSeats = quotaSeats.map((s) => s.totalSeats).reduce((a, b) => a > b ? a : b);

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.border),
                boxShadow: dark
                    ? [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 6))]
                    : [BoxShadow(color: const Color(0x0F4F8EF7), blurRadius: 20, offset: const Offset(0, 6))],
              ),
              child: Column(
                children: [
                  // Quota header row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: qColor.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.category_rounded, color: qColor, size: 16),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            quota,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: theme.text,
                            ),
                          ),
                        ),
                        Text(
                          '${quotaSeats.length} round${quotaSeats.length > 1 ? 's' : ''}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: theme.subText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Divider(height: 1, color: theme.border),

                  // Rounds
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                    child: Column(
                      children: quotaSeats.asMap().entries.map((e) {
                        final round = e.value;
                        final ratio = maxSeats > 0 ? round.totalSeats / maxSeats : 0.0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: theme.surface2,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: theme.border),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${e.key + 1}',
                                          style: GoogleFonts.dmMono(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: theme.subText,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        round.counsellingRound,
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w500,
                                          color: theme.subText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: qColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${round.totalSeats}',
                                      style: GoogleFonts.dmMono(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: qColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              // Progress bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: ratio,
                                  minHeight: 4,
                                  backgroundColor: theme.muted,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    qColor.withOpacity(0.75),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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

// ─────────────────────────────────────────────
//  EMPTY STATE
// ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: _T.accentLo,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.event_seat_outlined, color: _T.accent, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'No Seat Data Available',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _T.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Check back once the seat matrix is released.',
            style: GoogleFonts.inter(fontSize: 13, color: _T.textMuted),
          ),
        ],
      ),
    );
  }
}