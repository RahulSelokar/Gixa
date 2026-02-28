import 'package:Gixa/bindings/initial_binding.dart';
import 'package:Gixa/common/Error/error_controller.dart';
import 'package:Gixa/common/Error/network_error.dart';
import 'package:Gixa/common/langauge/app_translations.dart';
import 'package:Gixa/routes/app_pages.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/services/language_service.dart';
import 'package:Gixa/utils/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Gixa extends StatelessWidget {
  const Gixa({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),

      translations: AppTranslations(),
      locale: LanguageService.getInitialLocale(),
      fallbackLocale: const Locale('en'),

      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,

      theme: UAppTheme.lightTheme,
      darkTheme: UAppTheme.darkTheme,

      /// 🔥 IMPORTANT: Use builder safely
      builder: (context, child) {
        return GetBuilder<GlobalErrorController>(
          builder: (controller) {
            if (controller.hasError) {
              return const NetworkErrorScreen();
            }

            return child ?? const SizedBox();
          },
        );
      },
    );
  }
}
