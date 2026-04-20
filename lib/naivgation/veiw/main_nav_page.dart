import 'package:Gixa/Modules/Collage/veiw/collage_list_page.dart';
import 'package:Gixa/Modules/Home/Veiw/home_page.dart';
import 'package:Gixa/Modules/Home/controller/home_controller.dart';
import 'package:Gixa/Modules/Profile/views/profile_screen.dart';
import 'package:Gixa/Modules/settings/view/settings_page.dart';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
import 'package:Gixa/naivgation/veiw/modern_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class MainNavPage extends StatefulWidget {
  MainNavPage({super.key});

  @override
  State<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  final controller = Get.put(MainNavController());
  final List<Widget> pages = [
    GetBuilder<HomeController>(
      init: HomeController(),
      builder: (_) => const HomePage(),
    ),
    CollegeListPage(),
    AccountManageScreen(),
  ];

  DateTime? _lastBackPressed;

  Future<bool> _onWillPop() async {
    if (controller.currentIndex.value != 0) {
      controller.currentIndex.value = 0;
      return false;
    }
    final now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      Toast.show(
        "Press back again to exit",
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
        backgroundColor: Colors.black87,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        // borderRadius: 8,
      );
      return false;
    }
    // Exit the app
    await SystemNavigator.pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Obx(() {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
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
