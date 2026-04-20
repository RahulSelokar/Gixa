import 'package:Gixa/Modules/predication/controller/prediction_controller.dart';
import 'package:Gixa/Modules/rankAnalysis/view/rank_analysis_view.dart';
import 'package:Gixa/Modules/subscription/features/feature_names.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/predication_model.dart';

class AiPredictionResultView extends StatelessWidget {
  final PredictionData predictionData;

  AiPredictionResultView({super.key, required this.predictionData});

  final RxString selectedFilter = "All".obs;
  final PredictionController controller = Get.find();
  final RxList<CollegeModel> selectedColleges = <CollegeModel>[].obs;

  static const Color _indigo = Color(0xFF6366F1);
  static const Color _indigoDark = Color(0xFF4F46E5);
  static const Color _surface = Color(0xFF1E293B);
  static const Color _bgDark = Color(0xFF0A0F1E);
  static const Color _bgLight = Color(0xFFF0F2F8);
  static const Color _cardLight = Color(0xFFFFFFFF);
  static const Color _accent = Color(0xFF818CF8);

  // ─── Filter Tabs ─────────────────────────────────────────────────
  Widget _buildFilterTabs() {
    final govtCount = predictionData.collegeList
        .where((c) => c.instituteType.toLowerCase().contains("government"))
        .length;
    final pvtCount = predictionData.collegeList
        .where((c) => c.instituteType.toLowerCase().contains("private"))
        .length;
    final allCount = predictionData.collegeList.length;

    final filterLabels = [
      {"label": "All", "count": allCount},
      {"label": "Government", "count": govtCount},
      {"label": "Private", "count": pvtCount},
    ];

    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: filterLabels.map((item) {
              final type = item["label"] as String;
              final count = item["count"] as int;
              final selected = selectedFilter.value == type;

              return Expanded(
                child: GestureDetector(
                  onTap: () => selectedFilter.value = type,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? _indigo : Colors.transparent,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            type,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        // ── Badge pill ──
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.white.withOpacity(0.22)
                                : Colors.black.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            count.toString(),
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ─── Main Build ───────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final govtColleges = predictionData.collegeList
        .where((c) => c.instituteType.toLowerCase().contains("government"))
        .toList();
    final privateColleges = predictionData.collegeList
        .where((c) => c.instituteType.toLowerCase().contains("private"))
        .toList();

    return Scaffold(
      backgroundColor: isDark ? _bgDark : _bgLight,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(isDark),
      body: Column(
        children: [
          _buildHeroSection(isDark),
          _buildIQMessageBanner(isDark),

          const SizedBox(height: 10),
          if (controller.selectedInstituteType.value == "Both")
            _buildFilterTabs(),
          const SizedBox(height: 6),
          Expanded(
            child: _buildResultSection(isDark, govtColleges, privateColleges),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildCompareButton(),
    );
  }

  // ─── App Bar ──────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: isDark ? Colors.white : Colors.black87,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: _indigo,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            "Gixa AI Predictions",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  // ─── Hero Section ─────────────────────────────────────────────────
  Widget _buildHeroSection(bool isDark) {
    final horizontalText = controller.selectedHorizontals.isEmpty
        ? "None"
        : controller.selectedHorizontals.join(", ");

    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF111827) : const Color(0xFFF8F8F8),
      padding: const EdgeInsets.fromLTRB(16, 90, 16, 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C2333) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.07)
                : Colors.black.withOpacity(0.07),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rank + Match count row
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "YOUR RANK",
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "#${controller.userAir.value}",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: _indigo,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "AIR",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                // Match count badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 20,
                  ),
                  // decoration: BoxDecoration(
                  //   color: isDark
                  //       ? Colors.white.withOpacity(0.06)
                  //       : Colors.black.withOpacity(0.04),
                  //   borderRadius: BorderRadius.circular(20),
                  //   border: Border.all(
                  //     color: isDark
                  //         ? Colors.white.withOpacity(0.1)
                  //         : Colors.black.withOpacity(0.1),
                  //     width: 0.5,
                  //   ),
                  // ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: _indigo,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${predictionData.totalCount} Matches",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white60 : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Tags
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                "AIR ${controller.userAir.value}",
                controller.selectedCourse.value,
                controller.selectedCategory.value,
                controller.selectedState.value,
                "Horizontal: $horizontalText",
              ].map((tag) => _miniTag(tag, isDark)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIQMessageBanner(bool isDark) {
    if (predictionData.message == null || predictionData.message!.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.withOpacity(.2), width: 1),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              predictionData.message!,
              style: TextStyle(
                fontSize: 11,
                color: Colors.orange.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniTag(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      // decoration: BoxDecoration(
      //   color: isDark
      //       ? Colors.white.withOpacity(0.06)
      //       : Colors.black.withOpacity(0.05),
      //   borderRadius: BorderRadius.circular(20),
      //   border: Border.all(
      //     color: isDark
      //         ? Colors.white.withOpacity(0.1)
      //         : Colors.black.withOpacity(0.08),
      //     width: 0.5,
      //   ),
      // ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white60 : Colors.black54,
        ),
      ),
    );
  }

  // ─── Result Section ───────────────────────────────────────────────
  Widget _buildResultSection(
    bool isDark,
    List<CollegeModel> govtColleges,
    List<CollegeModel> privateColleges,
  ) {
    return Obx(() {
      final isPremium = controller.canAccessPrediction;

      List<CollegeModel> displayList = [];

      if (controller.selectedInstituteType.value == "Both") {
        if (selectedFilter.value == "Government") {
          displayList = govtColleges;
        } else if (selectedFilter.value == "Private") {
          displayList = privateColleges;
        } else {
          displayList = [...govtColleges, ...privateColleges];
        }
      } else {
        displayList = govtColleges.isNotEmpty ? govtColleges : privateColleges;
      }

      if (displayList.isEmpty) {
        return _buildSuggestionUI(isDark);
      }

      /// 🔒 FREE USER → LOCKED UI
      if (!isPremium) {
        return _buildLockedList(isDark, displayList);
      }

      /// 🔓 PREMIUM USER → NORMAL LIST
      return _buildList(context: null, list: displayList, isDark: isDark);
    });
  }

  Widget _buildList({
    required BuildContext? context,
    required List<CollegeModel> list,
    required bool isDark,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 100),
      itemCount: list.length,
      itemBuilder: (ctx, index) {
        return _collegeCard(ctx, list[index], isDark, index);
      },
    );
  }

  Widget _buildLockedList(bool isDark, List<CollegeModel> list) {
    return Column(
      children: [
        // 🔥 PREMIUM BANNER
        Container(
          margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [_indigo, _indigoDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _indigo.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // 🔒 Icon Bubble
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_rounded, color: Colors.white),
              ),

              const SizedBox(width: 12),

              // 🧠 Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${list.length} Colleges Unlocked 🎯",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Upgrade to Premium to view full details",
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),

              // 🚀 CTA BUTTON
              GestureDetector(
                onTap: controller.goToPremium,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Upgrade",
                    style: TextStyle(
                      color: _indigoDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 🔒 LOCKED LIST
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 100),
            itemCount: list.length,
            itemBuilder: (_, __) => _lockedCard(isDark),
          ),
        ),
      ],
    );
  }

  Widget _lockedCard(bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? _surface : _cardLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 🔹 REAL LAYOUT (but hidden content)
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Type + icon row
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.circle, size: 10, color: Colors.grey),
                  ],
                ),

                const SizedBox(height: 10),

                // 🔹 College name (hidden)
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),

                const SizedBox(height: 6),

                Container(
                  height: 12,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),

                const SizedBox(height: 14),

                // 🔹 Buttons layout
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔥 BLUR + LOCK OVERLAY
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withOpacity(0.55)
                      : Colors.white.withOpacity(0.6),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.05),
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      size: 24,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── No Govt Message ──────────────────────────────────────────────
  Widget _buildNoGovtMessage() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.withOpacity(.2), width: 1),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Government seats likely unavailable at your rank — showing Private colleges.",
              style: TextStyle(
                fontSize: 11,
                color: Colors.orange.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── College Card ─────────────────────────────────────────────────
  Widget _collegeCard(
    BuildContext context,
    CollegeModel college,
    bool isDark,
    int index,
  ) {
    final isGovt = college.instituteType.toLowerCase().contains("government");

    return Obx(() {
      final isSelected = selectedColleges.contains(college);

      return GestureDetector(
        onTap: () {
          if (selectedColleges.contains(college)) {
            selectedColleges.remove(college);
          } else {
            if (selectedColleges.length < 2) {
              selectedColleges.add(college);
            } else {
              Get.snackbar(
                "Limit Reached",
                "Select up to 2 colleges to compare",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: _surface,
                colorText: Colors.white,
                margin: const EdgeInsets.all(12),
                borderRadius: 12,
                duration: const Duration(seconds: 2),
              );
            }
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? _indigo.withOpacity(0.07)
                : (isDark ? _surface : _cardLight),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? _indigo.withOpacity(0.6)
                  : (isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.06)),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: _indigo.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row: type badge + selection icon
                Row(
                  children: [
                    _typeTag(isGovt),
                    const Spacer(),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        key: ValueKey(isSelected),
                        color: isSelected ? _indigo : Colors.grey.shade400,
                        size: 18,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ── College name
                Text(
                  college.collegeName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                    height: 1.35,
                  ),
                ),

                const SizedBox(height: 5),

                // ── Course
                Text(
                  college.courseName,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white54 : Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 12),

                // ── Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _outlineBtn(
                        label: "Rank Analysis",
                        icon: Icons.bar_chart_rounded,
                        isDark: isDark,
                        onTap: () {
                          Get.to(
                            () => RankAnalysisScreen(),
                            arguments: {
                              "college_id": college.id,
                              "college_code": college.collegeCode,
                              "college_name": college.collegeName,
                              "course": controller.selectedCourse.value,
                              "category": controller.selectedCategory.value,
                              "rank": controller.userAir.value,
                              "round": controller.selectedRound.value,
                              "year": controller.selectedYear.value,
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _solidBtn(
                        label: "View Details",
                        icon: Icons.arrow_forward_rounded,
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.collageDetails,
                            arguments: {"collegeId": college.id},
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _typeTag(bool isGovt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isGovt
            ? Colors.green.withOpacity(0.1)
            : Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: isGovt ? Colors.green : Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isGovt ? "Government" : "Private",
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: isGovt ? Colors.green.shade700 : Colors.blue.shade700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _outlineBtn({
    required String label,
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.12)
                : Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 13,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _solidBtn({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_indigo, _indigoDark]),
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              color: _indigo.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4),
            Icon(icon, size: 13, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // ─── Compare FAB ──────────────────────────────────────────────────
  Widget _buildCompareButton() {
    return Obx(() {
      if (selectedColleges.length < 2) return const SizedBox();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_indigo, _indigoDark]),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: _indigo.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              final codes = selectedColleges
                  .map((e) => e.collegeCode.toString())
                  .toList();
              Get.toNamed(
                AppRoutes.compareCollage,
                arguments: {"collegeCodes": codes},
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.compare_arrows_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Compare",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "${selectedColleges.length}",
                        style: const TextStyle(
                          color: _indigoDark,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // ─── Empty / Suggestion UI ────────────────────────────────────────
  Widget _buildSuggestionUI(bool isDark) {
    final cardColor = isDark ? _surface : _cardLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white54 : Colors.black45;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.06),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _indigo.withOpacity(0.08),
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 32,
                  color: _indigo,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "No Matches Found",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Adjust your preferences to discover more colleges.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  color: subTextColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              ...[
                (Icons.school_outlined, "Try a different Course"),
                (
                  Icons.account_balance_outlined,
                  "Set Institute Type to 'Both'",
                ),
                (Icons.map_outlined, "Change your State"),
              ].map(
                (item) => _suggestionTile(
                  icon: item.$1,
                  text: item.$2,
                  isDark: isDark,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _indigo,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Edit Preferences",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _suggestionTile({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.04),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: _accent, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
