import 'dart:async';
import 'package:Gixa/Modules/dailyUpdates/model/daily_update_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class UpdatesController extends GetxController {
  final updates = <UpdateModel>[].obs;
  final pageController = PageController(viewportFraction: 0.88);
  var currentPage = 0.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _loadUpdates();
    _startAutoScroll();
  }

  void _loadUpdates() {
    updates.assignAll([
      UpdateModel(
        id: "1",
        title: "NEET PG Counselling Round 2",
        description: "New seat matrix released. Check now.",
        type: UpdateType.alert,
      ),
      UpdateModel(
        id: "2",
        title: "Profile Boost Offer",
        description: "Complete profile & get higher chances.",
        type: UpdateType.offer,
      ),
      UpdateModel(
        id: "3",
        title: "Top Colleges Trending",
        description: "AIIMS & GMCs cutoff dropped this year.",
        type: UpdateType.news,
      ),
      UpdateModel(
        id: "4",
        title: "Premium Guidance",
        description: "1-to-1 counselling now available.",
        type: UpdateType.promo,
      ),
    ]);
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (updates.isEmpty) return;

      currentPage.value =
          (currentPage.value + 1) % updates.length;

      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
