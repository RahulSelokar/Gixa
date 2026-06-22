import 'package:Gixa/utils/themes/widgets_themes/appbar_theme.dart';
import 'package:Gixa/utils/themes/widgets_themes/bottom_sheet_theme.dart';
import 'package:Gixa/utils/themes/widgets_themes/elevated_button_theme.dart';
import 'package:Gixa/utils/themes/widgets_themes/text_field_theme.dart';
import 'package:Gixa/utils/themes/widgets_themes/text_theme.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';


class UAppTheme {
  UAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: UColors.primary,
    scaffoldBackgroundColor: UColors.white,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: UColors.primary,
      onPrimary: UColors.white,
      secondary: UColors.primaryLight,
      onSecondary: UColors.white,
      tertiary: UColors.secondary,
      onTertiary: UColors.white,
      error: UColors.error,
      onError: UColors.white,
      surface: UColors.white,
      onSurface: UColors.black,
    ),
    cardColor: UColors.white,
    dividerColor: UColors.border,
    iconTheme: const IconThemeData(color: UColors.primary),
    primaryIconTheme: const IconThemeData(color: UColors.white),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: UColors.primaryDark,
        side: const BorderSide(color: UColors.primaryLight, width: 1.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: UColors.primaryDark),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: UColors.primary,
      foregroundColor: UColors.white,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: UColors.white,
      indicatorColor: UColors.softAccent,
      iconTheme: MaterialStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(MaterialState.selected)
              ? UColors.primaryDark
              : UColors.grey,
        ),
      ),
      labelTextStyle: MaterialStateProperty.resolveWith(
        (states) => TextStyle(
          color: states.contains(MaterialState.selected)
              ? UColors.primaryDark
              : UColors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: UColors.primary,
      linearTrackColor: UColors.softSurface,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: UColors.primary,
      selectionColor: UColors.primaryLight.withOpacity(0.22),
      selectionHandleColor: UColors.primaryDark,
    ),
    textTheme: UTextTheme.lightTextTheme,
    appBarTheme: UAppBarTheme.lightAppBarTheme,
    elevatedButtonTheme: UElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme:
        UTextFormFieldTheme.lightInputDecorationTheme,
    bottomSheetTheme:
        UBottomSheetTheme.lightBottomSheetTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: UColors.primary,
    scaffoldBackgroundColor: UColors.darkSurface,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: UColors.primary,
      onPrimary: UColors.white,
      secondary: UColors.primaryLight,
      onSecondary: UColors.white,
      tertiary: UColors.secondary,
      onTertiary: UColors.white,
      error: UColors.error,
      onError: UColors.white,
      surface: UColors.darkCard,
      onSurface: UColors.white,
    ),
    cardColor: UColors.darkCard,
    dividerColor: UColors.darkBorder,
    iconTheme: const IconThemeData(color: UColors.primaryLight),
    primaryIconTheme: const IconThemeData(color: UColors.white),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: UColors.primaryLight,
        side: const BorderSide(color: UColors.primary, width: 1.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: UColors.primaryLight),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: UColors.primary,
      foregroundColor: UColors.white,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: UColors.darkSurface,
      indicatorColor: UColors.primaryDark.withOpacity(0.35),
      iconTheme: MaterialStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(MaterialState.selected)
              ? UColors.primaryLight
              : UColors.grey,
        ),
      ),
      labelTextStyle: MaterialStateProperty.resolveWith(
        (states) => TextStyle(
          color: states.contains(MaterialState.selected)
              ? UColors.primaryLight
              : UColors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: UColors.primaryLight,
      linearTrackColor: UColors.darkCard,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: UColors.primaryLight,
      selectionColor: UColors.primaryDark.withOpacity(0.35),
      selectionHandleColor: UColors.primary,
    ),
    textTheme: UTextTheme.darkTextTheme,
    appBarTheme: UAppBarTheme.darkAppBarTheme,
    elevatedButtonTheme: UElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme:
        UTextFormFieldTheme.darkInputDecorationTheme,
    bottomSheetTheme:
        UBottomSheetTheme.darkBottomSheetTheme,
  );
}
