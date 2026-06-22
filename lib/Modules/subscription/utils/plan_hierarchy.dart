/// Defines the hierarchy of subscription plans
/// Higher hierarchy plans have access to features of lower plans

enum PlanTier {
  free, // No paid features
  basic, // Basic features
  classic, // Basic + Classic features
  premium,
  vip, // All features
}

class PlanHierarchy {
  /// 🔥 MAIN FUNCTION (FINAL FIX)
  /// Supports:
  /// - "Classic Plan"
  /// - "classic"
  /// - 2
  /// - "2"
  static PlanTier getTier(dynamic input) {
    if (input == null) {
      print("⚠️ plan input null → FREE");
      return PlanTier.free;
    }

    print("🧠 RAW PLAN INPUT: $input");

    /// 🔥 CASE 1: INTEGER (MOST IMPORTANT FIX)
    if (input is int) {
      switch (input) {
        case 1:
          print("✅ DETECTED: BASIC (int)");
          return PlanTier.basic;
        case 2:
          print("✅ DETECTED: CLASSIC (int)");
          return PlanTier.classic;
        case 3:
          print("✅ DETECTED: PREMIUM (int)");
          return PlanTier.premium;
        default:
          print("❌ UNKNOWN INT → FREE");
          return PlanTier.free;
      }
    }

    /// 🔥 CASE 2: STRING
    final value = input.toString().toLowerCase().trim();

    print("🧠 NORMALIZED VALUE: $value");

    /// 🔥 STRING NUMBER ("2")
    if (value == "1") return PlanTier.basic;
    if (value == "2") return PlanTier.classic;
    if (value == "3") return PlanTier.premium;

    /// 🔥 STRING NAME
    if (value.contains("premium")) {
      print("✅ DETECTED: PREMIUM (name)");
      return PlanTier.premium;
    }

    if (value.contains("classic")) {
      print("✅ DETECTED: CLASSIC (name)");
      return PlanTier.classic;
    }

    if (value.contains("basic")) {
      print("✅ DETECTED: BASIC (name)");
      return PlanTier.basic;
    }

    if (value.contains("free")) {
      print("✅ DETECTED: FREE (name)");
      return PlanTier.free;
    }

    /// 🔥 STRING NAME
    if (value.contains("vip")) {
      print("✅ DETECTED: VIP (name)");
      return PlanTier.vip;
    }

    /// ❌ FINAL FALLBACK
    print("❌ UNKNOWN PLAN → FREE");
    return PlanTier.free;
  }

  /// 🔥 Helper for full plan object (BEST USAGE)
  static PlanTier getTierFromPlan({dynamic planCode, String? planName}) {
    /// Priority: name > code
    if (planName != null && planName.isNotEmpty) {
      final tier = getTier(planName);
      if (tier != PlanTier.free) return tier;
    }

    return getTier(planCode);
  }

  /// Check if userTier can access features of requiredTier
  static bool canAccessTier(PlanTier userTier, PlanTier requiredTier) {
    return userTier.index >= requiredTier.index;
  }

  /// Get user-friendly name
  static String getTierName(PlanTier tier) {
    switch (tier) {
      case PlanTier.free:
        return 'Free';
      case PlanTier.basic:
        return 'Basic';
      case PlanTier.classic:
        return 'Classic';
      case PlanTier.premium:
        return 'Premium';
      case PlanTier.vip:
        return 'VIP';
    }
  }

  /// Check if tier is paid
  static bool isPaidTier(PlanTier tier) {
    return tier != PlanTier.free;
  }

  /// 🔥 DEBUG HELPER
  static void debugTier({dynamic planCode, String? planName}) {
    final tier = getTierFromPlan(planCode: planCode, planName: planName);

    print("📊 FINAL TIER: $tier");
  }
}
