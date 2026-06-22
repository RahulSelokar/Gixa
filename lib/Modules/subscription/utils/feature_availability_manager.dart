import 'package:Gixa/Modules/subscription/features/feature_names.dart';
import 'package:Gixa/Modules/subscription/utils/plan_hierarchy.dart';

/// Manages which features are available for each plan tier
/// This allows features to be organized by plan level
class FeatureAvailabilityManager {
  /// Map feature names to the minimum tier required to access them
  static const Map<String, PlanTier> featureTierMap = {
    // ===== FREE/BASIC FEATURES =====
    FeatureNames.collegePrediction: PlanTier.basic,
    FeatureNames.counsellingQuery: PlanTier.basic,
    FeatureNames.aiqColleges: PlanTier.basic,
    FeatureNames.deemedColleges: PlanTier.basic,
    FeatureNames.managementQuota: PlanTier.basic,
    FeatureNames.nriQuota: PlanTier.basic,
    FeatureNames.seatMatrix: PlanTier.basic,
    FeatureNames.cutoff: PlanTier.basic,

    // ===== BASIC PLAN FEATURES =====
    FeatureNames.selectedStateQuota: PlanTier.basic,
    FeatureNames.selectedStateCutoff: PlanTier.basic,
    FeatureNames.selectedStateCollegeList: PlanTier.basic,
    FeatureNames.selectedStateSeatMatrix: PlanTier.basic,
    FeatureNames.counsellingSteps: PlanTier.basic,
    FeatureNames.selectedStateCollegePrediction: PlanTier.basic,
    FeatureNames.selectedStateFeeStructure: PlanTier.basic,

    // ===== CLASSIC PLAN FEATURES =====
    FeatureNames.twoStatePredictionWithAIQDeemed: PlanTier.classic,
    FeatureNames.twoStateSeatMatrix: PlanTier.classic,
    FeatureNames.fullCollegeListAccess: PlanTier.classic,

    // ===== PREMIUM PLAN FEATURES =====
    FeatureNames.fiveStatePrediction: PlanTier.premium,
    FeatureNames.allStateSeatMatrix: PlanTier.premium,
    FeatureNames.managementAndInstitutionalPrediction: PlanTier.premium,
  };

  /// Check if a user can access a specific feature based on their tier
  static bool canAccessFeature(String featureName, PlanTier userTier) {
    final requiredTier = featureTierMap[featureName] ?? PlanTier.premium;
    return PlanHierarchy.canAccessTier(userTier, requiredTier);
  }

  /// Get the minimum tier required for a feature
  static PlanTier getRequiredTierForFeature(String featureName) {
    return featureTierMap[featureName] ?? PlanTier.premium;
  }

  /// Get all features available for a specific tier
  static List<String> getFeaturesForTier(PlanTier tier) {
    return featureTierMap.entries
        .where((entry) => PlanHierarchy.canAccessTier(tier, entry.value))
        .map((entry) => entry.key)
        .toList();
  }

  /// Get features specifically locked for a tier (not available to lower tiers)
  static List<String> getExclusiveFeaturesForTier(PlanTier tier) {
    return featureTierMap.entries
        .where((entry) => entry.value == tier)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get all locked features for a user (features they can't access yet)
  static List<String> getLockedFeaturesForTier(PlanTier userTier) {
    return featureTierMap.entries
        .where((entry) => !PlanHierarchy.canAccessTier(userTier, entry.value))
        .map((entry) => entry.key)
        .toList();
  }

  /// Get the next tier and its exclusive features
  static Map<String, dynamic> getNextTierInfo(PlanTier currentTier) {
    final nextTierIndex = currentTier.index + 1;
    if (nextTierIndex >= PlanTier.values.length) {
      return {'tier': null, 'features': <String>[]};
    }

    final nextTier = PlanTier.values[nextTierIndex];
    return {
      'tier': nextTier,
      'tierName': PlanHierarchy.getTierName(nextTier),
      'features': getExclusiveFeaturesForTier(nextTier),
    };
  }
}
