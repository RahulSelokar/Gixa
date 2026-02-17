import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  final themeMode = ThemeMode.system.obs;

  bool get isDark =>
      themeMode.value == ThemeMode.dark ||
      (themeMode.value == ThemeMode.system &&
          Get.isPlatformDarkMode);

  void toggleTheme() {
    // Cycle: System → Light → Dark → System
    if (themeMode.value == ThemeMode.system) {
      themeMode.value = ThemeMode.light;
    } else if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.system;
    }
  }
}
