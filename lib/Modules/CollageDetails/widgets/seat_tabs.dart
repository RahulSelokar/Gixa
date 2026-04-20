import 'package:Gixa/Modules/seatMatrix/model/seat_matrix_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────
class _T {
  static const accent = Color(0xFF4F8EF7);

  static const List<Color> quotaColors = [
    Color(0xFF4F8EF7), // blue
    Color(0xFF7C4DFF), // violet
    Color(0xFF00BFA5), // teal
    Color(0xFFFF6D40), // coral
    Color(0xFFFFCA28), // amber
  ];

  // Dark
  static const surface     = Color(0xFF161A22);
  static const surface2    = Color(0xFF1C2130);
  static const border      = Color(0xFF252C3D);
  static const textPri     = Color(0xFFEAEDF5);
  static const textSec     = Color(0xFF7A869A);
  static const textMuted   = Color(0xFF3A4255);

  // Light
  static const surfaceL    = Color(0xFFFFFFFF);
  static const surface2L   = Color(0xFFF0F4FF);
  static const borderL     = Color(0xFFE2E8F4);
  static const textPriL    = Color(0xFF0D1117);
  static const textSecL    = Color(0xFF6B7A99);
  static const textMutedL  = Color(0xFFDDE4F0);
}

// ─────────────────────────────────────────────────────────────────────────────
//  THEME SCOPE
// ─────────────────────────────────────────────────────────────────────────────
class _Theme extends InheritedWidget {
  final bool dark;
  const _Theme({required this.dark, required super.child});

  static _Theme of(BuildContext c) =>
      c.dependOnInheritedWidgetOfExactType<_Theme>()!;

  @override
  bool updateShouldNotify(_Theme o) => o.dark != dark;

  Color get surface  => dark ? _T.surface   : _T.surfaceL;
  Color get surface2 => dark ? _T.surface2  : _T.surface2L;
  Color get border   => dark ? _T.border    : _T.borderL;
  Color get text     => dark ? _T.textPri   : _T.textPriL;
  Color get sub      => dark ? _T.textSec   : _T.textSecL;
  Color get muted    => dark ? _T.textMuted : _T.textMutedL;
}

