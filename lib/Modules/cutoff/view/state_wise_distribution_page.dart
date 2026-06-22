import 'package:Gixa/Modules/counselling_roadmap/widgets/shared_widgets.dart';
import 'package:Gixa/Modules/cutoff/controller/state_wise_distribution_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class StateWiseDistributionGraphPage extends StatefulWidget {
  const StateWiseDistributionGraphPage({super.key});

  @override
  State<StateWiseDistributionGraphPage> createState() => _StateWiseDistributionGraphPageState();
}

class _StateWiseDistributionGraphPageState extends State<StateWiseDistributionGraphPage> {
  final controller = Get.put(StateWiseDistributionController());
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    controller.fetchDistribution();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Use App Theme Colors
    final bg = isDark ? const Color(0xFF0E0E16) : const Color(0xFFF4F6FB);
    final surface = CounsellingUi.cardBg(context, isDark);
    final textPrimary = CounsellingUi.textPrimary(isDark);
    final textSecondary = CounsellingUi.textSecondary(isDark);
    final borderColor = CounsellingUi.border(isDark);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: isDark ? const Color(0xFF15151F) : Colors.white,
        foregroundColor: textPrimary,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: GixaColors.primaryGradient,
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(
                    color: GixaColors.pink.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.public_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 9),
            Text(
              'State Wise Cutoff',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: textPrimary,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(GixaColors.pink),
            ),
          );
        }

        if (controller.model.value?.data == null || controller.sortedChartData.isEmpty) {
          return Center(
            child: Text(
              'No data available',
              style: TextStyle(color: textSecondary),
            ),
          );
        }

        final data = controller.model.value!.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedItem(
                delay: 0,
                child: _heroCard(isDark, data),
              ),
              const SizedBox(height: 24),
              _buildAnimatedItem(
                delay: 100,
                child: _graphCard(isDark, surface, borderColor, textPrimary, textSecondary),
              ),
              const SizedBox(height: 24),
              _buildAnimatedItem(
                delay: 200,
                child: _insightCard(isDark, surface, borderColor, textPrimary, textSecondary),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAnimatedItem({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        // Only start animating after the delay
        // We use a simple math trick here instead of a complex Future/Timer
        // For a more precise stagger, we'd use flutter_staggered_animations
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
    );
  }

  Widget _heroCard(bool isDark, data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: GixaColors.heroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: CounsellingUi.cardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'State-Wise Cutoff',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Opportunities based on your AIR',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _statTile(
                    label: 'Your AIR',
                    value: '${data.studentRank}',
                    isDark: true,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
                Expanded(
                  child: _statTile(
                    label: 'States',
                    value: '${data.totalStates}',
                    isDark: true,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
                Expanded(
                  child: _statTile(
                    label: 'Colleges',
                    value: '${data.totalEligibleColleges}',
                    isDark: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile({required String label, required String value, required bool isDark}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _graphCard(
    bool isDark,
    Color surface,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    final chartData = controller.sortedChartData;
    final maxVal = chartData.isNotEmpty ? chartData.first.count.toDouble() : 100.0;
    
    final graphBg = isDark ? Colors.black.withOpacity(0.2) : const Color(0xFFF8FAFC);
    final gridLineColor = isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04);
    final tooltipBg = isDark ? const Color(0xFF1E2A3A) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: CounsellingUi.cardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: GixaColors.pinkLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.bar_chart_rounded, size: 18, color: GixaColors.pink),
              ),
              const SizedBox(width: 12),
              Text(
                'Eligible Colleges by State',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, -60 * (1 - value)), // Slide down from -60
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Container(
                height: 340, // Increased height slightly for longer names
                width: chartData.length * 60.0 > MediaQuery.of(context).size.width 
                    ? chartData.length * 60.0 
                    : MediaQuery.of(context).size.width - 72,
                padding: const EdgeInsets.only(top: 10, right: 16, bottom: 8),
                decoration: BoxDecoration(
                  color: graphBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor.withOpacity(0.5)),
                ),
                child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxVal + (maxVal * 0.2),
                  lineTouchData: LineTouchData(
                    enabled: true,
                    handleBuiltInTouches: true,
                    touchCallback: (FlTouchEvent event, lineTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            lineTouchResponse == null ||
                            lineTouchResponse.lineBarSpots == null ||
                            lineTouchResponse.lineBarSpots!.isEmpty) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = lineTouchResponse.lineBarSpots!.first.spotIndex;
                      });
                    },
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => tooltipBg,
                      tooltipRoundedRadius: 12,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final index = spot.spotIndex;
                          final stateName = chartData[index].stateName;
                          final count = chartData[index].count;
                          return LineTooltipItem(
                            '$stateName\n',
                            TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: '$count Colleges',
                                style: TextStyle(
                                  color: GixaColors.green,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 100, // Increased to fit full names
                        interval: 1, // Show title for every point
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= chartData.length || value != index.toDouble()) {
                            return const SizedBox.shrink();
                          }
                          String name = chartData[index].stateName;

                          return Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: SizedBox(
                                width: 85, // Max width for the text when rotated
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        interval: (maxVal / 5).ceilToDouble() == 0 ? 1 : (maxVal / 5).ceilToDouble(),
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Text(
                              value.toInt().toString(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: gridLineColor,
                      strokeWidth: 1,
                      dashArray: [4, 4], // Dashed grid lines for modern look
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.count.toDouble());
                      }).toList(),
                      isCurved: true,
                      curveSmoothness: 0.35,
                      preventCurveOverShooting: true,
                      gradient: const LinearGradient(
                        colors: [GixaColors.blue, GixaColors.pink],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          final isTouched = index == touchedIndex;
                          return FlDotCirclePainter(
                            radius: isTouched ? 6 : 4,
                            color: isTouched ? GixaColors.green : (isDark ? Colors.black : Colors.white),
                            strokeWidth: 2.5,
                            strokeColor: isTouched ? Colors.white : GixaColors.pink,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            GixaColors.blue.withOpacity(isDark ? 0.4 : 0.2),
                            GixaColors.pink.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 800), // Smooth entry animation
                curve: Curves.easeOutCubic,
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightCard(bool isDark, Color surface, Color borderColor, Color textPrimary, Color textSecondary) {
    final chartData = controller.sortedChartData;
    if (chartData.isEmpty) return const SizedBox.shrink();

    final top3 = chartData.take(3).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: CounsellingUi.cardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: GixaColors.orangeLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.lightbulb_outline_rounded, color: GixaColors.orange, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                'Key Insights',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Based on your rank, you have the maximum opportunities in:',
            style: TextStyle(color: textSecondary, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),
          ...top3.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.03) : const Color(0xFFF4F6FB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: GixaColors.green, size: 18),
                      const SizedBox(width: 12),
                      Text(
                        e.stateName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: GixaColors.greenLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${e.count} Colleges',
                          style: TextStyle(
                            color: GixaColors.green,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
