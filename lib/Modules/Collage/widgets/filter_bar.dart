import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gixa/common/app_colors.dart';

class FilterBar extends StatelessWidget {
  final int collegeCount;
  final bool isDark;
  final Color surfaceColor;
  final int activeFilterCount;
  final VoidCallback onFilterTap;

  const FilterBar({
    required this.collegeCount,
    super.key,
    required this.isDark,
    required this.surfaceColor,
    required this.activeFilterCount,
    required this.onFilterTap,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final shouldShowCollegeCount = activeFilterCount > 0;

    return Container(
      width: double.infinity,

      color: surfaceColor,

      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),

      child: Align(
        alignment: Alignment.centerLeft,

        child: Row(
          children: [
            _Chip(
              label: activeFilterCount > 0
                  ? 'All Filters ($activeFilterCount)'
                  : 'All Filters',

              prefixIcon: Icons.tune_rounded,

              isActive: activeFilterCount > 0,

              isDark: isDark,

              onTap: onFilterTap,
            ),

            if (shouldShowCollegeCount) ...[
              const SizedBox(width: 12),

              AnimatedContainer(
                duration: const Duration(milliseconds: 250),

                curve: Curves.easeOut,

                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF8A00),
                      Color(0xFFFF3D6B),
                      Color(0xFF7B3FE4),
                      Color(0xFF3A8DFF),
                    ],
                  ),

                  borderRadius: BorderRadius.circular(12),

                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B3FE4).withOpacity(.22),

                      blurRadius: 10,

                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    const Icon(
                      Icons.school_rounded,

                      color: Colors.white,

                      size: 16,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      collegeCount == 1
                          ? "1 College Found"
                          : "$collegeCount Colleges Found",

                      style: GoogleFonts.inter(
                        fontSize: 12.5,

                        fontWeight: FontWeight.w700,

                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  static const _kBlue = kHomeAccentColor;

  const _Chip({
    required this.label,
    required this.prefixIcon,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final inactiveBg = isDark ? Colors.white.withOpacity(0.07) : Colors.white;
    final inactiveBorder = isDark
        ? Colors.white.withOpacity(0.12)
        : Colors.grey.shade300;
    final inactiveText = isDark ? Colors.grey.shade300 : Colors.grey.shade700;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? _kBlue.withOpacity(isDark ? 0.18 : 0.08)
              : inactiveBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? _kBlue.withOpacity(0.55) : inactiveBorder,
            width: isActive ? 1.3 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(prefixIcon, size: 15, color: isActive ? _kBlue : inactiveText),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? _kBlue : inactiveText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
