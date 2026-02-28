import 'package:Gixa/Modules/Collage/veiw/collage_list_page.dart';
import 'package:Gixa/Modules/Home/Veiw/home_page.dart';
import 'package:Gixa/Modules/Profile/views/profile_screen.dart';
import 'package:Gixa/Modules/settings/view/settings_page.dart';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
import 'package:Gixa/naivgation/veiw/modern_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainNavPage extends StatelessWidget {
  MainNavPage({super.key});

  final controller = Get.put(MainNavController());

  // Define pages matching the indices in BottomNav
  final List<Widget> pages = [
    const HomePage(), // Index 0
    CollegeListPage(), // Index 1
    // ProfilePage(), // Index 2 (Changed from 3 to match list size)
    AccountManageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PopScope(
        canPop: false,
        child: Scaffold(
          // Important: extends body behind the floating nav bar
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          ),
          bottomNavigationBar: Obx(() {
            return AnimatedSlide(
              offset: controller.isBottomBarVisible.value
                  ? Offset.zero
                  : const Offset(0, 1),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: controller.isBottomBarVisible.value ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: ModernBottomNav(
                  currentIndex: controller.currentIndex.value,
                  onTap: controller.changeTab,
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
