import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsGrid extends StatelessWidget {
  final CollegeDetail college;

  const StatsGrid({super.key, required this.college});

  @override
  Widget build(BuildContext context) {
    // Determine Theme Brightness
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- Theme Palette ---
    // Background: Darker grey in dark mode, pure white in light mode
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    // Border: Subtle separators
    final Color borderColor = isDark
        ? const Color(0xFF333333)
        : const Color(0xFFEEEEEE);

    // Shadow: Only for light mode to give lift
    final List<BoxShadow> shadows = isDark
        ? []
        : [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ];

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            label: "ESTABLISHED",
            value: college.yearEstablished.toString(),
            icon: Icons.calendar_month_rounded,
            cardColor: cardColor,
            borderColor: borderColor,
            shadows: shadows,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 16), // Increased spacing slightly
        Expanded(
          child: _buildStatCard(
            context,
            label: "HOSTEL",
            value: college.hostelAvailable
                ? (college.hostelFor ?? "Available")
                : "Not Available",

            icon: Icons.bed_rounded,
            cardColor: cardColor,
            borderColor: borderColor,
            shadows: shadows,
            isDark: isDark,
            // Highlight text if not available
            isWarning: !college.hostelAvailable,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color cardColor,
    required Color borderColor,
    required List<BoxShadow> shadows,
    required bool isDark,
    bool isWarning = false,
  }) {
    // Text Colors based on theme
    final titleColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final valueColor = isDark ? Colors.white : const Color(0xFF111111);

    // Icon styling
    final iconColor = isDark ? Colors.blue[200] : Colors.blue[700];
    final iconBgColor = isDark
        ? Colors.blue.withOpacity(0.15)
        : Colors.blue.withOpacity(0.08);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: shadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Label Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Value Text
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              // If it's a warning (e.g. Not Available), style it differently, otherwise standard color
              color: isWarning
                  ? (isDark ? Colors.red[300] : Colors.red[600])
                  : valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
