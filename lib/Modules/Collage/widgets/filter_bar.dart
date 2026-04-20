// ─────────────────────────────────────────────────────────────────────────────
//  FILTER BAR — paste this widget into your college_list_page.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterBar extends StatelessWidget {
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;
  final int activeFilterCount;
  final bool isSortActive;
  final bool isStateActive;
  final VoidCallback onSortTap;
  final VoidCallback onFilterTap;
  final VoidCallback onStateTap;

  const FilterBar({
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.activeFilterCount,
    required this.isSortActive,
    required this.isStateActive,
    required this.onSortTap,
    required this.onFilterTap,
    required this.onStateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: surfaceColor,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            // ── Sort chip ────────────────────────────────────
            _Chip(
              label: isSortActive ? 'Sort (1)' : 'Sort',
              prefixIcon: Icons.swap_vert_rounded,
              suffixIcon: null,
              isActive: isSortActive,
              isDark: isDark,
              onTap: onSortTap,
            ),

            const SizedBox(width: 8),

            // ── All Filters chip ─────────────────────────────
            _Chip(
              label: activeFilterCount > 0
                  ? 'All Filters ($activeFilterCount)'
                  : 'All Filters',
              prefixIcon: Icons.tune_rounded,
              suffixIcon: null,
              isActive: activeFilterCount > 0,
              isDark: isDark,
              onTap: onFilterTap,
            ),

            const SizedBox(width: 8),

            // ── State chip ───────────────────────────────────
            _Chip(
              label: 'State',
              prefixIcon: null,
              suffixIcon: Icons.keyboard_arrow_down_rounded,
              isActive: isStateActive,
              isDark: isDark,
              onTap: onStateTap,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Single filter chip ────────────────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final String label;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  static const _kBlue = Color(0xFF1565C0);

  const _Chip({
    required this.label,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = _kBlue;
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
              ? activeColor.withOpacity(isDark ? 0.18 : 0.08)
              : inactiveBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? activeColor.withOpacity(0.55) : inactiveBorder,
            width: isActive ? 1.3 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Prefix icon
            if (prefixIcon != null) ...[
              Icon(
                prefixIcon,
                size: 15,
                color: isActive ? activeColor : inactiveText,
              ),
              const SizedBox(width: 5),
            ],

            // Label
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? activeColor : inactiveText,
              ),
            ),

            // Suffix icon
            if (suffixIcon != null) ...[
              const SizedBox(width: 2),
              Icon(
                suffixIcon,
                size: 17,
                color: isActive ? activeColor : inactiveText,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
