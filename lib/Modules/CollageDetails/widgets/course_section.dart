import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoursesSection extends StatelessWidget {
  final CollegeDetail college;

  const CoursesSection({
    super.key,
    required this.college,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Efficient Early Return
    if (college.courses.ug.isEmpty && college.courses.pg.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- Theme Palette ---
    // Background: Darker grey (Surface) vs Pure White
    final Color cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    // Main Title Color
    final Color titleColor = isDark ? Colors.white : const Color(0xFF111111);
    // Border for the main card
    final Color borderColor = isDark ? const Color(0xFF333333) : Colors.grey.shade200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.school_rounded, color: titleColor, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              "Academics",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Main Card Container
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            // Subtle shadow only in light mode
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // UG Section (Emerald Theme)
              _CourseCategory(
                title: "Undergraduate (UG)",
                items: college.courses.ug.map((e) => e.name).toList(),
                baseColor: const Color(0xFF10B981), // Emerald Green
                isDark: isDark,
              ),

              // Divider (Only if both exist)
              if (college.courses.ug.isNotEmpty && college.courses.pg.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Divider(
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
                    thickness: 1,
                    height: 1,
                  ),
                ),

              // PG Section (Amber/Orange Theme)
              _CourseCategory(
                title: "Postgraduate (PG)",
                items: college.courses.pg
                    .map((e) => "${e.courseName} • ${e.specialtyType}")
                    .toList(),
                baseColor: const Color(0xFFF59E0B), // Amber
                isDark: isDark,
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
  final Color baseColor; // The main accent color (Green or Orange)
  final bool isDark;

  const _CourseCategory({
    required this.title,
    required this.items,
    required this.baseColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Title with vertical accent bar
        Row(
          children: [
            Container(
              height: 16,
              width: 3,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                letterSpacing: 0.5,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Chips Layout
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: items.map((text) => _buildModernChip(text)).toList(),
        ),
      ],
    );
  }

  Widget _buildModernChip(String text) {
    // Determine Chip Colors based on Theme & Base Color
    
    // Light Mode: Very light pastel background, strong text
    // Dark Mode: Transparent background with colored border, or low opacity fill
    
    final Color chipBg = isDark 
        ? baseColor.withOpacity(0.15) 
        : baseColor.withOpacity(0.08);
        
    final Color chipBorder = isDark 
        ? baseColor.withOpacity(0.3) 
        : Colors.transparent;
        
    final Color chipText = isDark 
        ? Colors.grey[200]! // Light grey text in dark mode for readability
        : baseColor.withOpacity(1.0); // Strong colored text in light mode

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(8), // Slightly squared for modern look
        border: isDark ? Border.all(color: chipBorder) : null,
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: chipText,
          height: 1.2,
        ),
      ),
    );
  }
}