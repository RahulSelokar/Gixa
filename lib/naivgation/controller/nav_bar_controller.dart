import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/rendering.dart';

class MainNavController extends GetxController {
  final currentIndex = 0.obs;

  final isBottomBarVisible = true.obs;

  void updateScroll(ScrollDirection direction) {
    if (direction == ScrollDirection.reverse) {
      isBottomBarVisible.value = false; 
    } else if (direction == ScrollDirection.forward) {
      isBottomBarVisible.value = true; 
    }
  }

  void changeTab(int index) {
    currentIndex.value = index;

    isBottomBarVisible.value = true;
  }
}
