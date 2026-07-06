import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/collage_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

class CoursesSection extends StatelessWidget {
  final CollegeDetail college;

  const CoursesSection({super.key, required this.college});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final ugList = profileController.isUGUser ? college.courses.ug : [];
    final pgList = profileController.isPGUser ? college.courses.pg : [];

    if (ugList.isEmpty && pgList.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = CollegeTheme.colors(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: colors.warmGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              "Academics",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.textMain,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: colors.surfaceGradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border),
            boxShadow: colors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ugList.isNotEmpty)
                _CourseCategory(
                  title: "Undergraduate (UG)",
                  items: ugList.map<String>((e) => e.name.toString()).toList(),
                  baseColor: colors.primary,
                  colors: colors,
                ),
              if (ugList.isNotEmpty && pgList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Divider(
                    color: colors.subtleBorder,
                    thickness: 1,
                    height: 1,
                  ),
                ),
              if (pgList.isNotEmpty)
                _CourseCategory(
                  title: "Postgraduate (PG)",
                  items: pgList
                      .map<String>((e) => "${e.courseName} - ${e.specialtyType}")
                      .toList(),
                  baseColor: colors.purple,
                  colors: colors,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CourseCategory extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color baseColor;
  final CollegeThemeColors colors;

  const _CourseCategory({
    required this.title,
    required this.items,
    required this.baseColor,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 16,
              width: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [baseColor, baseColor.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textSub,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: items.map(_buildModernChip).toList(),
        ),
      ],
    );
  }

  Widget _buildModernChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colors.softFill(baseColor),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: baseColor.withOpacity(colors.isDark ? 0.32 : 0.16)),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colors.chipText(baseColor),
          height: 1.2,
        ),
      ),
    );
  }
}
