import 'package:Gixa/bindings/initial_binding.dart';
import 'package:Gixa/common/Error/error_controller.dart';
import 'package:Gixa/common/Error/network_error.dart';
import 'package:Gixa/common/langauge/app_translations.dart';
import 'package:Gixa/routes/app_pages.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/services/language_service.dart';
import 'package:Gixa/utils/themes/app_theme.dart';
import 'package:Gixa/utils/themes/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class Gixa extends StatelessWidget {
  const Gixa({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.isRegistered<ThemeController>()
        ? Get.find<ThemeController>()
        : Get.put(ThemeController(), permanent: true);

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: InitialBinding(),

        translations: AppTranslations(),
        locale: LanguageService.getInitialLocale(),
        fallbackLocale: const Locale('en'),

        initialRoute: AppRoutes.splash,
        getPages: AppPages.routes,

        theme: UAppTheme.lightTheme,
        darkTheme: UAppTheme.darkTheme,
        themeMode: themeController.themeMode.value,

        /// 🔥 IMPORTANT: Use builder safely
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);
          final bottomSafeInset = math.max(
            mediaQuery.viewPadding.bottom,
            8.0,
          );

          return GetBuilder<GlobalErrorController>(
            builder: (controller) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  MediaQuery(
                    data: mediaQuery.copyWith(
                      padding: mediaQuery.padding.copyWith(
                        bottom: bottomSafeInset,
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      left: false,
                      right: false,
                      bottom: true,
                      minimum: const EdgeInsets.only(bottom: 8),
                      maintainBottomViewPadding: true,
                      child: child ?? const SizedBox(),
                    ),
                  ),
                  if (controller.hasError) const NetworkErrorScreen(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
