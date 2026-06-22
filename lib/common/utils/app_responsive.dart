import 'package:flutter/widgets.dart';

class AppResponsive {
  AppResponsive._();

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static bool isTablet(BuildContext context) => width(context) >= 600;

  static bool isLargeTablet(BuildContext context) => width(context) >= 900;

  static double horizontalPadding(BuildContext context) {
    final screenWidth = width(context);
    if (screenWidth >= 1200) return 40;
    if (screenWidth >= 900) return 32;
    if (screenWidth >= 600) return 24;
    return 20;
  }

  static double maxContentWidth(BuildContext context) {
    final screenWidth = width(context);
    if (screenWidth >= 1200) return 1180;
    if (screenWidth >= 900) return 1040;
    if (screenWidth >= 600) return 920;
    return screenWidth;
  }

  static int categoryGridColumns(double width) {
    if (width >= 1100) return 6;
    if (width >= 760) return 4;
    return 3;
  }
}
