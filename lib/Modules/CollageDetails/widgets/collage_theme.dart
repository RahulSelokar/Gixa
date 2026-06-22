import 'package:Gixa/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CollegeTheme {
  static CollegeThemeColors colors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CollegeThemeColors(isDark: isDark);
  }
}

class CollegeThemeColors {
  final bool isDark;

  const CollegeThemeColors({required this.isDark});

  Color get primary => UColors.primary;
  Color get pink => UColors.primaryLight;
  Color get purple => UColors.primaryDark;
  Color get secondary => UColors.secondary;
  Color get success => const Color(0xFF14B87A);
  Color get danger => const Color(0xFFE84E78);

  Color get background => isDark ? const Color(0xFF120F1C) : const Color(0xFFFFFAF6);
  Color get cardBackground => isDark ? const Color(0xFF21192F) : Colors.white;
  Color get cardBackgroundSoft =>
      isDark ? const Color(0xFF2A203B) : const Color(0xFFFFF3EA);
  Color get surfaceHighlight =>
      isDark ? const Color(0xFF322546) : const Color(0xFFFFEEE1);
  Color get heroPlaceholder =>
      isDark ? const Color(0xFF2B2040) : const Color(0xFFF7E8DC);
  Color get appBarBackground =>
      isDark ? const Color(0xFF171222) : Colors.white.withOpacity(0.92);

  Color get textMain => isDark ? const Color(0xFFF7F2FF) : const Color(0xFF1A1330);
  Color get textSub => isDark ? const Color(0xFFC6BCD8) : const Color(0xFF6D627F);
  Color get textMuted => isDark ? const Color(0xFF9E93B5) : const Color(0xFF9789AA);

  Color get border =>
      isDark ? UColors.darkBorder.withOpacity(0.90) : UColors.border.withOpacity(0.80);
  Color get subtleBorder =>
      isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFFFE3CF);

  LinearGradient get brandGradient => const LinearGradient(
    colors: [UColors.primary, UColors.primaryLight, UColors.primaryDark, UColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient get warmGradient => const LinearGradient(
    colors: [Color(0xFFFFA13C), Color(0xFFFF4F88)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient get coolGradient => const LinearGradient(
    colors: [Color(0xFF9C35FF), UColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient get pageBackgroundGradient => LinearGradient(
    colors: isDark
        ? [
            const Color(0xFF120F1C),
            const Color(0xFF181224),
            const Color(0xFF0F1020),
          ]
        : [
            const Color(0xFFFFFBF7),
            const Color(0xFFFFF2E7),
            const Color(0xFFF9F2FF),
          ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  LinearGradient get surfaceGradient => LinearGradient(
    colors: isDark
        ? [
            cardBackground,
            const Color(0xFF261C37),
          ]
        : [
            Colors.white,
            const Color(0xFFFFF5EC),
          ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient get appBarGradient => LinearGradient(
    colors: isDark
        ? [
            const Color(0xFF181224).withOpacity(0.98),
            const Color(0xFF161320).withOpacity(0.94),
          ]
        : [
            Colors.white.withOpacity(0.96),
            const Color(0xFFFFF4EA).withOpacity(0.96),
          ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: isDark
          ? Colors.black.withOpacity(0.20)
          : const Color(0xFFFF8A00).withOpacity(0.10),
      blurRadius: isDark ? 18 : 22,
      offset: const Offset(0, 10),
    ),
  ];

  List<BoxShadow> get floatingShadow => [
    BoxShadow(
      color: isDark
          ? Colors.black.withOpacity(0.28)
          : const Color(0xFFFF4F88).withOpacity(0.18),
      blurRadius: isDark ? 22 : 28,
      offset: const Offset(0, 12),
    ),
  ];

  Color softFill(Color color, {double lightOpacity = 0.10, double darkOpacity = 0.22}) {
    return color.withOpacity(isDark ? darkOpacity : lightOpacity);
  }

  Color chipText(Color color) {
    return isDark ? Colors.white : color;
  }
}
