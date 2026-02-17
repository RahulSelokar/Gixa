import 'package:flutter/material.dart';

/// 🎨 Centralized College Detail Page Theme
class CollegeTheme {
  // ─────────────────────────────────────────────
  // 🎨 BRAND COLORS (Static Global)
  // ─────────────────────────────────────────────
  static const Color kPrimaryBlue = Color(0xFF1565C0); // Brand Base
  static const Color kAccentAmber = Color(0xFFF59E0B); // Premium/Warning
  static const Color kAccentGreen = Color(0xFF10B981); // Success/Available
  static const Color kAccentRed   = Color(0xFFE53935); // Error/Unavailable

  // ─────────────────────────────────────────────
  // 🌗 DYNAMIC THEME ACCESSOR
  // ─────────────────────────────────────────────
  static CollegeThemeColors colors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CollegeThemeColors(isDark: isDark);
  }
}

/// Dynamic color palette based on theme brightness
class CollegeThemeColors {
  final bool isDark;

  CollegeThemeColors({required this.isDark});

  // ─────────────────────────────────────────────
  // 🏠 BACKGROUNDS & SURFACES
  // ─────────────────────────────────────────────
  /// Main scaffold background
  Color get background => isDark ? const Color(0xFF121212) : Colors.white;
  
  /// Card backgrounds (slightly elevated in dark mode)
  Color get cardBackground => isDark ? const Color(0xFF1E1E1E) : Colors.white;
  
  /// Backgrounds for inputs, search bars, or secondary containers
  Color get surfaceHighlight => isDark ? const Color(0xFF2C2C2C) : Colors.grey[50]!;

  // ─────────────────────────────────────────────
  // ✍️ TYPOGRAPHY
  // ─────────────────────────────────────────────
  /// Main Headings
  Color get textMain => isDark ? Colors.white : const Color(0xFF111111);
  
  /// Subtitles, descriptions, icons
  Color get textSub => isDark ? Colors.grey[400]! : const Color(0xFF757575);
  
  /// Disabled text or placeholders
  Color get textDisabled => isDark ? Colors.grey[600]! : Colors.grey[400]!;

  // ─────────────────────────────────────────────
  // 🧱 BORDERS & DIVIDERS
  // ─────────────────────────────────────────────
  /// Subtle borders for cards and dividers
  Color get border => isDark ? const Color(0xFF333333) : Colors.grey[200]!;
  
  /// Stronger border for active elements
  Color get borderActive => isDark ? Colors.grey[600]! : Colors.grey[400]!;

  // ─────────────────────────────────────────────
  // 🏷️ TAGS & CHIPS (Backgrounds)
  // ─────────────────────────────────────────────
  // Blue Tag (Rankings)
  Color get blueTagBg => isDark ? const Color(0xFF1565C0).withOpacity(0.2) : const Color(0xFFE3F2FD);
  Color get blueTagText => isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0);

  // Green Tag (Type/Success)
  Color get greenTagBg => isDark ? const Color(0xFF1B3320) : const Color(0xFFE8F5E9);
  Color get greenTagText => isDark ? const Color(0xFF69F0AE) : const Color(0xFF2E7D32);

  // Orange Tag (Alerts/Premium)
  Color get orangeTagBg => isDark ? const Color(0xFF33261A) : const Color(0xFFFFF3E0);
  Color get orangeTagText => isDark ? const Color(0xFFFFB74D) : const Color(0xFFEF6C00);

  // ─────────────────────────────────────────────
  // 🌑 SHADOWS & ELEVATION
  // ─────────────────────────────────────────────
  /// Soft shadow for Light Mode, None for Dark Mode (Flat design)
  List<BoxShadow> get defaultShadow => isDark 
      ? [] 
      : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ];
        
  /// Stronger shadow for floating buttons or bottom bars
  List<BoxShadow> get floatingShadow => isDark 
      ? [] 
      : [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ];
}