import 'package:get/get.dart';

class HomeController extends GetxController {
  /// User Info (later from API)
  final name = "Student".obs;
  final exam = "NEET".obs;
  final score = "--".obs;
  final air = "--".obs;

  /// Subscription
  final isPremium = false.obs;

  /// Animation
  final isBlinking = true.obs;

  void updateProfile({
    required String name,
    required String exam,
    required String score,
    required String air,
  }) {
    this.name.value = name;
    this.exam.value = exam;
    this.score.value = score;
    this.air.value = air;
  }

  void upgradePlan() {
    isPremium.value = true;
  }
}
