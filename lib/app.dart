import 'package:Gixa/common/langauge/app_translations.dart';
import 'package:Gixa/routes/app_pages.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/routes/app_start_controller.dart';
import 'package:Gixa/services/language_service.dart';
import 'package:Gixa/utils/themes/app_theme.dart';
import 'package:Gixa/utils/themes/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Gixa extends StatelessWidget {
  const Gixa({super.key});

  @override
  Widget build(BuildContext context) {
    /// ✅ Global Controllers (once)
    Get.put(ThemeController(), permanent: true);
    Get.put(AppStartController(), permanent: true);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      /// 🌍 MULTI-LANGUAGE SUPPORT
      translations: AppTranslations(),
      locale: LanguageService.getInitialLocale(), // ✅ FIXED
      fallbackLocale: const Locale('en'),

      /// 🚀 ALWAYS START WITH SPLASH
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,

      /// 🎨 THEMES
      theme: UAppTheme.lightTheme,
      darkTheme: UAppTheme.darkTheme,
      themeMode: Get.find<ThemeController>().themeMode.value,
    );
  }
}
