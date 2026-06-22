import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';

class UTextTheme {
  UTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.robotoSlab(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: UColors.primaryDark,
    ),
    titleMedium: GoogleFonts.robotoSlab(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: UColors.primaryDark,
    ),
    bodyMedium: GoogleFonts.robotoSlab(
      fontSize: 14,
      color: UColors.black,
    ),
    labelLarge: GoogleFonts.robotoSlab(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: UColors.primary,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: GoogleFonts.robotoSlab(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: UColors.primaryLight,
    ),
    titleMedium: GoogleFonts.robotoSlab(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: UColors.primaryLight,
    ),
    bodyMedium: GoogleFonts.robotoSlab(
      fontSize: 14,
      color: UColors.white,
    ),
    labelLarge: GoogleFonts.robotoSlab(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: UColors.primary,
    ),
  );
}
