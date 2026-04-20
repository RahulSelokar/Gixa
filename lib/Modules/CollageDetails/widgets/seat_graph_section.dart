import 'package:Gixa/Modules/Collage/model/collage_model.dart';
import 'package:Gixa/Modules/seatMatrix/model/seat_matrix_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// ─── Theme tokens ─────────────────────────────────────────────────────────────

class _SeatTheme {
  // final Color bg;
  final Color cardBg;
  final Color cardBorder;
  final Color chipBg;
  final Color chipBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color accentSoft;
  final Color statCard1;
  final Color statCard2;
  final Color statCard3;
  final Color gridLine;
  final Color dropdownBg;

  const _SeatTheme({
    // required this.bg,
    required this.cardBg,
    required this.cardBorder,
    required this.chipBg,
    required this.chipBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.accentSoft,
    required this.statCard1,
    required this.statCard2,
    required this.statCard3,
    required this.gridLine,
    required this.dropdownBg,
  });

  static const dark = _SeatTheme(
    // bg: Color(0xFF0F1117),
    cardBg: Color(0xFF181B27),
    cardBorder: Color(0xFF252836),
    chipBg: Color(0xFF1E2130),
    chipBorder: Color(0xFF2E3248),
    textPrimary: Color(0xFFF0F0F8),
    textSecondary: Color(0xFFCBCDE0),
    textMuted: Color(0xFF6B6F88),
    accent: Color(0xFF7C6FFF),
    accentSoft: Color(0xFF3D3580),
    statCard1: Color(0xFF1C1F30),
    statCard2: Color(0xFF1C1F30),
    statCard3: Color(0xFF1C1F30),
    gridLine: Color(0xFF252836),
    dropdownBg: Color(0xFF1E2130),
  );

  static const light = _SeatTheme(
    // bg: Color(0xFFF2F4FA),
    cardBg: Color(0xFFFFFFFF),
    cardBorder: Color(0xFFE4E7F2),
    chipBg: Color(0xFFEEECFF),
    chipBorder: Color(0xFFD0CCFF),
    textPrimary: Color(0xFF0F1117),
    textSecondary: Color(0xFF3A3D55),
    textMuted: Color(0xFF9294AC),
    accent: Color(0xFF6C63FF),
    accentSoft: Color(0xFFECEBFF),
    statCard1: Color(0xFFF5F4FF),
    statCard2: Color(0xFFF0FBF8),
    statCard3: Color(0xFFFFF3F3),
    gridLine: Color(0xFFEBEDF5),
    dropdownBg: Color(0xFFFFFFFF),
  );
}

// ─── Main Widget ──────────────────────────────────────────────────────────────

class SeatGraphTab extends StatefulWidget {
  final List<SeatMatrixModel> seatMatrix;
  final InstituteType instituteType;

  const SeatGraphTab({
    super.key,
    required this.seatMatrix,
    required this.instituteType,
  });

  @override
  State<SeatGraphTab> createState() => _SeatGraphTabState();
}

