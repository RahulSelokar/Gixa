import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/rendering.dart';
import 'package:Gixa/services/auth_guard.dart';

class MainNavController extends GetxController {
  final currentIndex = 0.obs;
  final isBottomBarVisible = true.obs;

  void updateScroll(ScrollDirection direction) {
    if (direction == ScrollDirection.reverse && isBottomBarVisible.value) {
      isBottomBarVisible.value = false;
    } else if (direction == ScrollDirection.forward &&
        !isBottomBarVisible.value) {
      isBottomBarVisible.value = true;
    }
  }

  void changeTab(int index) {
    // Home tab always allowed
    if (index == 0) {
      currentIndex.value = index;
      isBottomBarVisible.value = true;
      return;
    }

    // Colleges & Profile require login
    // AuthGuard.checkAccess(() {
    //   currentIndex.value = index;
    //   isBottomBarVisible.value = true;
    // });
    AuthGuard.checkAccess(
      onAllowed: () {
        currentIndex.value = index;
        isBottomBarVisible.value = true;
      },
    );
  }
}