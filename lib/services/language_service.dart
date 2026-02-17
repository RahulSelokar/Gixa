import 'dart:ui';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class LanguageService {
  static final _box = GetStorage();
  static const _key = 'language_code';

  /// ✅ DEFAULT = ENGLISH
  static Locale getInitialLocale() {
    final String? code = _box.read(_key);
    return Locale(code ?? 'en');
  }

  /// 🔥 SAVE + APPLY LANGUAGE INSTANTLY
  static void changeLanguage(String code) {
    final locale = Locale(code);

    // Save to local storage
    _box.write(_key, code);

    // 🚀 Apply instantly across the app
    Get.updateLocale(locale);
  }

  /// Optional helper
  static String get currentLanguage =>
      _box.read(_key) ?? 'en';
}
