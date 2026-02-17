import 'package:Gixa/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../routes/app_routes.dart';
import '../../utils/themes/theme_controller.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSearch;
  final bool showNotification;
  final bool showLogo;

  const AppAppBar({
    super.key,
    required this.title,
    this.showSearch = true,
    this.showNotification = true,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.find<ThemeController>();

    return AppBar(
      centerTitle: false,
      titleSpacing: 16,
      elevation: theme.appBarTheme.elevation,

      /// 🔹 LOGO + TITLE
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLogo) ...[
            Icon(
              EvaIcons.bookOpenOutline,
              size: 28,
              color: UColors.primary,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: theme.appBarTheme.titleTextStyle?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),

      /// 🔔 ACTION ICONS
      actions: [
        /// 🌗 THEME TOGGLE (System → Light → Dark)
        Obx(() {
          IconData icon;

          if (themeController.themeMode.value == ThemeMode.system) {
            icon = Icons.settings_brightness;
          } else if (themeController.themeMode.value == ThemeMode.dark) {
            icon = EvaIcons.sunOutline;
          } else {
            icon = EvaIcons.moonOutline;
          }

          return IconButton(
            icon: Icon(icon),
            tooltip: 'Change theme',
            onPressed: themeController.toggleTheme,
          );
        }),

        if (showSearch)
          IconButton(
            icon: const Icon(EvaIcons.searchOutline),
            onPressed: () => Get.toNamed(AppRoutes.search),
          ),

        if (showNotification)
          IconButton(
            icon: const Icon(EvaIcons.bellOutline),
            onPressed: () => Get.toNamed(AppRoutes.notifications),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
