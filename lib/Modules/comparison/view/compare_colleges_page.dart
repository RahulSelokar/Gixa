import 'dart:ui';
import 'package:Gixa/Modules/Collage/veiw/collage_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:Gixa/Modules/comparison/controller/college_compare_controller.dart';
import 'package:Gixa/Modules/comparison/model/college_compare_model.dart';
import 'package:Gixa/routes/app_routes.dart';

class CompareCollegesView extends StatefulWidget {
  const CompareCollegesView({super.key});

  @override
  State<CompareCollegesView> createState() => _CompareCollegesViewState();
}

class _CompareCollegesViewState extends State<CompareCollegesView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();

  // Modern Color Palette
  final Color primaryBlue = const Color(0xFF2563EB);
  final Color darkBg = const Color(0xFF0F172A);
  final Color lightBg = const Color(0xFFF8FAFC);
  final Color accentPurple = const Color(0xFF7C3AED);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CollegeCompareController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? darkBg : lightBg;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Compare & Decide",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // flexibleSpace: ClipRRect(
        //   child: BackdropFilter(
        //     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        //     child: Container(color: bgColor.withOpacity(0.5)),
        //   ),
        // ),
        leading: BackButton(color: textColor),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            // decoration: BoxDecoration(
            //   color: primaryBlue.withOpacity(0.1),
            //   shape: BoxShape.circle,
            // ),
            child: IconButton(
              icon: Icon(Icons.bookmark_border_rounded, color: primaryBlue),
              onPressed: () => Get.toNamed(AppRoutes.savedComparision),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          /// 1. Background Decor
          // _buildAnimatedBackground(isDark),

          /// 2. Main Content
          Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingState(isDark);
            }

            final result = controller.compareResult.value;
            if (result == null || result.comparison.length < 2) {
              return _EmptyState(isDark: isDark, primaryBlue: primaryBlue);
            }

            final colleges = result.comparison;

            return FadeTransition(
              opacity: _fadeAnimation,
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 110, 20, 100),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildHeaderRow(colleges, isDark),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Quick Stats", isDark),
                  _buildComparisonCard(
                    isDark,
                    children: [
                      // Inside your build method or ListView children:
                      _buildSectionCard(
                        isDark,
                        children: [
                          _buildComparisonRow(
                            label: "Location",
                            values: colleges.map((e) => e.city).toList(),
                            icon: Icons.location_on_rounded,
                            color: const Color(0xFF3B82F6), // Blue
                            isDark: isDark,
                          ),
                          _buildDivider(isDark),
                          _buildComparisonRow(
                            label: "Hostel Facility",
                            values: colleges
                                .map((e) => e.hostelAvailable ? "Yes" : "No")
                                .toList(),
                            icon: Icons.bedroom_child_rounded,
                            color: const Color(0xFFF59E0B), // Orange
                            isDark: isDark,
                          ),
                          _buildDivider(isDark),
                          _buildComparisonRow(
                            label: "College Code",
                            values: colleges.map((e) => e.collegeCode).toList(),
                            icon: Icons.qr_code_rounded,
                            color: const Color(0xFF8B5CF6), // Purple
                            isDark: isDark,
                          ),
                          _buildDivider(isDark),
                          _buildComparisonRow(
                            label: "Established",
                            // Assuming you have this data, otherwise replace with another field
                            values: colleges.map((e) => "1995").toList(),
                            icon: Icons.history_edu_rounded,
                            color: const Color(0xFF10B981), // Green
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Admission Analysis", isDark),
                  _buildChartSection(colleges, isDark),
                  const SizedBox(height: 24),
                  _buildAiInsightCard(colleges, isDark),
                ],
              ),
            );
          }),

          /// 3. Floating Save Button
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Obx(() {
              if (!controller.isLoading.value &&
                  controller.compareResult.value != null &&
                  controller.compareResult.value!.comparison.length >= 2) {
                return _buildFloatingButton(controller);
              }
              return const SizedBox();
            }),
          ),
        ],
      ),
    );
  }

  // 1. The Container Card
  Widget _buildSectionCard(bool isDark, {required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
      ), // Tiny margin for shadow
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: const Color(0xFF64748B).withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // 2. The Modern Comparison Row
  Widget _buildComparisonRow({
    required String label,
    required List<String> values,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        children: [
          // Row Header: Icon + Label
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 10),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: isDark ? Colors.white54 : const Color(0xFF64748B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Row Values
          Row(
            children: values.map((value) {
              // Smart Styling for Boolean values
              Color? valueColor;
              FontWeight fontWeight = FontWeight.w600;

              if (value == "Yes") {
                valueColor = const Color(0xFF10B981); // Success Green
                fontWeight = FontWeight.bold;
              } else if (value == "No") {
                valueColor = const Color(0xFFEF4444); // Error Red
                fontWeight = FontWeight.bold;
              } else {
                valueColor = isDark ? Colors.white : const Color(0xFF1E293B);
              }

              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: fontWeight,
                      color: valueColor,
                      height: 1.3,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 3. The Subtle Divider
  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
      indent: 20,
      endIndent: 20,
    );
  }

  // ==========================================================
  // 🎨 BACKGROUND & DECOR
  // ==========================================================
  Widget _buildAnimatedBackground(bool isDark) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Base Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                    : [const Color(0xFFF8FAFC), const Color(0xFFEFF6FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Orbs
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryBlue.withOpacity(isDark ? 0.15 : 0.08),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(isDark ? 0.15 : 0.08),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentPurple.withOpacity(isDark ? 0.15 : 0.08),
                boxShadow: [
                  BoxShadow(
                    color: accentPurple.withOpacity(isDark ? 0.15 : 0.08),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          // Glass Overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.transparent),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // 🏛 HEADER (COLLEGE VS COLLEGE)
  // ==========================================================
  Widget _buildHeaderRow(List<CollegeComparison> colleges, bool isDark) {
    final bool isComparisonPair = colleges.length == 2;

    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. The Cards Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: colleges.map((college) {
            // Extract initials (e.g., "IIT Bombay" -> "IB")
            String initials = college.collegeName
                .split(' ')
                .take(2)
                .map((e) => e.isNotEmpty ? e[0] : '')
                .join();

            return Expanded(
              child: Container(
                width: 280,
                height: 280,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                // Use constrained box to ensure minimum height but allow growth
                constraints: const BoxConstraints(minHeight: 220),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                    width: 1,
                  ),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: const Color(0xFF64748B).withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Color Accent Strip
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                      child: Column(
                        children: [
                          // Avatar with Initials
                          Container(
                            width: 56,
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : const Color(0xFFEFF6FF),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryBlue.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              initials.toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: primaryBlue,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // College Name
                          Text(
                            college.collegeName,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              height: 1.3,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1E293B),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Admission Badge
                          // _buildAdmissionBadge(college.admissionChances),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        // 2. The "VS" Badge (Only shows if comparing exactly 2 colleges)
        if (isComparisonPair)
          Positioned(
            top: 70, // Align with the avatars
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade400, Colors.red.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Text(
                "VS",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAdmissionBadge(String chance) {
    Color color;
    IconData icon;

    switch (chance.toLowerCase()) {
      case "high":
        color = const Color(0xFF10B981);
        icon = Icons.check_circle_rounded;
        break;
      case "moderate":
        color = const Color(0xFFF59E0B);
        icon = Icons.remove_circle_rounded;
        break;
      default:
        color = const Color(0xFFEF4444);
        icon = Icons.cancel_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            chance,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // 📋 COMPARISON TABLE
  // ==========================================================
  Widget _buildComparisonCard(bool isDark, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // Widget _buildComparisonRow(
  //   String label,
  //   List<String> values,
  //   IconData icon,
  //   bool isDark,
  // ) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(
  //               icon,
  //               size: 14,
  //               color: isDark ? Colors.white54 : Colors.grey,
  //             ),
  //             const SizedBox(width: 6),
  //             Text(
  //               label.toUpperCase(),
  //               style: TextStyle(
  //                 fontSize: 10,
  //                 fontWeight: FontWeight.bold,
  //                 letterSpacing: 1.0,
  //                 color: isDark ? Colors.white54 : Colors.grey,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 12),
  //         Row(
  //           children: values
  //               .map(
  //                 (v) => Expanded(
  //                   child: Text(
  //                     v,
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 14,
  //                       color: isDark ? Colors.white : const Color(0xFF1E293B),
  //                     ),
  //                   ),
  //                 ),
  //               )
  //               .toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildDivider(bool isDark) {
  //   return Divider(
  //     height: 1,
  //     color: isDark ? Colors.white10 : Colors.grey.shade100,
  //   );
  // }

  // ==========================================================
  // 📊 CHARTS
  // ==========================================================
  Widget _buildChartSection(List<CollegeComparison> colleges, bool isDark) {
    // Helper to determine bar height and color based on admission chance
    double getHeight(String chance) {
      switch (chance.toLowerCase()) {
        case 'high':
          return 4.5;
        case 'moderate':
          return 3.0;
        case 'low':
          return 1.5;
        default:
          return 2.0;
      }
    }

    Color getColor(String chance) {
      switch (chance.toLowerCase()) {
        case 'high':
          return const Color(0xFF10B981); // Emerald
        case 'moderate':
          return const Color(0xFFF59E0B); // Amber
        case 'low':
          return const Color(0xFFEF4444); // Red
        default:
          return Colors.grey;
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: const Color(0xFF64748B).withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header & Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Admission Probability",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "AI-based prediction score",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          // 2. The Chart
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 5,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= colleges.length)
                          return const SizedBox();

                        // Get Initials (e.g. "IIT Bombay" -> "IB")
                        final name = colleges[value.toInt()].collegeName;
                        final initials = name
                            .split(' ')
                            .take(2)
                            .map((e) => e.isNotEmpty ? e[0] : '')
                            .join();

                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            initials.toUpperCase(),
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF64748B),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) =>
                        isDark ? const Color(0xFF0F172A) : Colors.white,
                    tooltipRoundedRadius: 12,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    tooltipMargin: 16,
                    // Add shadow to tooltip
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        colleges[group.x.toInt()].collegeName,
                        TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1E293B),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '\n${colleges[group.x.toInt()].admissionChances} Chance',
                            style: TextStyle(
                              color: getColor(
                                colleges[group.x.toInt()].admissionChances,
                              ),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                barGroups: colleges.asMap().entries.map((entry) {
                  final index = entry.key;
                  final college = entry.value;
                  final height = getHeight(college.admissionChances);
                  final color = getColor(college.admissionChances);

                  return BarChartGroupData(
                    x: index,
                    showingTooltipIndicators: [],
                    barRods: [
                      BarChartRodData(
                        toY: height,
                        color: color,
                        width: 32, // Thicker bars
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 5, // Full height background
                          color: isDark
                              ? Colors.white.withOpacity(0.03)
                              : const Color(0xFFF1F5F9),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // 🤖 AI INSIGHT
  // ==========================================================
  Widget _buildAiInsightCard(List<CollegeComparison> colleges, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.3),
            blurRadius: 20,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.amberAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "AI Recommendation",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Based on your profile, ${colleges.first.collegeName} offers the highest admission probability with better infrastructure facilities.",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // 🔘 FLOATING BUTTON
  // ==========================================================
  Widget _buildFloatingButton(CollegeCompareController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: primaryBlue.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: controller.saveComparedColleges,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_add_rounded, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    "Save Comparison",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: CircularProgressIndicator(color: primaryBlue, strokeWidth: 3),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : const Color(0xFF1E293B),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final Color primaryBlue;

  const _EmptyState({required this.isDark, required this.primaryBlue});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                ],
              ),
              child: Icon(
                Icons.compare_arrows_rounded,
                size: 64,
                color: primaryBlue.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Start Comparing",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Select at least two colleges to see a detailed AI-powered comparison.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white54 : const Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 50,
              child: OutlinedButton(
                onPressed: () => Get.toNamed("/college"),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  foregroundColor: primaryBlue,
                ),
                child: const Text(
                  "Select Colleges",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
