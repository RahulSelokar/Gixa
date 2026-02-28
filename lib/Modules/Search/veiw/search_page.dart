import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Gixa/Modules/Collage/model/collage_model.dart';
import 'package:Gixa/Modules/Search/controllers/search_controller.dart';
import 'package:Gixa/routes/app_routes.dart';

class CollegeSearchPage extends StatefulWidget {
  const CollegeSearchPage({super.key});

  @override
  State<CollegeSearchPage> createState() => _CollegeSearchPageState();
}

class _CollegeSearchPageState extends State<CollegeSearchPage>
    with SingleTickerProviderStateMixin {
  final CollegeSearchController controller =
      Get.put(CollegeSearchController());

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF7F8FA),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(isDark),
              _buildFilterChips(),
              _buildResultCount(),
              Expanded(child: _buildCollegeList(isDark)),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Explore Colleges",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                )
              ],
            ),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: "Search colleges...",
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: Obx(() =>
                    controller.searchText.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.searchController.clear();
                            },
                          )
                        : const SizedBox()),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= FILTER CHIPS =================

  Widget _buildFilterChips() {
    final filters = ["Government", "Private", "Autonomous"];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (_, index) {
          final filter = filters[index];

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Obx(() {
              final selected =
                  controller.selectedInstituteType.value == filter;

              return ChoiceChip(
                label: Text(filter),
                selected: selected,
                onSelected: (_) {
                  controller.selectedInstituteType.value =
                      selected ? null : filter;
                  controller.fetchColleges();
                },
              );
            }),
          );
        },
      ),
    );
  }

  // ================= RESULT COUNT =================

  Widget _buildResultCount() {
    return Obx(() => Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "${controller.colleges.length} Colleges Found",
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ));
  }

  // ================= COLLEGE LIST =================

  Widget _buildCollegeList(bool isDark) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerList(isDark);
      }

      if (controller.colleges.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: controller.fetchColleges,
        child: ListView.builder(
          padding:
              const EdgeInsets.fromLTRB(20, 10, 20, 30),
          itemCount: controller.colleges.length,
          itemBuilder: (context, index) {
            final college = controller.colleges[index];
            return FadeTransition(
              opacity: _animationController,
              child: _buildCollegeCard(
                  context, college, isDark),
            );
          },
        ),
      );
    });
  }

  // ================= COLLEGE CARD =================

  Widget _buildCollegeCard(
      BuildContext context, College college, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color:
            isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: ListTile(
        onTap: () {
          Get.toNamed(
            AppRoutes.collageDetails,
            arguments: {'collegeId': college.id},
          );
        },
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(radius: 28),
        title: Text(
          college.name ?? "",
          style:
              const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(college.state.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.compare_arrows),
              onPressed: () {},
            ),
            IconButton(
              icon:
                  const Icon(Icons.bookmark_border),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // ================= SHIMMER =================

  Widget _buildShimmerList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 6,
      itemBuilder: (_, __) {
        return Padding(
          padding:
              const EdgeInsets.only(bottom: 16),
          child: Shimmer.fromColors(
            baseColor: isDark
                ? Colors.grey[800]!
                : Colors.grey[300]!,
            highlightColor: isDark
                ? Colors.grey[700]!
                : Colors.grey[100]!,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= EMPTY STATE =================

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 50),
          SizedBox(height: 10),
          Text(
            "No colleges found",
            style:
                TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text("Try adjusting filters or search."),
        ],
      ),
    );
  }
}