import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 1. BRAND COLORS
// ─────────────────────────────────────────────────────────────────────────────

class GixaColors {
  static const Color orange = Color(0xFFFF4E00);
  static const Color pink = Color(0xFFFF2D78);
  static const Color violet = Color(0xFF9B2FC8);
  static const Color blue = Color(0xFF3B82F6);
  static const Color green = Color(0xFF22C55E);
  static const Color amber = Color(0xFFF59E0B);

  static const Color ink = Color(0xFF1A1A2E);

  static const Gradient primaryGradient = LinearGradient(
    colors: [orange, pink, violet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient heroGradient = LinearGradient(
    colors: [orange, pink, violet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color pinkLight = pink.withOpacity(0.10);
  static Color orangeLight = orange.withOpacity(0.10);
  static Color violetLight = violet.withOpacity(0.10);
  static Color blueLight = blue.withOpacity(0.10);
  static Color greenLight = green.withOpacity(0.10);
  static Color iconBg = const Color(0xFFFF2D78).withOpacity(0.10);
}

// ─────────────────────────────────────────────────────────────────────────────
// 1b. THEME / SIZING HELPERS
// ─────────────────────────────────────────────────────────────────────────────

class CounsellingUi {
  static const double maxContentWidth = 1200;

  static List<BoxShadow> cardShadow(bool isDark) => [
    BoxShadow(
      color: Colors.black.withOpacity(isDark ? 0.28 : 0.05),
      blurRadius: 18,
      spreadRadius: -4,
      offset: const Offset(0, 8),
    ),
  ];

  static Color cardBg(BuildContext c, bool isDark) =>
      isDark ? const Color(0xFF1B1B2B) : Colors.white;

  static Color border(bool isDark) =>
      isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFEAECF2);

  static Color textPrimary(bool isDark) => isDark ? Colors.white : GixaColors.ink;

  static Color textSecondary(bool isDark) =>
      isDark ? Colors.grey.shade400 : const Color(0xFF6B7280);
}


class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
        letterSpacing: 0.9,
      ),
    );
  }
}