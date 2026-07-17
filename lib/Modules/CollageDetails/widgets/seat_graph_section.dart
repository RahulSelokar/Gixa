import 'package:Gixa/Modules/Collage/model/collage_model.dart';
import 'package:Gixa/Modules/seatMatrix/model/seat_matrix_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/CollageDetails/controller/collage_detail_controller.dart';

import 'package:Gixa/Modules/CollageDetails/widgets/collage_theme.dart';

// ─── Main Widget ──────────────────────────────────────────────────────────────

class SeatGraphTab extends StatefulWidget {
  final List<SeatMatrixModel> seatMatrix;
  final InstituteType instituteType;
  final String collegeName;
  final CollegeThemeColors colors;

  const SeatGraphTab({
    super.key,
    required this.seatMatrix,
    required this.instituteType,
    required this.collegeName,
    required this.colors,
  });

  @override
  State<SeatGraphTab> createState() => _SeatGraphTabState();
}

class _ThemeProxy {
  final CollegeThemeColors colors;
  _ThemeProxy(this.colors);

  Color get cardBg => colors.cardBackground;
  Color get cardBorder => colors.border;
  Color get chipBg => colors.cardBackgroundSoft;
  Color get chipBorder => colors.subtleBorder;
  Color get textPrimary => colors.textMain;
  Color get textSecondary => colors.textSub;
  Color get textMuted => colors.textMuted;
  Color get accent => colors.primary;
  Color get statCard1 => colors.cardBackgroundSoft;
  Color get statCard2 => colors.surfaceHighlight;
  Color get gridLine => colors.subtleBorder;
  Color get dropdownBg => colors.cardBackground;
}

