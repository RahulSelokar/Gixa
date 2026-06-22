import 'package:Gixa/Modules/cutoff/controller/cotoff_controller.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class AirComparisonGraphPage extends StatefulWidget {
  const AirComparisonGraphPage({super.key});

  @override
  State<AirComparisonGraphPage> createState() => _AirComparisonGraphPageState();
}

class _AirComparisonGraphPageState extends State<AirComparisonGraphPage> {
  final controller = Get.put(AirComparisonController());

  @override
  void initState() {
    super.initState();
    controller.fetchComparison(); // No hardcoding now
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF07111D) : const Color(0xFFF4F6FA);
    final surface = isDark ? const Color(0xFF0E1A2B) : Colors.white;
    final surfaceAlt = isDark
        ? const Color(0xFF122238)
        : const Color(0xFFF8FAFD);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? Colors.white60 : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: bg,
        foregroundColor: textPrimary,
        centerTitle: true,
        title: Text(
          // 'cutoff_analysis'.tr,
          'Cutoff Analysis',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? const Color(0xFF22C55E) : kHomeAccentColor,
              ),
            ),
          );
        }

        if (controller.comparison.value == null) {
          return Center(
            child: Text(
              'No data available'.tr,
              style: TextStyle(color: textSecondary),
            ),
          );
        }

        final data = controller.comparison.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.withOpacity(.2), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.blue,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Note: This cutoff analysis is personalized based on your rank, category, and state, compared with historical trends from previous years.",
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.blue.shade200 : Colors.blue.shade700,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _heroCard(
                isDark,
                data.user.air,
                data.insight.message,
                surface,
                surfaceAlt,
                textPrimary,
                textSecondary,
              ),

              const SizedBox(height: 12),

              /// FILTER CARD
              // _filterCard(isDark, surface, textPrimary, textSecondary),

              const SizedBox(height: 16),

              /// GRAPH CARD
              _graphCard(
                isDark,
                surface,
                surfaceAlt,
                textPrimary,
                textSecondary,
              ),

              const SizedBox(height: 16),

              /// CHANCE CARD
              _chanceCard(isDark, surface, textPrimary),

              const SizedBox(height: 16),

              /// INSIGHT CARD
              _insightCard(
                isDark,
                surface,
                textPrimary,
                textSecondary,
                data.insight.message,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _heroCard(
    bool isDark,
    int air,
    String message,
    Color surface,
    Color surfaceAlt,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF122238), const Color(0xFF0B1626)]
              : [const Color(0xFF0F172A), const Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.28 : 0.12),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.show_chart_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'admission_chance'.tr,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.72),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Text(
                    //   'Share-market style cutoff analysis',
                    //   style: TextStyle(
                    //     color: Colors.white.withOpacity(0.88),
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _statTile(
                  label: 'Your AIR',
                  value: air.toString(),
                  isDark: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statTile(
                  label: 'Trend',
                  value: message.isEmpty ? 'Live' : message,
                  isDark: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _simpleLegendDot(const Color(0xFF22C55E)),
                const SizedBox(width: 6),
                Text(
                  'Year-wise cutoff',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 12),
                _simpleLegendDot(const Color(0xFFEF4444)),
                const SizedBox(width: 6),
                Text(
                  'Your AIR',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// FILTER CARD
  Widget _filterCard(
    bool isDark,
    Color surface,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.22 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune_rounded, size: 18, color: textSecondary),
              const SizedBox(width: 8),
              Text(
                'filters'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _infoRow(
            'State',
            controller.selectedState.value,
            textSecondary,
            textPrimary,
          ),
          const SizedBox(height: 8),
          _infoRow(
            'Category',
            controller.selectedCategory.value,
            textSecondary,
            textPrimary,
          ),
          const SizedBox(height: 8),
          _infoRow(
            'Course',
            controller.selectedCourse.value,
            textSecondary,
            textPrimary,
          ),

          const SizedBox(height: 14),

          Obx(() {
            return DropdownButtonFormField<String>(
              value: controller.selectedQuota.value,
              decoration: InputDecoration(
                labelText: 'quota'.tr,
                filled: true,
                fillColor: isDark
                    ? const Color(0xFF132238)
                    : const Color(0xFFF8FAFD),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: [
                'State'.tr,
                'All India'.tr,
                'IQ'.tr,
                'NRI'.tr,
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {
                controller.updateFilters(quota: value);
              },
            );
          }),
        ],
      ),
    );
  }

  /// GRAPH CARD
  Widget _graphCard(
    bool isDark,
    Color surface,
    Color surfaceAlt,
    Color textPrimary,
    Color textSecondary,
  ) {
    final graph = controller.comparison.value!.graph;
    final years = graph.years;
    final cutoffs = graph.closingLine.map((value) => value.toDouble()).toList();
    final userAirLine = graph.userAirLine
        .map((value) => value.toDouble())
        .toList();

    if (years.isEmpty || cutoffs.isEmpty || userAirLine.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Text(
          'no_data_available'.tr,
          style: TextStyle(color: textSecondary),
        ),
      );
    }

    final pointCount = [
      years.length,
      cutoffs.length,
      userAirLine.length,
    ].reduce((a, b) => a < b ? a : b);
    final alignedYears = years.take(pointCount).toList();
    final alignedCutoffs = cutoffs.take(pointCount).toList();
    final alignedUserAirLine = userAirLine.take(pointCount).toList();
    final userAir = controller.userAir.value > 0
        ? controller.userAir.value.toDouble()
        : alignedUserAirLine.last;
    final chartAir = alignedUserAirLine.last;

    final allValues = [...alignedCutoffs, ...alignedUserAirLine, userAir];
    final minVal = allValues.reduce((a, b) => a < b ? a : b);
    final maxVal = allValues.reduce((a, b) => a > b ? a : b);
    final padding = ((maxVal - minVal) * 0.18).clamp(300.0, 2000.0).toDouble();
    final yMin = (minVal - padding).clamp(0.0, double.infinity).toDouble();
    final yMax = maxVal + padding;

    double gridInterval() {
      final range = yMax - yMin;
      if (range <= 2500) return 500;
      if (range <= 6000) return 1000;
      if (range <= 12000) return 2000;
      return 5000;
    }

    bool shouldShowYLabel(double value) {
      if ((value - yMin).abs() < 0.001 || (yMax - value).abs() < 0.001) {
        return true;
      }

      final step = gridInterval();
      final normalized = ((value - yMin) / step).round();
      final expectedValue = yMin + (normalized * step);

      if ((expectedValue - value).abs() > step * 0.05) {
        return false;
      }

      return normalized % 2 == 0;
    }

    final lastCutoff = alignedCutoffs.last;
    final gap = chartAir - lastCutoff;
    final gapColor = gap > 0
        ? const Color(0xFFDC2626)
        : const Color(0xFF16A34A);

    // ── colors ────────────────────────────────────────────────────────────────
    const cutoffColor = Color(0xFF16A34A);
    const airColor = Color(0xFFDC2626);

    final graphBg = isDark ? const Color(0xFF0C1726) : const Color(0xFFF8FAFC);
    final graphTint = isDark
        ? const Color(0xFF122238)
        : const Color(0xFFEFF4FB);

    final gridLineColor = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.05);

    final borderLineColor = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.06);

    final tooltipBg = isDark ? const Color(0xFF1E2A3A) : Colors.white;

    List<FlSpot> buildSpots(List<double> values) {
      return List.generate(pointCount, (i) => FlSpot(i.toDouble(), values[i]));
    }

    final cutoffSpots = buildSpots(alignedCutoffs);
    final airSpots = buildSpots(alignedUserAirLine);

    String formatYearLabel(int index) {
      if (pointCount <= 4) {
        return alignedYears[index].toString();
      }

      final isFirstOrLast = index == 0 || index == pointCount - 1;
      final isMiddle = index == (pointCount ~/ 2);
      return (isFirstOrLast || isMiddle) ? alignedYears[index].toString() : '';
    }

    List<BarChartGroupData> buildGroups() {
      return List.generate(pointCount, (i) {
        return BarChartGroupData(
          x: i,
          groupVertically: false,
          barsSpace: 6,
          barRods: [
            BarChartRodData(
              toY: alignedCutoffs[i],
              fromY: yMin,
              color: cutoffColor.withOpacity(isDark ? 0.9 : 0.88),
              width: 12,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: yMax,
                fromY: yMin,
                color: isDark
                    ? Colors.white.withOpacity(0.025)
                    : Colors.black.withOpacity(0.025),
              ),
            ),
            BarChartRodData(
              toY: alignedUserAirLine[i],
              fromY: yMin,
              color: airColor.withOpacity(isDark ? 0.86 : 0.82),
              width: 12,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
          ],
        );
      });
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.24 : 0.06),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart_rounded, size: 18, color: textSecondary),
              const SizedBox(width: 8),
              Text(
                'Cutoff Trend',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: graphTint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${alignedYears.first} - ${alignedYears.last}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _legendDot(cutoffColor, 'Cutoff', textSecondary),
              const SizedBox(width: 14),
              _legendDot(airColor, 'Your AIR', textSecondary),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            height: 300,
            padding: const EdgeInsets.fromLTRB(6, 14, 10, 8),
            decoration: BoxDecoration(
              color: graphBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: BarChart(
              BarChartData(
                minY: yMin,
                maxY: yMax,
                alignment: BarChartAlignment.spaceAround,
                groupsSpace: 18,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 12,
                    tooltipPadding: const EdgeInsets.all(10),
                    getTooltipColor: (_) => tooltipBg,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final index = group.x;
                      final isCutoff = rodIndex == 0;
                      final label = isCutoff ? 'Cutoff' : 'Your AIR';
                      final color = isCutoff ? cutoffColor : airColor;
                      return BarTooltipItem(
                        '$label\n',
                        TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '${_formatRank(rod.toY)}  (${alignedYears[index]})',
                            style: TextStyle(
                              color: textSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: gridInterval(),
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: gridLineColor, strokeWidth: 1),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: borderLineColor),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      interval: gridInterval(),
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: shouldShowYLabel(value)
                            ? Text(
                                _formatRank(value),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= alignedYears.length) {
                          return const SizedBox.shrink();
                        }

                        final label = formatYearLabel(idx);
                        if (label.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: buildGroups(),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ── stat chips ─────────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _statChip(
                  label: 'Your AIR',
                  value: _formatRank(userAir),
                  valueColor: textPrimary,
                  isDark: isDark,
                  surface: surfaceAlt,
                  textSecondary: textSecondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statChip(
                  label: 'Latest cutoff',
                  value: _formatRank(lastCutoff),
                  valueColor: cutoffColor,
                  isDark: isDark,
                  surface: surfaceAlt,
                  textSecondary: textSecondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statChip(
                  label: 'Gap',
                  value: (gap > 0 ? '+' : '') + _formatRank(gap),
                  valueColor: gapColor,
                  isDark: isDark,
                  surface: surfaceAlt,
                  textSecondary: textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // helpers
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _legendDot(Color color, String label, Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 12, color: textColor)),
      ],
    );
  }

  Widget _statChip({
    required String label,
    required String value,
    required Color valueColor,
    required bool isDark,
    required Color surface,
    required Color textSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: textSecondary)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Formats a rank number: 8200 → "8,200"  |  -700 → "-700"
  String _formatRank(double value) {
    final abs = value.abs().toInt();
    final formatted = abs.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return value < 0 ? '-$formatted' : formatted;
  }

  /// CHANCE CARD
  Widget _chanceCard(bool isDark, Color surface, Color textPrimary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(controller.chanceColor.value).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.insights_rounded,
              color: Color(controller.chanceColor.value),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'admission_chance'.tr,
                  style: TextStyle(fontSize: 13, color: textPrimary),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    controller.chanceText.value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(controller.chanceColor.value),
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

  /// INSIGHT CARD
  Widget _insightCard(
    bool isDark,
    Color surface,
    Color textPrimary,
    Color textSecondary,
    String message,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'insight'.tr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 13, height: 1.45, color: textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _simpleLegendDot(Color color) => Container(
    width: 8,
    height: 8,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );

  Widget _graphLegend(bool isDark) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: isDark
          ? Colors.white.withOpacity(0.06)
          : Colors.black.withOpacity(0.04),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _simpleLegendDot(const Color(0xFF22C55E)),
        const SizedBox(width: 6),
        const Text('Cutoff', style: TextStyle(fontSize: 11)),
        const SizedBox(width: 10),
        _simpleLegendDot(const Color(0xFFEF4444)),
        const SizedBox(width: 6),
        const Text('AIR', style: TextStyle(fontSize: 11)),
      ],
    ),
  );

  Widget _statTile({
    required String label,
    required String value,
    required bool isDark,
  }) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(isDark ? 0.08 : 0.12),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.72), fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );

  Widget _infoRow(
    String label,
    String value,
    Color labelColor,
    Color valueColor,
  ) => Row(
    children: [
      SizedBox(
        width: 78,
        child: Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Expanded(
        child: Text(
          value.isEmpty ? '—' : value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: valueColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );

  double _gridInterval() {
    final values = [...controller.closingSpots, ...controller.userSpots];
    if (values.isEmpty) return 50000;
    final maxY = values.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return (maxY / 4).clamp(1, double.infinity);
  }

  double _minY() {
    final values = [...controller.closingSpots, ...controller.userSpots];
    if (values.isEmpty) return 0;
    final minY = values.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    return (minY * 0.9).clamp(0, double.infinity);
  }

  double _maxY() {
    final values = [...controller.closingSpots, ...controller.userSpots];
    if (values.isEmpty) return 100000;
    final maxY = values.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return maxY * 1.1;
  }
}
