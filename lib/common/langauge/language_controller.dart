import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:ui';

class LanguageController extends GetxController {
  final _box = GetStorage();

  final Rx<Locale> locale = const Locale('en').obs;

  @override
  void onInit() {
    super.onInit();

    final savedLang = _box.read('language_code') ?? 'en';
    locale.value = Locale(savedLang);
    Get.updateLocale(locale.value);
  }

  void changeLanguage(String languageCode) {
    final newLocale = Locale(languageCode);

    locale.value = newLocale;
    _box.write('language_code', languageCode);

    // 🔥 THIS IS THE KEY LINE
    Get.updateLocale(newLocale);
  }
}
