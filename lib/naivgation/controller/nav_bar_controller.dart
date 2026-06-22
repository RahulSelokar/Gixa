import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/rendering.dart';
import 'package:Gixa/services/auth_guard.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Gixa/Modules/Auth/Veiw/login_bottom_sheet.dart';
import 'package:Gixa/Modules/Auth/controllers/otp_controller.dart';

class MainNavController extends GetxController {
  final currentIndex = 0.obs;
  final isBottomBarVisible = true.obs;
  final pendingSubscriptionPopup = false.obs;

  void requestSubscriptionPopup() {
    pendingSubscriptionPopup.value = true;
  }

  void consumeSubscriptionPopupRequest() {
    pendingSubscriptionPopup.value = false;
  }

  void updateScroll(ScrollDirection direction) {
    isBottomBarVisible.value = true;
  }

  void changeTab(int index) async {
    // Home tab always allowed
    if (index == 0) {
      currentIndex.value = index;
      isBottomBarVisible.value = true;
      return;
    }

    final isRegistered = GetStorage().read('registration_completed') == true;
    if (isRegistered) {
      currentIndex.value = index;
      isBottomBarVisible.value = true;
    } else {
      await showAuthBottomSheet(
        LoginBottomSheet(
          onAuthenticated: () {
            // After login, always stay on home tab (0)
            currentIndex.value = 0;
            isBottomBarVisible.value = true;
          },
        ),
      );
    }
  }
}
