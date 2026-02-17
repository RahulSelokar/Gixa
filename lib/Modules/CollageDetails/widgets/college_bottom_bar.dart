import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollegeBottomBar extends StatelessWidget {
  const CollegeBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- Theme Palette ---
    final Color barBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color borderColor = isDark ? const Color(0xFF333333) : Colors.transparent;
    final Color kPrimaryBlue = const Color(0xFF1565C0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: barBg,
        // Dark mode gets a border, Light mode gets a shadow
        border: isDark 
            ? Border(top: BorderSide(color: borderColor, width: 1)) 
            : null,
        boxShadow: isDark 
            ? [] 
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5), // Shadow points upwards
                ),
              ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 54, // Taller button for easier tapping
          child: ElevatedButton(
            onPressed: () {
              // Handle Save Logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryBlue,
              foregroundColor: Colors.white,
              elevation: 0, // Flat design inside the bar looks cleaner
              shape: const StadiumBorder(), // Fully rounded ends
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.bookmark_border_rounded, // Icon adds context
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  "Save to Favorites",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}