class _SeatGraphTabState extends State<SeatGraphTab>
    with SingleTickerProviderStateMixin {
  String? selectedCourse;
  int? touchedIndex;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  static const Color _purple = Color(0xFF7C6FFF);
  static const Color _blue = Color(0xFF4F8BFF);
  static const Color _teal = Color(0xFF00D4AA);
  static const Color _red = Color(0xFFFF6B6B);

  List<SeatMatrixModel> _round1Seats(List<SeatMatrixModel> seats) => seats
      .where((e) => e.counsellingRound.toLowerCase().contains("round 1"))
      .toList();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    final r1 = _round1Seats(widget.seatMatrix);
    if (r1.isNotEmpty) selectedCourse = r1.first.courseName;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  _SeatTheme get _t => Theme.of(context).brightness == Brightness.dark
      ? _SeatTheme.dark
      : _SeatTheme.light;

  @override
  Widget build(BuildContext context) {
    final r1 = _round1Seats(widget.seatMatrix);
    if (r1.isEmpty) return _emptyState();

    final courses = r1.map((e) => e.courseName).toSet().toList();
    final seat = r1.firstWhere((e) => e.courseName == selectedCourse);
    final cats = seat.categories;
    final showAIQ = widget.instituteType.name.toLowerCase().contains(
      "government",
    );

    return Container(
      // color: _t.bg,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Round chip (centered)
              Center(child: _roundChip()),
              const SizedBox(height: 20),

              // ── Course selector
              _courseSelector(courses),
              const SizedBox(height: 16),

              // ── Stats row
              _statsRow(seat),
              const SizedBox(height: 16),

              Text(
                seat.quota,
                style: TextStyle(
                  color: _t.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              // ── Category line chart card
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Seats by Category",
                          style: TextStyle(
                            color: _t.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _t.cardBorder,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: _t.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _categoryLineChart(seat, cats),
                    const SizedBox(height: 16),
                    _legendChips(cats),
                  ],
                ),
              ),

              if (showAIQ) ...[const SizedBox(height: 16), _aiqCard(seat)],
            ],
          ),
        ),
      ),
    );
  }


  Widget _emptyState() => Container(
    // color: _t.bg,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _t.cardBg,
              shape: BoxShape.circle,
              border: Border.all(color: _t.cardBorder),
            ),
            child: Icon(
              Icons.show_chart_rounded,
              color: _t.textMuted,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No Round 1 Data",
            style: TextStyle(
              color: _t.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Seat data for Round 1 is not available.",
            style: TextStyle(color: _t.textMuted, fontSize: 13),
          ),
        ],
      ),
    ),
  );

  // ─── Round Chip ─────────────────────────────────────────────────────────────

  Widget _roundChip() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: _t.chipBg,
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: _t.chipBorder),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: _purple,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "Seat Matrix",
          style: TextStyle(
            color: _t.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );

  // ─── Course Selector ─────────────────────────────────────────────────────────

  Widget _courseSelector(List<String> courses) => Container(
    decoration: BoxDecoration(
      color: _t.cardBg,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _t.cardBorder),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(
            Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.05,
          ),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: IntrinsicHeight(
      child: Row(
        children: [
          // Left accent bar
          Container(
            width: 4,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C6FFF), Color(0xFF4F8BFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SELECT COURSE",
                    style: TextStyle(
                      color: _t.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCourse,
                      isExpanded: true,
                      dropdownColor: _t.dropdownBg,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: _t.textMuted,
                        size: 24,
                      ),
                      style: TextStyle(
                        color: _t.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                      items: courses
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                c,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _t.textPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          selectedCourse = v;
                          touchedIndex = null;
                        });
                        _animController
                          ..reset()
                          ..forward();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  // ─── Stats Row ────────────────────────────────────────────────────────────────

  Widget _statsRow(SeatMatrixModel seat) => Row(
    children: [
      Expanded(
        child: _statCard(
          label: "Total Seats",
          value: _fmt(seat.totalSeats),
          icon: Icons.event_seat_rounded,
          iconColor: _purple,
          bgColor: _t.statCard1,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _statCard(
          label: "Categories",
          value: "${seat.categories.length}",
          icon: Icons.interests_rounded,
          iconColor: _purple,
          bgColor: _t.statCard2,
        ),
      ),
      const SizedBox(width: 10),
      // Expanded(
      //     child: _statCard(
      //         label: "Quota",
      //         value: seat.quota,
      //         icon: Icons.shield_rounded,
      //         iconColor: _teal,
      //         bgColor: _t.statCard3)),
    ],
  );

  Widget _statCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _t.cardBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: _t.textMuted,
            fontSize: 8,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _t.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );

  // ─── Category Line Chart ───────────────────────────────────────────────────

  Widget _categoryLineChart(SeatMatrixModel seat, List<dynamic> cats) {
    final spots = List.generate(
      cats.length,
      (i) => FlSpot(i.toDouble(), cats[i].seats.toDouble()),
    );
    final maxSeat = cats
        .map((c) => c.seats as int)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final maxY = maxSeat * 1.35;

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (cats.length - 1).toDouble(),
          minY: 0,
          maxY: maxY,
          clipData: const FlClipData.all(),
          backgroundColor: Colors.transparent,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: _t.gridLine, strokeWidth: 1),
          ),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineTouchData: LineTouchData(
            touchCallback: (event, resp) {
              setState(() {
                touchedIndex = resp?.lineBarSpots?.first.spotIndex;
              });
            },
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) =>
                  Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF252836)
                  : Colors.white,
              tooltipRoundedRadius: 10,
              tooltipBorder: BorderSide(color: _t.cardBorder),
              getTooltipItems: (spots) => spots.map((s) {
                final idx = s.x.toInt();
                final name = idx < cats.length
                    ? cats[idx].category as String
                    : "";
                return LineTooltipItem(
                  "$name\n",
                  TextStyle(
                    color: _t.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: "${s.y.toInt()} seats",
                      style: TextStyle(
                        color: _t.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.4,
              color: _purple,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, pct, bar, idx) => FlDotCirclePainter(
                  radius: touchedIndex == idx ? 7 : 4.5,
                  color: touchedIndex == idx ? Colors.white : _purple,
                  strokeWidth: touchedIndex == idx ? 2.5 : 2,
                  strokeColor: touchedIndex == idx ? _purple : _t.cardBg,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    _purple.withOpacity(
                      Theme.of(context).brightness == Brightness.dark
                          ? 0.20
                          : 0.10,
                    ),
                    _purple.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Legend Chips ─────────────────────────────────────────────────────────

  Widget _legendChips(List<dynamic> cats) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: List.generate(cats.length, (i) {
      final active = touchedIndex == i;
      return GestureDetector(
        onTap: () => setState(() => touchedIndex = active ? null : i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: active ? _purple.withOpacity(0.15) : _t.chipBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active ? _purple : _t.chipBorder,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                cats[i].category as String,
                style: TextStyle(
                  color: active ? _purple : _t.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _fmt(cats[i].seats as int),
                style: TextStyle(
                  color: active ? _t.textPrimary : _t.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      );
    }),
  );

  // ─── AIQ Card ─────────────────────────────────────────────────────────────

  Widget _aiqCard(SeatMatrixModel seat) {
    final total = seat.aiqSeats + seat.stateQuotaSeats;
    final aiqPct = total == 0 ? 0.0 : seat.aiqSeats / total;
    final statePct = total == 0 ? 0.0 : seat.stateQuotaSeats / total;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _purple.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.swap_horiz_rounded,
                  color: _purple,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "AIQ vs State Quota",
                style: TextStyle(
                  color: _t.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stacked bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 14,
              child: Row(
                children: [
                  Flexible(
                    flex: (aiqPct * 100).round().clamp(1, 99),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4F8BFF), Color(0xFF7C6FFF)],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: (statePct * 100).round().clamp(1, 99),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF9B59F5), Color(0xFFBB86FC)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Pct labels under bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "AIQ (${(aiqPct * 100).toStringAsFixed(0)}%)",
                style: TextStyle(
                  color: _t.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "STATE (${(statePct * 100).toStringAsFixed(0)}%)",
                style: TextStyle(
                  color: _t.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stat cards
          Row(
            children: [
              Expanded(
                child: _aiqStatTile(
                  "All India Quota",
                  _fmt(seat.aiqSeats),
                  _blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _aiqStatTile(
                  "State Quota",
                  _fmt(seat.stateQuotaSeats),
                  _purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Two-line crossing chart
          _aiqLineChart(seat),
        ],
      ),
    );
  }

  Widget _aiqStatTile(String label, String value, Color color) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: _t.statCard1,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _t.cardBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: _t.textMuted,
            fontSize: 8,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );

  Widget _aiqLineChart(SeatMatrixModel seat) {
    // Two lines: AIQ line goes high→low, State goes low→high (crossing effect)
    final aiqSpots = [
      FlSpot(0, seat.aiqSeats.toDouble()),
      FlSpot(0.5, (seat.aiqSeats + seat.stateQuotaSeats) / 2),
      FlSpot(1, seat.stateQuotaSeats.toDouble()),
    ];
    final stateSpots = [
      FlSpot(0, seat.stateQuotaSeats.toDouble()),
      FlSpot(0.5, (seat.aiqSeats + seat.stateQuotaSeats) / 2),
      FlSpot(1, seat.aiqSeats.toDouble()),
    ];
    final maxY = (seat.totalSeats.toDouble() * 1.2).ceilToDouble();

    return SizedBox(
      height: 130,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 1,
          minY: 0,
          maxY: maxY,
          backgroundColor: Colors.transparent,
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) =>
                  Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF252836)
                  : Colors.white,
              tooltipRoundedRadius: 8,
              getTooltipItems: (spots) => spots.map((s) {
                final isAiq = s.barIndex == 0;
                return LineTooltipItem(
                  isAiq ? "AIQ" : "State",
                  TextStyle(
                    color: isAiq ? _blue : _purple,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(
                      text: "\n${s.y.toInt()} seats",
                      style: TextStyle(color: _t.textSecondary, fontSize: 11),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            // AIQ line (blue)
            LineChartBarData(
              spots: aiqSpots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: _blue.withOpacity(0.8),
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, i) => FlDotCirclePainter(
                  radius: i == 0 || i == 2 ? 5 : 0,
                  color: _blue,
                  strokeWidth: 2,
                  strokeColor: _t.cardBg,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [_blue.withOpacity(0.12), _blue.withOpacity(0.0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // State line (purple)
            LineChartBarData(
              spots: stateSpots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: _purple.withOpacity(0.8),
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, i) => FlDotCirclePainter(
                  radius: i == 0 || i == 2 ? 5 : 0,
                  color: _purple,
                  strokeWidth: 2,
                  strokeColor: _t.cardBg,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [_purple.withOpacity(0.0), _purple.withOpacity(0.12)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Shared Card ──────────────────────────────────────────────────────────────

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: _t.cardBg,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _t.cardBorder),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(
            Theme.of(context).brightness == Brightness.dark ? 0.25 : 0.06,
          ),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  String _fmt(int n) {
    if (n >= 1000) {
      final s = n.toString();
      final rem = s.length % 3;
      final groups = <String>[];
      if (rem > 0) groups.add(s.substring(0, rem));
      for (var i = rem; i < s.length; i += 3) {
        groups.add(s.substring(i, i + 3));
      }
      return groups.join(",");
    }
    return n.toString();
  }
}
