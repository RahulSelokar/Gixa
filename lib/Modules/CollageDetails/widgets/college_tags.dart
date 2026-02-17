import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gixa/Modules/CollageDetails/controller/collage_detail_controller.dart';

class CollegeTags extends StatelessWidget {
  const CollegeTags({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CollegeDetailController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      /// ✅ ALWAYS read Rx value first
      final college = controller.college.value;

      if (college == null) {
        return const SizedBox();
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            // Tag 1: Rank (Blue)
            // _ModernTag(
            //   text: "NIRF Rank #2",
            //   icon: Icons.emoji_events_rounded,
            //   baseColor: const Color(0xFF2979FF),
            //   isDark: isDark,
            // ),
            const SizedBox(width: 10),

            // Tag 2: Institute Type (Green)
            _ModernTag(
              text: college.instituteType.name,
              icon: Icons.account_balance_rounded,
              baseColor: const Color(0xFF00C853),
              isDark: isDark,
            ),
            const SizedBox(width: 10),

            // Tag 3: Area (Orange)
            // Note: Assuming '320 Acres' is hardcoded or comes from a property not shown in the snippet
            _ModernTag(
              text: "320 Acres", 
              icon: Icons.landscape_rounded,
              baseColor: const Color(0xFFFF9100),
              isDark: isDark,
            ),
          ],
        ),
      );
    });
  }
}

class _ModernTag extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color baseColor;
  final bool isDark;

  const _ModernTag({
    required this.text,
    required this.icon,
    required this.baseColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // --- Dynamic Theme Logic ---
    
    // Light: Very faint pastel bg, Strong text
    // Dark: Slightly transparent colored bg, Lighter text for contrast
    final Color bgColor = isDark 
        ? baseColor.withOpacity(0.15) 
        : baseColor.withOpacity(0.1);

    // Light: No border
    // Dark: Subtle colored border to define edges against dark bg
    final BoxBorder? border = isDark 
        ? Border.all(color: baseColor.withOpacity(0.4), width: 1) 
        : null;

    final Color contentColor = isDark 
        ? Colors.white.withOpacity(0.9) // White-ish in dark mode
        : baseColor.withOpacity(1.0); // Strong color in light mode

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30), // Fully rounded pill shape
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isDark ? baseColor.withOpacity(0.8) : baseColor, 
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: contentColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}