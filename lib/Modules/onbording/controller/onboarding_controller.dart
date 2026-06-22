import 'package:Gixa/Modules/onbording/model/onboarding_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  var currentIndex = 0.obs;

  final List<OnboardingModel> pages = [
    OnboardingModel(
      title: "Predict the right college faster",
      subtitle: "Smart AI Guidance",
      description:
          "Use your exam rank, category and preferences to discover colleges that actually match your chances.",
      image: "assets/icons/Gixxa1.png",
      badge: "AI Powered",
    ),
    OnboardingModel(
      title: "Explore colleges with confidence",
      subtitle: "Search and Compare",
      description:
          "Check cutoffs, courses, seats and institute details in one place before making a decision.",
      image: "assets/icons/gixxa2.png",
      badge: "Verified Insights",
    ),
    OnboardingModel(
      title: "Track every step of admission",
      subtitle: "Counselling Support",
      description:
          "Stay prepared with counselling help, document guidance and a simpler journey from exam to admission.",
      image: "assets/icons/gixxa4.png",
      badge: "Expert Help",
    ),
    OnboardingModel(
      title: "All your admission tools in one app",
      subtitle: "Made for Students",
      description:
          "From prediction to final shortlist, Gixa helps you plan smarter and move ahead with clarity.",
      image: "assets/icons/gixxa5.png",
      badge: "Get Started",
    ),
  ];

  void nextPage() {
    if (currentIndex.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    pageController.jumpToPage(pages.length - 1);
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
}
