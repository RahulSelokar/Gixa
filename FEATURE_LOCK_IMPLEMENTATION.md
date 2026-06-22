# Feature Lock/Unlock System Implementation Guide

## Overview

This guide explains how to implement feature lock/unlock functionality based on subscription plans in your Flutter app.

## What's Been Created

### 1. **Plan Hierarchy System** (`plan_hierarchy.dart`)

- Defines plan tiers: `free`, `basic`, `classic`, `premium`
- Hierarchy ensures Premium users can access Classic and Basic features
- Maps plan codes to tiers

**Usage:**

```dart
final userTier = PlanHierarchy.getTierForPlanCode('premium');
final canAccess = PlanHierarchy.canAccessTier(userTier, PlanTier.classic);
```

### 2. **Feature Availability Manager** (`feature_availability_manager.dart`)

- Maps each feature to its required minimum tier
- Provides methods to check feature access
- Gets features by tier

**Usage:**

```dart
// Check if user can access feature
bool accessible = FeatureAvailabilityManager.canAccessFeature(
  'Five State Prediction',
  userTier,
);

// Get all available features for a tier
List<String> features = FeatureAvailabilityManager.getFeaturesForTier(
  PlanTier.classic,
);

// Get locked features
List<String> locked = FeatureAvailabilityManager.getLockedFeaturesForTier(
  userTier,
);
```

### 3. **UI Widgets** (`feature_display_widgets.dart`)

Three main widgets:

#### FeatureItem

Shows individual feature with lock/unlock icon

```dart
FeatureItem(
  featureName: 'Five State Prediction',
  userTier: userTier,
  onLockedTap: () => Get.toNamed('/subscription-plans'),
)
```

#### FeatureSection

Shows a group of features by tier with upgrade prompt

```dart
FeatureSection(
  sectionTitle: 'Premium Features',
  features: premiumFeatures,
  userTier: userTier,
  sectionTier: PlanTier.premium,
  onUpgradeTap: () => Get.toNamed('/subscription-plans'),
)
```

#### FeatureComparison

Shows all features organized by tier

```dart
FeatureComparison(
  userTier: userTier,
  onUpgradeTap: () => navigateToSubscription(),
)
```

### 4. **Subscription Controller Extension** (`subscription_tier_extension.dart`)

Adds tier-aware methods to your SubscriptionController

**Usage:**

```dart
// In any page
final controller = Get.find<SubscriptionController>();

// Check if can access feature
if (controller.canAccessFeature('Five State Prediction')) {
  // Show feature
}

// Get current tier
final tier = controller.currentPlanTier;

// Check upgrade needed
if (controller.needsUpgradeForFeature('Premium Feature')) {
  showUpgradePrompt();
}

// Get counts
int available = controller.getAvailableFeatureCount();
int locked = controller.getLockedFeatureCount();
```

### 5. **Example Page** (`feature_management_page.dart`)

Shows complete example of using the feature system

## Integration Steps

### Step 1: Import and Use Extension

In your pages that need to show features:

```dart
import 'package:Gixa/Modules/subscription/extensions/subscription_tier_extension.dart';

// Now you can use:
final tier = controller.currentPlanTier;
bool hasAccess = controller.canAccessFeature('Feature Name');
```

### Step 2: Check Feature Access Before Showing

In your feature-gated sections:

```dart
Obx(() {
  if (!controller.canAccessFeature('Five State Prediction')) {
    return LockedFeatureWidget(
      onUpgrade: () => Get.toNamed('/subscription-plans'),
    );
  }

  return YourFeatureWidget();
})
```

### Step 3: Show Locked Features in UI

Use the widgets in your plans comparison:

```dart
FeatureComparison(
  userTier: controller.currentPlanTier,
  onUpgradeTap: () => Get.toNamed('/subscription-plans'),
  accentColor: Colors.blue,
)
```

### Step 4: Update Feature Names Mapping

In `feature_availability_manager.dart`, the `featureTierMap` already has your features mapped.
If you add new features:

