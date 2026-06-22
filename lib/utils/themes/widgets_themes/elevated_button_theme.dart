import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class UElevatedButtonTheme {
  UElevatedButtonTheme._();

  static ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: UColors.primary,
      foregroundColor: UColors.white,
      shadowColor: UColors.primaryLight.withOpacity(0.28),
      elevation: 0,
      side: const BorderSide(color: UColors.primaryDark, width: 1.1),
      textStyle: const TextStyle(fontWeight: FontWeight.w700),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  );

  static ElevatedButtonThemeData darkElevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: UColors.primary,
      foregroundColor: UColors.white,
      shadowColor: UColors.primaryLight.withOpacity(0.32),
      elevation: 0,
      side: const BorderSide(color: UColors.primaryLight, width: 1.1),
      textStyle: const TextStyle(fontWeight: FontWeight.w700),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  );
}
