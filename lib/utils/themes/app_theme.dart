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
    scaffoldBackgroundColor: UColors.black,
    textTheme: UTextTheme.darkTextTheme,
    appBarTheme: UAppBarTheme.darkAppBarTheme,
    elevatedButtonTheme: UElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme:
        UTextFormFieldTheme.darkInputDecorationTheme,
    bottomSheetTheme:
        UBottomSheetTheme.darkBottomSheetTheme,
  );
}
