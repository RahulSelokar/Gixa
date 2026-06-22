import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class UTextFormFieldTheme {
  UTextFormFieldTheme._();

  static OutlineInputBorder _defaultBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: color, width: 1.2),
  );
}


  static OutlineInputBorder _focusedBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: 1.4),
    );
  }

  static OutlineInputBorder _errorBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: 1.4),
    );
  }

  /// 🌞 LIGHT THEME
  static InputDecorationTheme lightInputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: UColors.softSurface,
    border: _defaultBorder(UColors.border),
    enabledBorder: _defaultBorder(UColors.border),
    focusedBorder: _focusedBorder(UColors.primary),
    errorBorder: _errorBorder(UColors.error),
    focusedErrorBorder: _errorBorder(UColors.error),
    labelStyle: const TextStyle(color: UColors.primaryDark),
    floatingLabelStyle: const TextStyle(color: UColors.primaryDark),
    hintStyle: TextStyle(color: UColors.grey.withOpacity(0.9)),
    prefixIconColor: UColors.primary,
    suffixIconColor: UColors.primaryLight,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  /// 🌙 DARK THEME
  static InputDecorationTheme darkInputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: UColors.darkCard,
    border: _defaultBorder(UColors.darkBorder),
    enabledBorder: _defaultBorder(UColors.darkBorder),
    focusedBorder: _focusedBorder(UColors.primaryLight),
    errorBorder: _errorBorder(UColors.error),
    focusedErrorBorder: _errorBorder(UColors.error),
    labelStyle: const TextStyle(color: UColors.primaryLight),
    floatingLabelStyle: const TextStyle(color: UColors.primaryLight),
    hintStyle: TextStyle(color: UColors.grey.withOpacity(0.95)),
    prefixIconColor: UColors.primary,
    suffixIconColor: UColors.primaryLight,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}
