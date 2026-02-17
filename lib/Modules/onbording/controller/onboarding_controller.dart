import 'package:Gixa/Modules/onbording/model/onboarding_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  var currentIndex = 0.obs;

  final List<OnboardingModel> pages = [
    OnboardingModel(
      title: "AI College Prediction",
      description:
          "Get accurate college predictions based on your NEET/JEE rank, category and state.",
      lottie: "assets/lottie/AiData.json",
    ),
    OnboardingModel(
      title: "Explore & Compare Colleges",
      description:
          "Search, filter and compare colleges by fees, cutoffs, seats and ratings.",
      lottie: "assets/lottie/Search_Doctor.json",
    ),
    OnboardingModel(
      title: "Personal Counselling Assistance",
      description:
          "Get 1-to-1 expert guidance and track your admission process step by step.",
      lottie: "assets/lottie/OnlineLearning.json",
    ),
    OnboardingModel(
      title: "Unlock With Subscription",
      description:
          "Subscribe to unlock rank prediction, state selection and counselling support.",
      lottie: "assets/lottie/premium.json",
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
