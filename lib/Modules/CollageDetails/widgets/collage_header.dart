import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollegeHeaderSection extends StatelessWidget {
  final CollegeDetail college;

  const CollegeHeaderSection({
    super.key,
    required this.college,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- Dynamic Theme Colors ---
    final Color titleColor = isDark ? Colors.white : const Color(0xFF111111);
    final Color subTextColor = isDark ? Colors.grey[400]! : const Color(0xFF666666);
    
    // Tag Palette (Adaptive)
    // Blue: Light mode = Deep Blue, Dark mode = Light Blue
    final Color blueBase = isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0);
    // Green: Light mode = Forest Green, Dark mode = Light Green
    final Color greenBase = isDark ? const Color(0xFF69F0AE) : const Color(0xFF2E7D32);
    // Orange: Light mode = Burnt Orange, Dark mode = Amber
    final Color orangeBase = isDark ? const Color(0xFFFFB74D) : const Color(0xFFEF6C00);

    return Padding(
      // Added padding for better standalone usage
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. College Name
          Text(
            college.name,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: titleColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),

          // 2. Location Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns icon to top of text
            children: [
              Icon(
                Icons.location_on_outlined, 
                size: 18, 
                color: isDark ? Colors.red[300] : Colors.red[700], // Red tint for map marker
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  college.address.isNotEmpty
                      ? college.address
                      : "${college.state.name}, India",
                  style: GoogleFonts.poppins(
                    color: subTextColor,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. Tags ScrollView
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                // Rank Tag
                // _buildTag(
                //   text: "NIRF Rank #2", // You can make this dynamic if data exists
                //   baseColor: blueBase,
                //   icon: Icons.emoji_events_rounded,
                //   isDark: isDark,
                // ),
                const SizedBox(width: 10),

                // Institute Type Tag
                _buildTag(
                  text: college.instituteType.name,
                  baseColor: greenBase,
                  icon: Icons.account_balance_rounded,
                  isDark: isDark,
                ),
                const SizedBox(width: 10),

                // Established Year Tag
                _buildTag(
                  text: "Est. ${college.yearEstablished}",
                  baseColor: orangeBase,
                  icon: Icons.history_rounded,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag({
    required String text,
    required Color baseColor,
    required IconData icon,
    required bool isDark,
  }) {
    // Background: Low opacity version of base color
    final Color bgColor = isDark 
        ? baseColor.withOpacity(0.15) 
        : baseColor.withOpacity(0.08);

    // Border: Only visible in dark mode for definition
    final BoxBorder? border = isDark 
        ? Border.all(color: baseColor.withOpacity(0.3)) 
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon, 
            size: 14, 
            color: baseColor,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: baseColor, // Text matches icon color
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}