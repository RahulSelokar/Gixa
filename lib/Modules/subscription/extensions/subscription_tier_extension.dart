import 'package:Gixa/Modules/subscription/controller/subsciption_history_controller.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/Modules/subscription/utils/plan_hierarchy.dart';
import 'package:Gixa/Modules/subscription/utils/feature_availability_manager.dart';
import 'package:Gixa/services/app_verification_controller.dart';
import 'package:get/get.dart';

/// Extension to add tier-based feature checking to SubscriptionController
extension SubscriptionTierExtension on SubscriptionController {
  PlanTier get currentPlanTier {
    final historyController = Get.isRegistered<SubscriptionHistoryController>()
        ? Get.find<SubscriptionHistoryController>()
        : null;

    PlanTier highestTier = PlanTier.free;

    if (historyController != null && historyController.historyList.isNotEmpty) {
      for (final history in historyController.historyList) {
        if (history.isActive && !history.isExpired) {
          final tier = PlanHierarchy.getTierFromPlan(
            planName: history.plan.planName,
            planCode: history.plan.planCode,
          );
          if (PlanHierarchy.canAccessTier(tier, highestTier)) {
            highestTier = tier;
          }
        }
      }
    }

    if (highestTier != PlanTier.free) {
      return highestTier;
    }

    final plan = activePlan.value;
    if (plan == null) {
      print("❌ No active plan → FREE");
      return PlanTier.free;
    }

    return PlanHierarchy.getTierFromPlan(
      planName: plan.planName,
      planCode: plan.planCode,
    );
  }

  /// 🔥 Check if user can access a feature based on plan hierarchy
  bool canAccessFeature(String featureName) {
    if (AppVerificationController.to.hideSubscriptionUi) return true;

    final tier = currentPlanTier;

    print("🎯 CHECK FEATURE: $featureName");
    print("🎯 USER TIER: $tier");

    final result = FeatureAvailabilityManager.canAccessFeature(
      featureName,
      tier,
    );

    print("🎯 ACCESS RESULT: $result");

    return result;
  }

  /// Get the minimum tier required for a feature
  PlanTier getFeatureRequiredTier(String featureName) {
    return FeatureAvailabilityManager.getRequiredTierForFeature(featureName);
  }

  /// Check if user needs to upgrade for a feature
  bool needsUpgradeForFeature(String featureName) {
    return !canAccessFeature(featureName);
  }

  /// Get all available features for current plan
  List<String> getAvailableFeatures() {
    return FeatureAvailabilityManager.getFeaturesForTier(currentPlanTier);
  }

  /// Get locked features
  List<String> getLockedFeatures() {
    return FeatureAvailabilityManager.getLockedFeaturesForTier(currentPlanTier);
  }

  /// Get next tier upgrade information
  Map<String, dynamic> getNextTierUpgradeInfo() {
    return FeatureAvailabilityManager.getNextTierInfo(currentPlanTier);
  }

  /// Check if user is on a specific tier
  bool isOnTier(PlanTier tier) {
    return currentPlanTier == tier;
  }

  /// Check if user is on or above a specific tier
  bool isOnOrAboveTier(PlanTier tier) {
    return PlanHierarchy.canAccessTier(currentPlanTier, tier);
  }

  /// Get locked feature count
  int getLockedFeatureCount() {
    return getLockedFeatures().length;
  }

  /// Get available feature count
  int getAvailableFeatureCount() {
    return getAvailableFeatures().length;
  }
}
