import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Gixa/Modules/Collage/model/collage_model.dart';
import 'package:Gixa/Modules/Search/controllers/search_controller.dart';
import 'package:Gixa/routes/app_routes.dart';

// ─────────────────────────────────────────────
//  Design Tokens
// ─────────────────────────────────────────────
class _AppColors {
  // Primary brand
  static const indigo = Color(0xFF4F46E5);
  static const indigoLight = Color(0xFF818CF8);
  static const indigoSoft = Color(0xFFEEF2FF);

  // Dark theme surfaces
  static const darkBg = Color(0xFF0A0A0F);
  static const darkSurface = Color(0xFF13131A);
  static const darkCard = Color(0xFF1C1C27);
  static const darkBorder = Color(0xFF2A2A38);

  // Light theme surfaces
  static const lightBg = Color(0xFFF5F6FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFE8EAF2);

  // Accent
  static const emerald = Color(0xFF10B981);
  static const rose = Color(0xFFF43F5E);
  static const amber = Color(0xFFF59E0B);
}

const List<String> _priorityMedicalCourses = [
  'MBBS',
  'BDS',
  'BAMS',
  'BHMS',
  'BPT',
];

List<String> _buildPriorityCourseItems(Iterable<String> rawCourses) {
  final normalizedMap = <String, String>{};
  final orderedRaw = <String>[];

  for (final course in rawCourses) {
    final cleaned = course.trim();
    if (cleaned.isEmpty) continue;
    final key = cleaned.toUpperCase();
    normalizedMap.putIfAbsent(key, () => cleaned);
    if (!orderedRaw.contains(cleaned)) {
      orderedRaw.add(cleaned);
    }
  }

  final prioritized = <String>[];
  for (final course in _priorityMedicalCourses) {
    final match = normalizedMap[course.toUpperCase()];
    if (match != null) {
      prioritized.add(match);
    }
  }

  final remaining =
      orderedRaw.where((course) => !prioritized.contains(course)).toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

  return [...prioritized, ...remaining];
}

bool _isMccState(String? value) => value?.trim().toLowerCase() == 'mcc';

List<String> _buildInstituteTypeOptions(String? stateValue) {
  return ['Government', 'Private', if (_isMccState(stateValue)) 'Deemed'];
}

class CollegeSearchPage extends StatefulWidget {
  CollegeSearchPage({super.key});

  @override
  State<CollegeSearchPage> createState() => _CollegeSearchPageState();
}

