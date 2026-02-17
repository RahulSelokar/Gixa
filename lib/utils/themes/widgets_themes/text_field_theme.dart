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
    fillColor: Colors.white,

    /// ✅ CURVED SHAPE WITHOUT BORDER
    border: _defaultBorder(Colors.black),
    enabledBorder: _defaultBorder(Colors.black),

    /// ✅ BORDER ONLY ON FOCUS
    focusedBorder: _focusedBorder(UColors.primary),

    /// ❌ ERROR STATE
    errorBorder: _errorBorder(UColors.error),
    focusedErrorBorder: _errorBorder(UColors.error),

    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  /// 🌙 DARK THEME
  static InputDecorationTheme darkInputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: UColors.darkGrey,

    /// ✅ CURVED SHAPE WITHOUT BORDER
     border: _defaultBorder(Colors.white),
    enabledBorder: _defaultBorder(Colors.white),

    /// ✅ BORDER ONLY ON FOCUS
    focusedBorder: _focusedBorder(UColors.primaryLight),

    /// ❌ ERROR STATE
    errorBorder: _errorBorder(UColors.error),
    focusedErrorBorder: _errorBorder(UColors.error),

    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}
