import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gixa/Modules/favourite/controller/fevorite_collage_controller.dart';
import 'package:Gixa/Modules/favourite/model/fevorite_model.dart';
import 'package:Gixa/routes/app_routes.dart';

class FavouriteCollegesPage extends StatelessWidget {
  const FavouriteCollegesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavouriteCollegeController controller = Get.put(
      FavouriteCollegeController(),
    );

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          "Favourite Colleges",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const _LoadingView();
        }

        if (controller.favouriteColleges.isEmpty) {
          return const _EmptyStateView();
        }

        return RefreshIndicator(
          onRefresh: controller.loadFavouriteColleges,
          color: theme.colorScheme.primary,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.favouriteColleges.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final FavouriteCollege college =
                  controller.favouriteColleges[index];

              return _CollegeCard(
                college: college,
                onToggleFavorite: () => controller.toggleFavourite(college.id),
              );
            },
          ),
        );
      }),
    );
  }
}

/* ───────────────────────── COLLEGE CARD ───────────────────────── */

class _CollegeCard extends StatelessWidget {
  final FavouriteCollege college;
  final VoidCallback onToggleFavorite;

  static const Color kPrimaryBlue = Color(0xFF1565C0);

  const _CollegeCard({required this.college, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF111111);
    final Color subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final Color borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final Color iconBoxColor = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFF0F4F8);

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.collageDetails,
          arguments: {'collegeId': college.id},
        );
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 120),
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
                  /// Header: Logo, Name, Favourite
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: iconBoxColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor),
                        ),
                        child: Icon(
                          Icons.school_outlined,
                          size: 28,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              college.name,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                height: 1.3,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                  color: subTextColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Est. ${college.yearEstablished}",
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: subTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        splashRadius: 20,
                        onPressed: onToggleFavorite,
                        icon: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// Tags Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (college.hostelAvailable)
                          _buildTag(
                            text: '${'hostel'.tr}: ${college.hostelFor}',
                            color: Colors.green,
                            isDark: isDark,
                            icon: Icons.check_circle_outline,
                          ),
                        if (college.website.isNotEmpty) ...[
                          if (college.hostelAvailable) const SizedBox(width: 8),
                          _buildTag(
                            text: 'Website',
                            color: kPrimaryBlue,
                            isDark: isDark,
                            icon: Icons.language,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Footer
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
                    style: GoogleFonts.inter(
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
  }

  Widget _buildTag({
    required String text,
    required Color color,
    required bool isDark,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
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
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────────────── EMPTY STATE ───────────────────────── */

class _EmptyStateView extends StatelessWidget {
  const _EmptyStateView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primaryContainer.withOpacity(0.4),
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 64,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No Favourites Yet",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Colleges you mark as favourite\nwill appear here.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────── LOADING ───────────────────────── */

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(strokeWidth: 3));
  }
}