class _SeatGraphTabState extends State<SeatGraphTab>
    with SingleTickerProviderStateMixin {
  String? selectedCourse;
  int? touchedIndex;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  Color get _purple => widget.colors.purple;
  Color get _blue => widget.colors.secondary;
  Color get _teal => widget.colors.success;

  _ThemeProxy get _t => _ThemeProxy(widget.colors);

  List<SeatMatrixModel> _preferredSeats(List<SeatMatrixModel> seats) {
    final profileController = Get.find<ProfileController>();
    final isUG = profileController.isUGUser;
    
    // Filter by UG/PG
    var filteredSeats = seats.where((e) {
      final level = e.courseLevel.toLowerCase();
      if (isUG && level.contains('ug')) return true;
      if (!isUG && level.contains('pg')) return true;
      return false;
    }).toList();
    
    // Fallback if no seats match profile
    if (filteredSeats.isEmpty) {
      filteredSeats = seats;
    }

    final round1Seats = filteredSeats
        .where((e) => e.counsellingRound.toLowerCase().contains("round 1"))
        .toList();

    return round1Seats.isNotEmpty ? round1Seats : filteredSeats;
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    final seats = _preferredSeats(widget.seatMatrix);
    if (seats.isNotEmpty) selectedCourse = seats.first.courseName;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SeatGraphTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    final seats = _preferredSeats(widget.seatMatrix);
    final courses = seats.map((e) => e.courseName).toSet().toList();

    if (courses.isEmpty) {
      selectedCourse = null;
      touchedIndex = null;
      return;
    }

    if (!courses.contains(selectedCourse)) {
      selectedCourse = courses.first;
      touchedIndex = null;
    }
  }


  @override
  Widget build(BuildContext context) {
    final seats = _preferredSeats(widget.seatMatrix);
    if (seats.isEmpty) return _emptyState();

    final courses = seats.map((e) => e.courseName).toSet().toList();
    final currentCourse = courses.contains(selectedCourse)
        ? selectedCourse!
        : courses.first;
    selectedCourse = currentCourse;
    final seat = seats.firstWhere((e) => e.courseName == currentCourse);
    final cats = seat.categories;
    final showAIQ = widget.instituteType.name.toLowerCase().contains(
      "government",
    );

    return Container(
      // color: _t.bg,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          // padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Round chip (centered)
              // Center(child: _roundChip()),
              // const SizedBox(height: 20),

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
                    _categoryBarChart(seat, cats),
                    // Legend chips might be less necessary since BarChart has x-axis labels, but we can keep it or remove it
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
            "No Seat Matrix Data",
            style: TextStyle(
              color: _t.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Seat data is not available for ${widget.collegeName}.",
            style: TextStyle(color: _t.textMuted, fontSize: 13),
            textAlign: TextAlign.center,
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
          decoration: BoxDecoration(
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

  String _getDisplayCourseName(String rawCourseName) {
    try {
      final profileController = Get.find<ProfileController>();
      if (!profileController.isUGUser) {
        if (Get.isRegistered<CollegeDetailController>()) {
          final ctrl = Get.find<CollegeDetailController>();
          final pgList = ctrl.college.value?.courses.pg ?? [];
          final match = pgList.firstWhereOrNull((p) => p.courseName == rawCourseName);
          if (match != null && match.specialtyType != null && match.specialtyType!.isNotEmpty) {
            return "$rawCourseName - ${match.specialtyType}";
          }
        }
      }
    } catch (_) {}
    return rawCourseName;
  }

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
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      items: courses
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                _getDisplayCourseName(c),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _t.textPrimary,
                                  fontSize: 18,
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
          label: "Total Seats Categories",
          value: "${seat.totalCategorySeats}",
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

  Widget _categoryBarChart(SeatMatrixModel seat, List<dynamic> cats) {
    if (cats.isEmpty) return const SizedBox();
    
    final maxSeat = cats
        .map((c) => c.seats as int)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final maxY = maxSeat * 1.2;

    return SizedBox(
      height: 220,
      child: BarChart(
        swapAnimationDuration: const Duration(milliseconds: 800),
        swapAnimationCurve: Curves.easeOutCubic,
        BarChartData(
          maxY: maxY,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) =>
                  Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF252836)
                  : Colors.white,
              tooltipRoundedRadius: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final name = cats[groupIndex].category as String;
                return BarTooltipItem(
                  "$name\n",
                  TextStyle(
                    color: _t.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: "${rod.toY.toInt()} seats",
                      style: TextStyle(
                        color: _t.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                );
              },
            ),
            touchCallback: (event, resp) {
              setState(() {
                if (resp?.spot != null && event.isInterestedForInteractions) {
                  touchedIndex = resp!.spot!.touchedBarGroupIndex;
                } else {
                  touchedIndex = null;
                }
              });
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < 0 || value.toInt() >= cats.length) {
                    return const SizedBox();
                  }
                  final isTouched = touchedIndex == value.toInt();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      cats[value.toInt()].category as String,
                      style: TextStyle(
                        color: isTouched ? _purple : _t.textMuted,
                        fontWeight: isTouched ? FontWeight.bold : FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY / 4) == 0 ? 1 : maxY / 4,
            getDrawingHorizontalLine: (value) => FlLine(
              color: _t.gridLine,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(
            cats.length,
            (i) {
              final isTouched = touchedIndex == i;
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: cats[i].seats.toDouble(),
                    color: isTouched ? _blue : _purple.withOpacity(0.8),
                    width: 22,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxY,
                      color: _t.statCard1,
                    ),
                  ),
                ],
              );
            },
          ),
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
                child: Icon(
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

          // Doughnut Chart
          _aiqPieChart(seat),
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

  Widget _aiqPieChart(SeatMatrixModel seat) {
    final total = seat.aiqSeats + seat.stateQuotaSeats;
    final aiqPct = total == 0 ? 0.0 : (seat.aiqSeats / total * 100);
    final statePct = total == 0 ? 0.0 : (seat.stateQuotaSeats / total * 100);

    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            swapAnimationDuration: const Duration(milliseconds: 800),
            swapAnimationCurve: Curves.easeOutCubic,
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 60,
              startDegreeOffset: -90,
              sections: [
                if (seat.aiqSeats > 0)
                  PieChartSectionData(
                    color: _blue,
                    value: seat.aiqSeats.toDouble(),
                    title: '${aiqPct.toStringAsFixed(1)}%',
                    radius: 35,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                if (seat.stateQuotaSeats > 0)
                  PieChartSectionData(
                    color: _purple,
                    value: seat.stateQuotaSeats.toDouble(),
                    title: '${statePct.toStringAsFixed(1)}%',
                    radius: 35,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Total",
                style: TextStyle(color: _t.textMuted, fontSize: 11, fontWeight: FontWeight.w500),
              ),
              Text(
                _fmt(total),
                style: TextStyle(
                  color: _t.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
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
