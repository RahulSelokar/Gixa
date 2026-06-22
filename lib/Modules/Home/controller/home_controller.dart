import 'dart:async';

import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/Modules/subscription/extensions/subscription_tier_extension.dart';
import 'package:Gixa/Modules/subscription/features/feature_names.dart';
import 'package:Gixa/Modules/subscription/model/subscription_plan.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:Gixa/services/token_services.dart';

class HomeController extends GetxController {
  final GetStorage _box = GetStorage();
  final name = "Student".obs;
  final exam = "NEET".obs;
  final score = "--".obs;
  final air = "--".obs;

  /// ✅ ALWAYS use existing controller (IMPORTANT FIX)
  final SubscriptionController subscriptionController =
      Get.find<SubscriptionController>();

  final ProfileController profileController = Get.find<ProfileController>();

  var showGenieIntro = true.obs;

  void hideGenieIntro() {
    showGenieIntro.value = false;
  }

  /// 🔥 Show only upgrade plans
  List<SubscriptionPlan> getVisiblePlans(
    List<SubscriptionPlan> allPlans,
    SubscriptionPlan? activePlan,
  ) {
    if (activePlan == null) return allPlans;

    final currentIndex = allPlans.indexWhere(
      (p) => p.planCode == activePlan.planCode,
    );

    if (currentIndex == -1) return allPlans;

    return allPlans.sublist(currentIndex + 1);
  }

  @override
  void onInit() {
    super.onInit();

    /// 👤 Sync profile name
    ever(profileController.profile, (profile) {
      if (profile != null && profile.user.firstName != null) {
        name.value = profile.user.firstName!;
      }
    });

    final p = profileController.profile.value;
    if (p != null && p.user.firstName != null) {
      name.value = p.user.firstName!;
    }

    unawaited(_warmUpHomeData());
  }

  final isBlinking = true.obs;

  /// 🔥 Ensure data ready
  Future<void> _warmUpHomeData() async {
    final isRegistered = _box.read('registration_completed') == true;
    if (!isRegistered) return;

    final accessToken = await TokenService.getAccessToken();
    final refreshToken = await TokenService.getRefreshToken();
    final hasAnyToken =
        (accessToken != null && accessToken.trim().isNotEmpty) ||
        (refreshToken != null && refreshToken.trim().isNotEmpty);

    if (!hasAnyToken) return;

    await profileController.ensureLoaded();

    await subscriptionController.ensureActivePlanReady(
      forceRefresh: subscriptionController.activePlan.value == null,
    );

    /// 🔥 Debug (optional)
    print("🔥 ACTIVE PLAN: ${subscriptionController.activePlan.value}");
    print("🔥 CURRENT TIER: ${subscriptionController.currentPlanTier}");
  }

  // =========================================================
  // 🧠 STATE HELPERS
  // =========================================================

  bool isSelectedState(String state) {
    return profileController.stateCtrl.text == state;
  }

  // =========================================================
  // 🔥 TIER-BASED FEATURE ACCESS (FINAL FIX)
  // =========================================================

  bool canAccessCollegeList() {
    return subscriptionController.canAccessFeature(
      FeatureNames.selectedStateCollegeList,
    );
  }

  bool canAccessCutoff() {
    return subscriptionController.canAccessFeature(
      FeatureNames.selectedStateCutoff,
    );
  }

  bool canAccessSeatMatrix() {
    return subscriptionController.canAccessFeature(
      FeatureNames.selectedStateSeatMatrix,
    );
  }

  bool canAccessPrediction() {
    return subscriptionController.canAccessFeature(
      FeatureNames.selectedStateCollegePrediction,
    );
  }

  Future<bool> canAccessPredictionAfterSync() async {
    await subscriptionController.ensureActivePlanReady(
      forceRefresh: true,
    );

    return subscriptionController.canAccessFeature(
      FeatureNames.selectedStateCollegePrediction,
    );
  }

  bool canAccessCounsellingSteps() {
    return subscriptionController.canAccessFeature(
      FeatureNames.counsellingSteps,
    );
  }

  bool canAccessAIQ() {
    return subscriptionController.canAccessFeature(
      FeatureNames.aiqColleges,
    );
  }

  bool canAccessDeemed() {
    return subscriptionController.canAccessFeature(
      FeatureNames.deemedColleges,
    );
  }

  bool canAccessManagementQuota() {
    return subscriptionController.canAccessFeature(
      FeatureNames.managementQuota,
    );
  }

  bool canAccessNRI() {
    return subscriptionController.canAccessFeature(
      FeatureNames.nriQuota,
    );
  }

  // =========================================================
  // ✏️ PROFILE UPDATE
  // =========================================================

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
