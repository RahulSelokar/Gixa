import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class UAppBarTheme {
  UAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: UColors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: UColors.primaryDark),
    titleTextStyle: const TextStyle(
      color: UColors.primaryDark,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );

  static AppBarTheme darkAppBarTheme = AppBarTheme(
    backgroundColor: UColors.darkSurface,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: UColors.primaryLight),
    titleTextStyle: const TextStyle(
      color: UColors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );
}
