import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static const String _themeModeKey = 'app_theme_mode';
  final _box = GetStorage();

  final themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    final savedMode = _box.read<String>(_themeModeKey);
    themeMode.value = _parseThemeMode(savedMode);
    Get.changeThemeMode(themeMode.value);
  }

  bool get isDark => themeMode.value == ThemeMode.dark;

  void toggleTheme() {
    themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark;

    _box.write(_themeModeKey, _themeModeToString(themeMode.value));

    /// ✅ INSTANT UI UPDATE
    Get.changeThemeMode(themeMode.value);
  }

  ThemeMode _parseThemeMode(String? value) {
    if (value == null) {
      return ThemeMode.dark;
    }

    if (value == 'dark') {
      return ThemeMode.dark;
    }

    return ThemeMode.light;
  }

  String _themeModeToString(ThemeMode mode) {
    return mode == ThemeMode.dark ? 'dark' : 'light';
  }
}
