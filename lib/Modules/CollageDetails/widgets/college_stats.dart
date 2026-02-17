import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollegeStats extends StatelessWidget {
  final String label;
  final String value;

  const CollegeStats({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- Theme Palette ---
    final Color cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color borderColor = isDark ? const Color(0xFF333333) : Colors.grey.shade200;
    final Color valueColor = isDark ? Colors.white : const Color(0xFF111111);
    final Color labelColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    
    // An accent color (Blue) to make the stat pop visually
    final Color accentColor = const Color(0xFF2979FF);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: isDark 
          ? [] // No shadow in dark mode (flat design)
          : [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: Row(
        children: [
          // Decorative Accent Bar
          Container(
            width: 3,
            height: 32,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(isDark ? 0.8 : 1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.toUpperCase(), // Uppercase looks more professional for labels
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: labelColor,
                    letterSpacing: 0.8, // Spacing makes small text readable
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}