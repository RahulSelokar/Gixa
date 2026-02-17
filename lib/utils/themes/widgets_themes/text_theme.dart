import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';

class UTextTheme {
  UTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.robotoSlab(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: UColors.black,
    ),
    titleMedium: GoogleFonts.robotoSlab(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: UColors.black,
    ),
    bodyMedium: GoogleFonts.robotoSlab(
      fontSize: 14,
      color: UColors.black,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: GoogleFonts.robotoSlab(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: UColors.white,
    ),
    titleMedium: GoogleFonts.robotoSlab(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: UColors.white,
    ),
    bodyMedium: GoogleFonts.robotoSlab(
      fontSize: 14,
      color: UColors.white,
    ),
  );
}
