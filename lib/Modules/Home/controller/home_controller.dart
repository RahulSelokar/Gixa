import 'package:Gixa/Modules/subscription/features/feature_names.dart';
import 'package:get/get.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';

class HomeController extends GetxController {
  /// User Info
  final name = "Student".obs;
  final exam = "NEET".obs;
  final score = "--".obs;
  final air = "--".obs;

  /// Controllers
  final SubscriptionController subscriptionController =
      Get.find<SubscriptionController>();

  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void onInit() {
    super.onInit();
    // Profile update hone par naam update karo
    ever(profileController.profile, (profile) {
      if (profile != null && profile.user.firstName != null) {
        name.value = profile.user.firstName!;
      }
    });
    // Agar profile pehle se loaded hai to bhi naam set ho
    final p = profileController.profile.value;
    if (p != null && p.user.firstName != null) {
      name.value = p.user.firstName!;
    }

    // HomeController init hote hi profile fetch karo
    profileController.fetchProfile();
  }

  /// Animation
  final isBlinking = true.obs;

  /// FEATURE ACCESS
  bool hasFeature(String feature) {
    return subscriptionController.hasFeature(feature);
  }

  bool isSelectedState(String state) {
    return profileController.stateCtrl.text == state;
  }

  bool canAccessCollegeList() {
    return hasFeature(FeatureNames.selectedStateCollegeList);
  }

  bool canAccessCutoff() {
    return hasFeature(FeatureNames.selectedStateCutoff);
  }

  bool canAccessSeatMatrix() {
    return hasFeature(FeatureNames.selectedStateSeatMatrix);
  }

  bool canAccessPrediction() {
    return hasFeature(FeatureNames.selectedStateCollegePrediction);
  }

  bool canAccessCounsellingSteps() {
    return hasFeature(FeatureNames.counsellingSteps);
  }

  bool canAccessAIQ() {
    return hasFeature(FeatureNames.aiqColleges);
  }

  bool canAccessDeemed() {
    return hasFeature(FeatureNames.deemedColleges);
  }

  bool canAccessManagementQuota() {
    return hasFeature(FeatureNames.managementQuota);
  }

  bool canAccessNRI() {
    return hasFeature(FeatureNames.nriQuota);
  }

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
}
