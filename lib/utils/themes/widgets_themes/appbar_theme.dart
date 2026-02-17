import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class UAppBarTheme {
  UAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: UColors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: UColors.black),
    titleTextStyle: const TextStyle(
      color: UColors.black,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );

  static AppBarTheme darkAppBarTheme = AppBarTheme(
    backgroundColor: UColors.black,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: UColors.white),
    titleTextStyle: const TextStyle(
      color: UColors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );
}
