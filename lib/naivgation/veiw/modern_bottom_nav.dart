import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ModernBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Brand Color
  final Color kPrimaryBlue = const Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    // 🌗 Theme Detection
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // 🎨 Dynamic Colors
    final Color navBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color inactiveIconColor = isDark ? Colors.grey[400]! : Colors.grey[400]!;
    final Color borderColor = isDark ? Colors.grey[800]! : Colors.transparent;
    
    // Shadows only for Light Mode (Shadows look messy in Dark Mode)
    final List<BoxShadow> shadows = isDark 
        ? [] 
        : [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: kPrimaryBlue.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ];

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      height: 70,
      decoration: BoxDecoration(
        color: navBgColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: borderColor, width: 1), // Thin border for Dark Mode definition
        boxShadow: shadows,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, "Home", inactiveIconColor),
          _buildNavItem(1, Icons.school_rounded, Icons.school_outlined, "Colleges", inactiveIconColor),
          // Note: Index adjusted to 2 because you commented out "Predictor" in the Page List
          _buildNavItem(2, Icons.person_rounded, Icons.person_outline_rounded, "Profile", inactiveIconColor),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label, Color inactiveColor) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryBlue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Icon
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? kPrimaryBlue : inactiveColor,
              size: 26,
            ),
            
            // Text Label (Animated width)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: isSelected ? null : 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: kPrimaryBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}