class _CollegeSearchPageState extends State<CollegeSearchPage> {
  final CollegeSearchController controller = Get.put(CollegeSearchController());
  final ScrollController _scrollController = ScrollController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 240;
    if (_scrollController.position.pixels >= threshold) {
      controller.loadNextPage();
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      controller.updateSearch(value);
    });
  }

  // ─── Helpers ───
  Color _bg(bool dark) => dark ? _AppColors.darkBg : _AppColors.lightBg;
  Color _surface(bool dark) =>
      dark ? _AppColors.darkSurface : _AppColors.lightSurface;
  Color _card(bool dark) => dark ? _AppColors.darkCard : _AppColors.lightCard;
  Color _border(bool dark) =>
      dark ? _AppColors.darkBorder : _AppColors.lightBorder;
  Color _textPrimary(bool dark) =>
      dark ? const Color(0xFFF1F1F8) : const Color(0xFF0F0F1A);
  Color _textSecondary(bool dark) =>
      dark ? const Color(0xFF8B8BA8) : const Color(0xFF6B6B8A);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _bg(isDark),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark),
              _buildActiveFilters(isDark),
              _buildResultCount(isDark),
              Expanded(child: _buildCollegeList(isDark)),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════
  //  HEADER
  // ════════════════════════════════════════════
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page title
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Discover",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0,
                        color: _AppColors.indigo,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Colleges",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        height: 1.1,
                        color: _textPrimary(isDark),
                      ),
                    ),
                  ],
                ),
              ),
              // Stats pill
              // Obx(() {
              //   final count = controller.colleges.length;
              //   return AnimatedContainer(
              //     duration: const Duration(milliseconds: 300),
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 14,
              //       vertical: 8,
              //     ),
              //     decoration: BoxDecoration(
              //       gradient: const LinearGradient(
              //         colors: [_AppColors.indigo, _AppColors.indigoLight],
              //       ),
              //       borderRadius: BorderRadius.circular(20),
              //       // boxShadow: [
              //       //   BoxShadow(
              //       //     color: _AppColors.indigo.withOpacity(0.35),
              //       //     blurRadius: 12,
              //       //     offset: const Offset(0, 4),
              //       //   ),
              //       // ],
              //     ),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         const Icon(
              //           Icons.school_rounded,
              //           size: 14,
              //           color: Colors.white,
              //         ),
              //         const SizedBox(width: 6),
              //         Text(
              //           "$count",
              //           style: const TextStyle(
              //             color: Colors.white,
              //             fontSize: 13,
              //             fontWeight: FontWeight.w700,
              //           ),
              //         ),
              //       ],
              //     ),
              //   );
              // }),
            ],
          ),

          const SizedBox(height: 20),

          // Search + Filter row
          Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildSearchField(isDark)),
                  const SizedBox(width: 10),
                  _buildFilterButton(context, isDark),
                ],
              ),
              // const SizedBox(height: 12),
              // Row(
              //   children: [
              //     Expanded(child: _buildStateDropdown(isDark)),
              //     const SizedBox(width: 10),
              //     Expanded(child: _buildCourseDropdown(isDark)),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStateDropdown(bool isDark) {
    return Obx(() {
      final states = controller.states.map((e) => e.name).toList();

      return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _surface(isDark),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border(isDark)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: states.contains(controller.selectedState.value)
                ? controller.selectedState.value
                : null,
            hint: Text(
              "State",
              style: TextStyle(color: _textSecondary(isDark), fontSize: 13),
            ),
            isExpanded: true,
            items: states.map((state) {
              return DropdownMenuItem(value: state, child: Text(state));
            }).toList(),
            onChanged: (value) {
              controller.updateSelectedState(value);
              if (!_isMccState(controller.selectedState.value)) {
                controller.removeInstituteType('Deemed');
              }
              controller.fetchColleges();
            },
          ),
        ),
      );
    });
  }

  Widget _buildCourseDropdown(bool isDark) {
    return Obx(() {
      final courses = _buildPriorityCourseItems(
        controller.availableCourseOptions,
      );

      return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _surface(isDark),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border(isDark)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: courses.contains(controller.selectedCourse.value)
                ? controller.selectedCourse.value
                : null,
            hint: Text(
              "Course",
              style: TextStyle(color: _textSecondary(isDark), fontSize: 13),
            ),
            isExpanded: true,
            items: courses.map((course) {
              return DropdownMenuItem(value: course, child: Text(course));
            }).toList(),
            onChanged: (value) {
              controller.selectedCourse.value = value;
              controller.fetchColleges();
            },
          ),
        ),
      );
    });
  }

  Widget _buildSearchField(bool isDark) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: _surface(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border(isDark), width: 1.5),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: _onSearchChanged,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isDark ? const Color(0xFFF1F1F8) : const Color(0xFF0F0F1A),
        ),
        decoration: InputDecoration(
          hintText: "Search by name, district...",
          hintStyle: TextStyle(
            color: _textSecondary(isDark),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: _AppColors.indigo,
            size: 20,
          ),
          suffixIcon: Obx(
            () => controller.searchText.isNotEmpty
                ? GestureDetector(
                    onTap: () => controller.searchController.clear(),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _border(isDark),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: _textSecondary(isDark),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, bool isDark) {
    return Obx(() {
      final count = controller.activeFilterCount;
      final isActive = count > 0;

      return GestureDetector(
        // onTap: () => _showFilterSheet(context),
        onTap: () async {
          if (controller.states.isEmpty ||
              controller.ugCourseOptions.isEmpty &&
                  controller.pgCourseOptions.isEmpty) {
            await controller.loadMasters();
          }
          _showFilterSheet(context);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: isActive ? _AppColors.indigo : _surface(isDark),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive ? Colors.transparent : _border(isDark),
              width: 1.5,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: _AppColors.indigo.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.tune_rounded,
                size: 20,
                color: isActive
                    ? Colors.white
                    : (isDark
                          ? const Color(0xFF8B8BA8)
                          : const Color(0xFF6B6B8A)),
              ),
              if (isActive)
                Positioned(
                  top: 9,
                  right: 9,
                  child: Container(
                    height: 16,
                    width: 16,
                    decoration: const BoxDecoration(
                      color: _AppColors.rose,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  // ════════════════════════════════════════════
  //  ACTIVE FILTER CHIPS
  // ════════════════════════════════════════════
  Widget _buildActiveFilters(bool isDark) {
    return Obx(() {
      final chips = <_FilterChipData>[];

      void addChip(String? value, String label, VoidCallback onRemove) {
        if (value != null && value.toString().trim().isNotEmpty) {
          chips.add(_FilterChipData(label: label, onRemove: onRemove));
        }
      }

      /// 📍 DISTRICT
      addChip(
        controller.selectedCity.value,
        "District: ${controller.selectedCity.value}",
        () {
          controller.selectedCity.value = null;
          controller.cityCtrl.clear();
          controller.fetchColleges();
        },
      );

      /// 🎓 COURSE TYPE
      addChip(
        controller.selectedCourseLevel.value,
        "Type: ${controller.selectedCourseLevel.value}",
        () {
          controller.setCourseLevel(null);
          controller.fetchColleges();
        },
      );

      /// 📚 COURSE
      addChip(
        controller.selectedCourse.value,
        "Course: ${controller.selectedCourse.value}",
        () {
          controller.selectedCourse.value = null;
          controller.fetchColleges();
        },
      );

      /// 🏫 INSTITUTE TYPES
      for (final instituteType in controller.selectedInstituteTypes) {
        chips.add(
          _FilterChipData(
            label: "Institute: $instituteType",
            onRemove: () {
              controller.removeInstituteType(instituteType);
              controller.fetchColleges();
            },
          ),
        );
      }

      /// 🌍 STATE (🔥 IMPROVED LABEL)
      addChip(
        controller.selectedState.value,
        "State: ${controller.selectedState.value}",
        () {
          controller.selectedState.value = null;
          controller.removeInstituteType('Deemed');
          controller.fetchColleges();
        },
      );

      addChip(
        controller.selectedMccState.value,
        "MCC State: ${controller.selectedMccState.value}",
        () {
          controller.selectedMccState.value = null;
          controller.selectedCity.value = null;
          controller.cityCtrl.clear();
          controller.fetchColleges();
        },
      );

      /// 📅 YEAR
      addChip(
        controller.selectedYear.value,
        "Year: ${controller.selectedYear.value}",
        () {
          controller.selectedYear.value = null;
          controller.fetchColleges();
        },
      );

      /// 🎯 QUOTA
      addChip(
        controller.selectedQuota.value,
        "Quota: ${controller.selectedQuota.value}",
        () {
          controller.selectedQuota.value = null;
          controller.fetchColleges();
        },
      );

      /// 🪑 MIN SEATS
      // if (controller.minSeats.value != null) {
      //   chips.add(
      //     _FilterChipData(
      //       label: "Min ${controller.minSeats.value} seats",
      //       onRemove: () {
      //         controller.minSeats.value = null;
      //         controller.minSeatsCtrl.clear();
      //         controller.fetchColleges();
      //       },
      //     ),
      //   );
      // }

      /// 🪑 MAX SEATS
      // if (controller.maxSeats.value != null) {
      //   chips.add(
      //     _FilterChipData(
      //       label: "Max ${controller.maxSeats.value} seats",
      //       onRemove: () {
      //         controller.maxSeats.value = null;
      //         controller.maxSeatsCtrl.clear();
      //         controller.fetchColleges();
      //       },
      //     ),
      //   );
      // }

      /// ❌ NO FILTERS
      if (chips.isEmpty) return const SizedBox.shrink();

      return Container(
        height: 44,
        margin: const EdgeInsets.only(bottom: 6),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: chips.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            /// 🔥 CLEAR ALL BUTTON
            if (index == chips.length) {
              return GestureDetector(
                onTap: controller.clearFilters,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _AppColors.rose.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _AppColors.rose.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.delete_sweep_rounded,
                        size: 13,
                        color: _AppColors.rose,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Clear all",
                        style: TextStyle(
                          fontSize: 12,
                          color: _AppColors.rose,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final chip = chips[index];

            return _ActiveFilterChip(
              label: chip.label,
              onRemove: chip.onRemove,
              isDark: isDark,
            );
          },
        ),
      );
    });
  }

  // ════════════════════════════════════════════
  //  RESULT COUNT
  // ════════════════════════════════════════════
  Widget _buildResultCount(bool isDark) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
        child: Row(
          children: [
            Text(
              () {
                final displayCount = controller.backendCount.value > 0
                    ? controller.backendCount.value
                    : controller.colleges.length;
                return displayCount == 1
                    ? "1 college found"
                    : "$displayCount colleges found";
              }(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _textSecondary(isDark),
              ),
            ),
            const SizedBox(width: 8),
            if (!controller.isLoading.value && controller.colleges.isNotEmpty)
              Container(
                height: 4,
                width: 4,
                decoration: const BoxDecoration(
                  color: _AppColors.emerald,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════
  //  COLLEGE LIST
  // ════════════════════════════════════════════
  Widget _buildCollegeList(bool isDark) {
    return Obx(() {
      // Only show shimmer if loading and no data yet
      if (controller.isLoading.value && controller.colleges.isEmpty) {
        return _buildShimmerList(isDark);
      }
      // Show empty state if not loading and no data
      if (!controller.isLoading.value && controller.colleges.isEmpty) {
        return _buildEmptyState(isDark);
      }

      final showBottomLoader =
          controller.isLoadingMore.value && controller.hasMore.value;
      final showTopLoader =
          controller.isLoading.value && controller.colleges.isNotEmpty;

      return RefreshIndicator(
        color: _AppColors.indigo,
        backgroundColor: _card(isDark),
        onRefresh: controller.refreshList,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            if (showTopLoader)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: CircularProgressIndicator(color: _AppColors.indigo),
                  ),
                ),
              ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (showBottomLoader && index == controller.colleges.length) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: CircularProgressIndicator(
                          color: _AppColors.indigo,
                        ),
                      ),
                    );
                  }
                  final college = controller.colleges[index];
                  return _CollegeCard(
                    college: college,
                    isDark: isDark,
                    index: index,
                  );
                },
                childCount:
                    controller.colleges.length + (showBottomLoader ? 1 : 0),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ════════════════════════════════════════════
  //  SHIMMER
  // ════════════════════════════════════════════
  Widget _buildShimmerList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      itemCount: 5,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Shimmer.fromColors(
          baseColor: isDark ? const Color(0xFF1C1C27) : const Color(0xFFE8EAF2),
          highlightColor: isDark
              ? const Color(0xFF252535)
              : const Color(0xFFF5F6FA),
          child: Container(
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════
  //  EMPTY STATE
  // ════════════════════════════════════════════
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 88,
            width: 88,
            decoration: BoxDecoration(
              color: _AppColors.indigo.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 40,
              color: _AppColors.indigo,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No colleges found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFF1F1F8) : const Color(0xFF0F0F1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your filters\nor search with different keywords.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? const Color(0xFF8B8BA8) : const Color(0xFF6B6B8A),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  //  FILTER BOTTOM SHEET
  // ════════════════════════════════════════════
  void _showFilterSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0A0A0F) : const Color(0xFFF5F6FA);
    final surfaceColor = isDark
        ? const Color(0xFF1C1C27)
        : const Color(0xFFFFFFFF);

    controller.minSeatsCtrl.text = controller.minSeats.value?.toString() ?? '';
    controller.maxSeatsCtrl.text = controller.maxSeats.value?.toString() ?? '';
    if (!_isMccState(controller.selectedState.value)) {
      controller.removeInstituteType('Deemed');
    }

    Get.bottomSheet(
      _FilterSheet(
        controller: controller,
        isDark: isDark,
        bgColor: bgColor,
        surfaceColor: surfaceColor,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

// ─────────────────────────────────────────────
//  College Card Widget
// ─────────────────────────────────────────────
class _CollegeCard extends StatelessWidget {
  final College college;
  final bool isDark;
  final int index;

  const _CollegeCard({
    required this.college,
    required this.isDark,
    required this.index,
  });

  static const _avatarColors = [
    Color(0xFF4F46E5),
    Color(0xFF0EA5E9),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFF43F5E),
    Color(0xFF8B5CF6),
  ];

  @override
  Widget build(BuildContext context) {
    final avatarColor = _avatarColors[index % _avatarColors.length];
    final initial = (college.name?.isNotEmpty == true)
        ? college.name![0].toUpperCase()
        : 'C';

    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.collageDetails,
        arguments: {
          'collegeId': college.id,
          'college': college,
        },
      ),
      child: Container(
        // margin: const EdgeInsets.only(bottom: 12),
        // decoration: BoxDecoration(
        //   color: isDark ? const Color(0xFF1C1C27) : Colors.white,
        //   borderRadius: BorderRadius.circular(18),
        //   border: Border.all(
        //     color: isDark
        //         ? const Color(0xFF2A2A38)
        //         : const Color(0xFFE8EAF2),
        //     width: 1,
        //   ),
        //   boxShadow: isDark
        //       ? []
        //       : [
        //           BoxShadow(
        //             color: Colors.black.withOpacity(0.05),
        //             blurRadius: 16,
        //             offset: const Offset(0, 4),
        //           ),
        //         ],
        // ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [avatarColor, avatarColor.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: avatarColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      college.name ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        color: isDark
                            ? const Color(0xFFF1F1F8)
                            : const Color(0xFF0F0F1A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 13,
                          color: isDark
                              ? const Color(0xFF8B8BA8)
                              : const Color(0xFF6B6B8A),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          college.state.name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? const Color(0xFF8B8BA8)
                                : const Color(0xFF6B6B8A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow
              Container(
                height: 34,
                width: 34,
                // decoration: BoxDecoration(
                //   color: isDark
                //       ? const Color(0xFF252535)
                //       : const Color(0xFFF5F6FA),
                //   borderRadius: BorderRadius.circular(10),
                // ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: isDark
                      ? const Color(0xFF8B8BA8)
                      : const Color(0xFF6B6B8A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Active Filter Chip
// ─────────────────────────────────────────────
class _ActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  final bool isDark;

  const _ActiveFilterChip({
    required this.label,
    required this.onRemove,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: _AppColors.indigo.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _AppColors.indigo.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: _AppColors.indigo,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: _AppColors.indigo.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 10,
                color: _AppColors.indigo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Filter Bottom Sheet (extracted widget)
// ─────────────────────────────────────────────
class _FilterSheet extends StatelessWidget {
  final CollegeSearchController controller;
  final bool isDark;
  final Color bgColor;
  final Color surfaceColor;

  const _FilterSheet({
    required this.controller,
    required this.isDark,
    required this.bgColor,
    required this.surfaceColor,
  });

  Color get _textPrimary =>
      isDark ? const Color(0xFFF1F1F8) : const Color(0xFF0F0F1A);
  Color get _textSecondary =>
      isDark ? const Color(0xFF8B8BA8) : const Color(0xFF6B6B8A);
  Color get _divider =>
      isDark ? const Color(0xFF2A2A38) : const Color(0xFFE8EAF2);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: _divider, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 14),
            height: 4,
            width: 36,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3A3A4A) : const Color(0xFFCDD0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              children: [
                Text(
                  "Filter",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() {
                  final count = controller.activeFilterCount;
                  if (count == 0) return const SizedBox.shrink();
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _AppColors.indigo,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "$count active",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    controller.clearFilters();
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _AppColors.rose.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _AppColors.rose.withOpacity(0.2),
                      ),
                    ),
                    child: const Text(
                      "Reset",
                      style: TextStyle(
                        color: _AppColors.rose,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: _divider),

          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  _sectionLabel("State"),
                  const SizedBox(height: 10),
                  Obx(() {
                    final states = controller.states
                        .map((e) => e.name.toString())
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dropdownField(
                          value: states.contains(controller.selectedState.value)
                              ? controller.selectedState.value
                              : null,

                          hint: "Select State",

                          items: states,

                          onChanged: (value) {
                            controller.updateSelectedState(value);

                            /// reset city when state changes
                            controller.selectedCity.value = null;
                            controller.cityCtrl.clear();

                            /// reset MCC state if normal state selected
                            if (!_isMccState(value)) {
                              controller.selectedMccState.value = null;

                              /// remove deemed if not MCC
                              controller.removeInstituteType('Deemed');
                            }
                          },
                        ),

                        /// MCC STATE DROPDOWN
                        if (_isMccState(controller.selectedState.value)) ...[
                          const SizedBox(height: 20),

                          _sectionLabel("MCC State"),

                          const SizedBox(height: 10),

                          Obx(() {
                            final mccStates = controller.mccStates;

                            return _dropdownField(
                              value:
                                  mccStates.contains(
                                    controller.selectedMccState.value,
                                  )
                                  ? controller.selectedMccState.value
                                  : null,

                              hint: "Select MCC State",

                              items: mccStates,

                              onChanged: (value) {
                                controller.selectedMccState.value = value;

                                /// reset city when MCC state changes
                                controller.selectedCity.value = null;
                                controller.cityCtrl.clear();
                              },
                            );
                          }),
                        ],
                      ],
                    );
                  }),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (controller.selectedState.value == null) {
                      return const SizedBox.shrink();
                    }

                    final cityOptions =
                        _isMccState(controller.selectedState.value)
                        ? controller.mccCities
                        : controller.availableCityOptions;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel("District"),
                        const SizedBox(height: 10),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: controller.cityCtrl,

                          builder: (context, value, _) {
                            final currentCity = value.text.trim();

                            return _dropdownField(
                              key: ValueKey(
                                "${controller.selectedState.value}_${controller.selectedMccState.value}",
                              ),

                              value: cityOptions.contains(currentCity)
                                  ? currentCity
                                  : null,

                              hint: "Select District",

                              items: cityOptions,

                              onChanged: (val) {
                                controller.selectedCity.value = val;
                                controller.cityCtrl.text = val ?? '';
                              },
                            );
                          },
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 24),

                  _sectionLabel("Course Type"),
                  const SizedBox(height: 10),
                  Obx(
                    () => _chipGroup(
                      const ["UG"],
                      controller.selectedCourseLevel.value,
                      controller.setCourseLevel,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // _sectionLabel("Course"),
                  // const SizedBox(height: 10),
                  // Obx(
                  //   () => _chipGroup(
                  //     controller.availableCourseOptions,
                  //     controller.selectedCourse.value,
                  //     (val) => controller.selectedCourse.value = val,
                  //   ),
                  // ),
                  _sectionLabel("Course"),
                  const SizedBox(height: 10),
                  Obx(() {
                    final courses = _buildPriorityCourseItems(
                      controller.availableCourseOptions,
                    );
                    final isLoadingCourses =
                        controller.ugCourseOptions.isEmpty &&
                        controller.pgCourseOptions.isEmpty;

                    if (isLoadingCourses) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("Loading courses..."),
                      );
                    }

                    return _dropdownField(
                      value: controller.selectedCourse.value,
                      hint: "Select Course",
                      items: courses,
                      onChanged: (val) => controller.selectedCourse.value = val,
                    );
                  }),
                  const SizedBox(height: 24),

                  _sectionLabel("Institute Type"),
                  const SizedBox(height: 10),
                  Obx(() {
                    final instituteTypes = _buildInstituteTypeOptions(
                      controller.selectedState.value,
                    );
                    return _multiSelectChipGroup(
                      instituteTypes,
                      controller.selectedInstituteTypes,
                      controller.toggleInstituteType,
                    );
                  }),
                  const SizedBox(height: 24),

                  // _sectionLabel("Year"),
                  // const SizedBox(height: 10),
                  // Obx(
                  //   () => _chipGroup(
                  //     [
                  //       for (
                  //         int y = DateTime.now().year;
                  //         y >= DateTime.now().year - 4;
                  //         y--
                  //       )
                  //         y.toString(),
                  //     ],
                  //     controller.selectedYear.value,
                  //     (val) => controller.selectedYear.value = val,
                  //   ),
                  // ),
                  // const SizedBox(height: 24),
                  // _sectionLabel("Seats Range"),
                  // const SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: _buildTextField(
                  //         controller.minSeatsCtrl,
                  //         "Min seats",
                  //       ),
                  //     ),
                  //     const SizedBox(width: 12),
                  //     Expanded(
                  //       child: _buildTextField(
                  //         controller.maxSeatsCtrl,
                  //         "Max seats",
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // const SizedBox(height: 28),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border(top: BorderSide(color: _divider, width: 1)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  controller.applyFilters(
                    cityValue: controller.cityCtrl.text,
                    stateValue: controller.selectedState.value,
                    courseLevelValue: controller.selectedCourseLevel.value,
                    courseNameValue: controller.selectedCourse.value,
                    instituteTypeValues: controller.selectedInstituteTypes,
                    minSeatsValue: int.tryParse(controller.minSeatsCtrl.text),
                    maxSeatsValue: int.tryParse(controller.maxSeatsCtrl.text),
                  );
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _AppColors.indigo,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_rounded, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Apply Filters",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownField({
    Key? key,
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null,
          hint: Text(hint, style: TextStyle(color: _textSecondary)),
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: _textSecondary,
      ),
    );
  }

  Widget _chipGroup(
    List<String> options,
    String? selected,
    ValueChanged<String?> onSelected,
  ) {
    if (options.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _divider, width: 1.2),
        ),
        child: Text(
          "No options available yet",
          style: TextStyle(
            fontSize: 13,
            color: _textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected == option;
        return GestureDetector(
          onTap: () => onSelected(isSelected ? null : option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected
                  ? _AppColors.indigo
                  : (isDark
                        ? const Color(0xFF1C1C27)
                        : const Color(0xFFFFFFFF)),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : (isDark
                          ? const Color(0xFF2A2A38)
                          : const Color(0xFFE8EAF2)),
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: _AppColors.indigo.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark
                          ? const Color(0xFFB0B0C8)
                          : const Color(0xFF4A4A6A)),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _multiSelectChipGroup(
    List<String> options,
    List<String> selectedValues,
    ValueChanged<String> onToggle,
  ) {
    final normalizedSelected = selectedValues
        .map((value) => value.trim().toLowerCase())
        .toSet();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = normalizedSelected.contains(
          option.trim().toLowerCase(),
        );

        return GestureDetector(
          onTap: () => onToggle(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected
                  ? _AppColors.indigo
                  : (isDark
                        ? const Color(0xFF1C1C27)
                        : const Color(0xFFFFFFFF)),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : (isDark
                          ? const Color(0xFF2A2A38)
                          : const Color(0xFFE8EAF2)),
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: _AppColors.indigo.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark
                          ? const Color(0xFFB0B0C8)
                          : const Color(0xFF4A4A6A)),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String hint, {
    TextInputType keyboardType = TextInputType.number,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? const Color(0xFFF1F1F8) : const Color(0xFF0F0F1A),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: _textSecondary, fontSize: 13),
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _divider, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _divider, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _AppColors.indigo, width: 1.5),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Data classes
// ─────────────────────────────────────────────
class _FilterChipData {
  final String label;
  final VoidCallback onRemove;
  _FilterChipData({required this.label, required this.onRemove});
}
