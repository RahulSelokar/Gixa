import 'package:Gixa/Modules/Collage/controller/collage_list_controller.dart';
import 'package:Gixa/Modules/comparison/controller/college_compare_controller.dart';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../../routes/app_routes.dart';

class CollegeListPage extends StatelessWidget {
  CollegeListPage({super.key});

  final controller = Get.put(CollegeListController());
  final comapreController = Get.put(CollegeCompareController());
  final navController = Get.find<MainNavController>();

  final Color kPrimaryBlue = const Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF8F9FD);
    final Color surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF111111);
    final Color subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final Color borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final Color iconBoxColor = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFF0F4F8);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'top_institutes'.tr,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: textColor,
          ),
        ),
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textColor),
        scrolledUnderElevation: 0,
        actions: [
          /// 🔥 SHOW COMPARE BUTTON ONLY WHEN 2 SELECTED
          Obx(() {
            if (comapreController.selectedColleges.length == 2) {
              return IconButton(
                tooltip: 'compare_colleges'.tr,
                icon: const Icon(Icons.compare_arrows),
                onPressed: () async {
                  await comapreController.compareColleges();
                  Get.toNamed(AppRoutes.compareCollage);
                },
              );
            }
            return const SizedBox.shrink();
          }),

          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Get.toNamed(AppRoutes.search);
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Get.toNamed(AppRoutes.fevouriteCollage);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: kPrimaryBlue));
        }

        if (controller.colleges.isEmpty) {
          return LiquidPullToRefresh(
            color: kPrimaryBlue,
            onRefresh: controller.refreshList,
            height: 110,
            animSpeedFactor: 2.5,
            showChildOpacityTransition: false,
            springAnimationDurationInMilliseconds: 500,
            child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                navController.updateScroll(notification.direction);
                return false;
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: _buildEmptyState(subTextColor),
                  ),
                ],
              ),
            ),
          );
        }

        return LiquidPullToRefresh(
          color: kPrimaryBlue,
          onRefresh: controller.refreshList,
          height: 50,
          animSpeedFactor: 2.5,
          showChildOpacityTransition: false,
          springAnimationDurationInMilliseconds: 500,
          child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              navController.updateScroll(notification.direction);
              return false;
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: controller.colleges.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final college = controller.colleges[index];

                return GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.collageDetails,
                      arguments: {'collegeId': college.id},
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                      boxShadow: isDark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// 1. 🏥 Header: Logo, Name, Bookmark
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 🏫 College Logo
                                  Container(
                                    height: 56,
                                    width: 56,
                                    decoration: BoxDecoration(
                                      color: iconBoxColor,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: borderColor),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: college.displayImage == null
                                          ? Icon(
                                              Icons.school_outlined,
                                              size: 28,
                                              color: Colors.grey,
                                            )
                                          : Image.network(
                                              college.displayImage!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: iconBoxColor,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(
                                                            Icons
                                                                .school_outlined,
                                                            size: 28,
                                                            color: Colors.grey,
                                                          ),
                                                          SizedBox(height: 4),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                            ),
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  // Name & Location
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          college.name,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                            height: 1.3,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: 14,
                                              color: subTextColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                "${college.state.name} • Est. ${college.yearEstablished}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: subTextColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Bookmark Icon
                                  Obx(() {
                                    final isSelected = comapreController
                                        .selectedColleges
                                        .contains(college.collegeCode);

                                    return Row(
                                      children: [
                                        Icon(
                                          Icons.bookmark_border_rounded,
                                          color: subTextColor,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () {
                                            comapreController.toggleCollege(
                                              college.collegeCode,
                                            );
                                          },
                                          child: Icon(
                                            isSelected
                                                ? Icons.check_circle
                                                : Icons.compare_arrows,
                                            color: isSelected
                                                ? Colors.green
                                                : subTextColor,
                                            size: 22,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),

                                  // Bookmark Icon
                                  // Icon(
                                  //   Icons.bookmark_border_rounded,
                                  //   color: subTextColor,
                                  //   size: 24,
                                  // ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              /// 2. 🏷️ Tags Row
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildModernTag(
                                      text: college.instituteType.name,
                                      color: kPrimaryBlue,
                                      isDark: isDark,
                                    ),
                                    const SizedBox(width: 8),
                                    if (college.hostelAvailable)
                                      _buildModernTag(
                                        text:
                                            '${'hostel'.tr}: ${college.hostelFor}',
                                        color: Colors.green,
                                        isDark: isDark,
                                        icon: Icons.check_circle_outline,
                                      ),
                                    const SizedBox(width: 8),
                                    // _buildModernTag(
                                    //   text:
                                    //       "NIRF Rank #--", // Placeholder if rank isn't in model yet
                                    //   color: Colors.orange,
                                    //   isDark: isDark,
                                    //   icon: Icons.emoji_events_outlined,
                                    // ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              /// 3. 📚 Course Highlights
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: iconBoxColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "programs_offered".tr,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: subTextColor,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    if (college.courses.ug.isNotEmpty)
                                      _buildCourseRow(
                                        "UG",
                                        college.courses.ug
                                            .map((e) => e.name)
                                            .join(", "),
                                        textColor,
                                      ),

                                    if (college.courses.pg.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      _buildCourseRow(
                                        "PG",
                                        college.courses.pg
                                            .map((e) => e.courseName)
                                            .join(", "),
                                        textColor,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// 4. 🦶 Footer Action
                        Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : kPrimaryBlue.withOpacity(0.05),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "view_institute".tr,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white70 : kPrimaryBlue,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: isDark ? Colors.white70 : kPrimaryBlue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  // ───────────────── WIDGET HELPERS ─────────────────

  Widget _buildEmptyState(Color subTextColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school_outlined, size: 60, color: subTextColor),
          ),
          const SizedBox(height: 24),
          Text(
            'no_colleges_found'.tr,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: subTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'adjust_filters'.tr,
            style: GoogleFonts.poppins(color: subTextColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// 🏷️ Modern Pill Tag
  Widget _buildModernTag({
    required String text,
    required Color color,
    IconData? icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20), // Pill shape
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 🎓 Course Text Row
  Widget _buildCourseRow(String prefix, String text, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            prefix,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: textColor.withOpacity(0.8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