```dart
static const Map<String, PlanTier> featureTierMap = {
  FeatureNames.yourNewFeature: PlanTier.classic,
  // ... rest of features
};
```

## File Structure

```
lib/Modules/subscription/
├── utils/
│   ├── plan_hierarchy.dart              # NEW - Plan tier hierarchy
│   └── feature_availability_manager.dart # NEW - Feature access logic
├── extensions/
│   └── subscription_tier_extension.dart # NEW - Controller extension
├── widgets/
│   └── feature_display_widgets.dart     # NEW - UI components
├── view/
│   ├── subscription_plan_page.dart      # EXISTING
│   ├── feature_management_page.dart     # NEW - Example page
│   └── ...
└── features/
    └── feature_names.dart               # EXISTING - Feature constants
```

## Key Concepts

### Plan Hierarchy

- **Free** (0): No features
- **Basic** (1): Basic features only
- **Classic** (2): Basic + Classic features
- **Premium** (3): All features

Premium users automatically have access to Classic and Basic features.

### Feature Mapping

Each feature has a minimum required tier in `featureTierMap`:

```
- Feature -> Minimum Required Tier
- "Five State Prediction" -> PlanTier.premium
- "Two State Prediction" -> PlanTier.classic
- "Selected State Prediction" -> PlanTier.basic
```

### Access Check

```dart
// For a Premium user (tier=3) accessing a Classic feature (req=2):
canAccessTier(3, 2) // true ✓

// For a Basic user (tier=1) accessing a Premium feature (req=3):
canAccessTier(1, 3) // false ✗
```

## Usage Examples

### Example 1: Feature Gate in Prediction Module

```dart
// In your prediction feature
class PredictionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();

    return Obx(() {
      if (!controller.canAccessFeature(FeatureNames.fiveStatePrediction)) {
        return UpgradePromptWidget(
          requiredTier: controller.getFeatureRequiredTier(
            FeatureNames.fiveStatePrediction
          ),
        );
      }

      return PredictionFormWidget();
    });
  }
}
```

### Example 2: Show Next Tier Benefits

```dart
void showUpgradePrompt() {
  final controller = Get.find<SubscriptionController>();
  final nextTierInfo = controller.getNextTierUpgradeInfo();

  Get.dialog(
    AlertDialog(
      title: Text('Unlock More Features'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Upgrade to ${nextTierInfo['tierName']}'),
          Text('Get ${(nextTierInfo['features'] as List).length} new features'),
          ...
        ],
      ),
    ),
  );
}
```

### Example 3: Display Feature Comparison Table

```dart
// In your subscription_plan_page.dart, add:
FeatureComparison(
  userTier: controller.currentPlanTier,
  showLockedOnly: false, // Show all features
  onUpgradeTap: () => controller.createOrderAndPay(planId),
  accentColor: Colors.blue,
)
```

## Best Practices

1. **Always check before showing**: Use `canAccessFeature()` before displaying feature
2. **Show clear UX**: Use lock icons and "Upgrade" prompts for locked features
3. **Guide to upgrade**: Provide easy navigation to subscription page
4. **Hierarchy matters**: Remember Premium users have all features
5. **Keep mapping updated**: Update `featureTierMap` when adding features

## Troubleshooting

### Features showing as locked when they shouldn't

- Check plan code mapping in `plan_hierarchy.dart`
- Verify feature name in `featureTierMap`
- Ensure plan is saved correctly in storage

### Plan code not recognized

- Add to `planTiers` map in `plan_hierarchy.dart`
- Make sure plan code matches exactly (case-insensitive)

### New features showing as unavailable

- Add feature to `featureTierMap` in `feature_availability_manager.dart`
- Set correct minimum tier required

## Next Steps

1. ✅ Integrate the extension into your SubscriptionController usage
2. ✅ Wrap feature-gated UI with access checks
3. ✅ Add feature display widgets to subscription pages
4. ✅ Test with different plan tiers
5. ✅ Navigate users to subscription page on locked feature tap