// ─────────────────────────────────────────────────────────────────────────────
//  MAIN WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class SeatsTab extends StatelessWidget {
  final List<SeatMatrixModel> seatMatrix;
  const SeatsTab({super.key, required this.seatMatrix});

  @override
  Widget build(BuildContext context) {
    if (seatMatrix.isEmpty) return const _EmptyState();

    final dark = Theme.of(context).brightness == Brightness.dark;

    final Map<String, List<SeatMatrixModel>> byCourse = {};
    for (final s in seatMatrix) {
      byCourse.putIfAbsent(s.courseName, () => []).add(s);
    }

    return _Theme(
      dark: dark,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryBanner(seatMatrix: seatMatrix, dark: dark),
            const SizedBox(height: 24),
            ...byCourse.entries.toList().asMap().entries.map((e) =>
              _CourseBlock(
                dark: dark,
                courseName: e.value.key,
                seats: e.value.value,
                colorIndex: e.key,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SUMMARY BANNER
// ─────────────────────────────────────────────────────────────────────────────
class _SummaryBanner extends StatelessWidget {
  final List<SeatMatrixModel> seatMatrix;
  final bool dark;
  const _SummaryBanner({required this.seatMatrix, required this.dark});

  @override
  Widget build(BuildContext context) {
    final totalSeats   = seatMatrix.fold<int>(0, (s, e) => s + e.totalSeats);
    final totalCourses = seatMatrix.map((e) => e.courseName).toSet().length;
    final totalQuotas  = seatMatrix.map((e) => e.quota).toSet().length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: dark
              ? [const Color(0xFF1A2340), const Color(0xFF0F1829)]
              : [const Color(0xFFEBF0FF), const Color(0xFFDDE6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _T.accent.withOpacity(0.22), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _T.accent.withOpacity(0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.event_seat_rounded, size: 12, color: _T.accent),
                const SizedBox(width: 5),
                Text(
                  'SEAT MATRIX',
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _T.accent,
                    letterSpacing: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Stat cards row
          Row(
            children: [
              _StatCard(
                label: 'Total Seats',
                value: '$totalSeats',
                icon: Icons.event_seat_rounded,
                color: _T.accent,
                dark: dark,
              ),
              const SizedBox(width: 10),
              _StatCard(
                label: 'Courses',
                value: '$totalCourses',
                icon: Icons.school_rounded,
                color: const Color(0xFF7C4DFF),
                dark: dark,
              ),
              const SizedBox(width: 10),
              _StatCard(
                label: 'Quotas',
                value: '$totalQuotas',
                icon: Icons.layers_rounded,
                color: const Color(0xFF00BFA5),
                dark: dark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  final bool dark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 130,
        width: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: dark
              ? Colors.white.withOpacity(0.06)
              : Colors.white.withOpacity(0.75),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.18), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color.withOpacity(dark ? 0.18 : 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 15, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.dmMono(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: dark ? Colors.white : _T.textPriL,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 8,
                // fontWeight: FontWeight.w500,
                color: dark ? _T.textSec : _T.textSecL,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  COURSE BLOCK
// ─────────────────────────────────────────────────────────────────────────────
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
    final theme = _Theme.of(context);
    final accentColor = _T.quotaColors[colorIndex % _T.quotaColors.length];
    final totalSeats  = seats.fold<int>(0, (s, e) => s + e.totalSeats);

    final Map<String, List<SeatMatrixModel>> byQuota = {};
    for (final s in seats) {
      byQuota.putIfAbsent(s.quota, () => []).add(s);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Course header ────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 36,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COURSE',
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: theme.sub,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      courseName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: theme.text,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(dark ? 0.18 : 0.10),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: accentColor.withOpacity(0.30),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  '$totalSeats seats',
                  style: GoogleFonts.dmMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Quota cards ──────────────────────────────────────────
          ...byQuota.entries.toList().asMap().entries.map((entry) {
            final idx        = entry.key;
            final quota      = entry.value.key;
            final quotaSeats = entry.value.value;
            final qColor     = _T.quotaColors[(colorIndex + idx) % _T.quotaColors.length];
            final maxSeats   = quotaSeats.map((s) => s.totalSeats).reduce((a, b) => a > b ? a : b);

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.border, width: 1),
                boxShadow: dark
                    ? [BoxShadow(color: Colors.black.withOpacity(0.22), blurRadius: 14, offset: const Offset(0, 5))]
                    : [BoxShadow(color: qColor.withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 6))],
              ),
              child: Column(
                children: [
                  // Quota header
                  _QuotaHeader(quota: quota, qColor: qColor, quotaSeats: quotaSeats, theme: theme),

                  Divider(height: 1, thickness: 1, color: theme.border),

                  // Round rows
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                    child: Column(
                      children: quotaSeats.asMap().entries.map((e) {
                        return _RoundRow(
                          index: e.key,
                          round: e.value,
                          qColor: qColor,
                          maxSeats: maxSeats,
                          theme: theme,
                          isLast: e.key == quotaSeats.length - 1,
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

// ─────────────────────────────────────────────────────────────────────────────
//  QUOTA HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _QuotaHeader extends StatelessWidget {
  final String quota;
  final Color qColor;
  final List<SeatMatrixModel> quotaSeats;
  final _Theme theme;

  const _QuotaHeader({
    required this.quota,
    required this.qColor,
    required this.quotaSeats,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final totalQuotaSeats = quotaSeats.fold<int>(0, (s, e) => s + e.totalSeats);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Row(
        children: [
          // Color dot
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: qColor,
              boxShadow: [
                BoxShadow(
                  color: qColor.withOpacity(0.45),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QUOTA',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: theme.sub,
                    letterSpacing: 0.9,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  quota,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: theme.text,
                  ),
                ),
              ],
            ),
          ),
          // Total seats badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: qColor.withOpacity(theme.dark ? 0.18 : 0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: qColor.withOpacity(0.25), width: 0.8),
            ),
            child: Text(
              '$totalQuotaSeats seats',
              style: GoogleFonts.dmMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: qColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Rounds badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: theme.surface2,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.border, width: 0.8),
            ),
            child: Text(
              '${quotaSeats.length}R',
              style: GoogleFonts.dmMono(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: theme.sub,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  ROUND ROW
// ─────────────────────────────────────────────────────────────────────────────
class _RoundRow extends StatelessWidget {
  final int index;
  final SeatMatrixModel round;
  final Color qColor;
  final int maxSeats;
  final _Theme theme;
  final bool isLast;

  const _RoundRow({
    required this.index,
    required this.round,
    required this.qColor,
    required this.maxSeats,
    required this.theme,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxSeats > 0 ? round.totalSeats / maxSeats : 0.0;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Round label + seat count + AIQ/State chips ────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Round badge
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: qColor.withOpacity(theme.dark ? 0.18 : 0.10),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: qColor.withOpacity(0.25), width: 0.8),
                ),
                alignment: Alignment.center,
                child: Text(
                  'R${index + 1}',
                  style: GoogleFonts.dmMono(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: qColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Round ${round.counsellingRound}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: theme.sub,
                  ),
                ),
              ),
              // Seat count
              Text(
                '${round.totalSeats}',
                style: GoogleFonts.dmMono(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: qColor,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                'seats',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: theme.sub,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ── Progress bar ──────────────────────────────────────
          Stack(
            children: [
              // Track
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.muted,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              // Fill
              FractionallySizedBox(
                widthFactor: ratio.clamp(0.0, 1.0),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        qColor.withOpacity(0.85),
                        qColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: qColor.withOpacity(0.35),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── AIQ + State chips ────────────────────────────────
          Row(
            children: [
              _QuotaChip(
                label: 'AIQ',
                value: round.aiqSeats,
                color: const Color(0xFF10B981),
                dark: theme.dark,
              ),
              const SizedBox(width: 8),
              _QuotaChip(
                label: 'State',
                value: round.stateQuotaSeats,
                color: const Color(0xFFFF6D40),
                dark: theme.dark,
              ),
            ],
          ),

          // ── Category chips ───────────────────────────────────
          if (round.categories.isNotEmpty) ...[
            const SizedBox(height: 10),
            _CategoryChipsRow(
              categories: round.categories,
              qColor: qColor,
              theme: theme,
            ),
          ],

          // Divider between rounds (not after last)
          if (!isLast) ...[
            const SizedBox(height: 14),
            Divider(height: 1, color: theme.border.withOpacity(0.6)),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  AIQ / STATE QUOTA CHIP
// ─────────────────────────────────────────────────────────────────────────────
class _QuotaChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final bool dark;

  const _QuotaChip({
    required this.label,
    required this.value,
    required this.color,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(dark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            '$value',
            style: GoogleFonts.dmMono(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  CATEGORY CHIPS ROW
// ─────────────────────────────────────────────────────────────────────────────
class _CategoryChipsRow extends StatelessWidget {
  final List<dynamic> categories; // CategorySeat
  final Color qColor;
  final _Theme theme;

  const _CategoryChipsRow({
    required this.categories,
    required this.qColor,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BY CATEGORY',
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: theme.sub,
            letterSpacing: 0.9,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: categories.map((cat) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.surface2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.border, width: 0.9),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cat.category,
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: theme.sub,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: qColor.withOpacity(theme.dark ? 0.20 : 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${cat.seats}',
                      style: GoogleFonts.dmMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: qColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  EMPTY STATE
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _T.accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.event_seat_outlined,
              color: _T.accent,
              size: 36,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'No Seat Data Available',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _T.textSec,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Check back once the seat matrix is released.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: _T.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}