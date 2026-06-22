import 'package:flutter/material.dart';
import 'package:Gixa/Modules/subscription/utils/plan_hierarchy.dart';
import 'package:Gixa/Modules/subscription/utils/feature_availability_manager.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget to display a single feature with lock/unlock status
class FeatureItem extends StatelessWidget {
  final String featureName;
  final String? featureDescription;
  final PlanTier userTier;
  final bool showLockIcon;
  final VoidCallback? onLockedTap;
  final Color? accentColor;

  const FeatureItem({
    Key? key,
    required this.featureName,
    this.featureDescription,
    required this.userTier,
    this.showLockIcon = true,
    this.onLockedTap,
    this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAccessible = FeatureAvailabilityManager.canAccessFeature(
      featureName,
      userTier,
    );

    return GestureDetector(
      onTap: isAccessible ? null : onLockedTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isAccessible
                ? (accentColor ?? Colors.green).withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isAccessible
              ? (accentColor ?? Colors.green).withOpacity(0.05)
              : Colors.grey.withOpacity(0.02),
        ),
        child: Row(
          children: [
            // Feature indicator or lock icon
            if (showLockIcon)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: isAccessible
                    ? Icon(
                        Icons.check_circle,
                        color: accentColor ?? Colors.green,
                        size: 20,
                      )
                    : Icon(
                        Icons.lock_outline,
                        color: Colors.grey[600],
                        size: 18,
                      ),
              ),

            // Feature name and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    featureName,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isAccessible ? Colors.black87 : Colors.grey[600],
                      decoration: isAccessible
                          ? TextDecoration.none
                          : TextDecoration.lineThrough,
                    ),
                  ),
                  if (featureDescription != null &&
                      featureDescription!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        featureDescription!,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display a section of features organized by tier
class FeatureSection extends StatelessWidget {
  final String sectionTitle;
  final List<String> features;
  final PlanTier userTier;
  final PlanTier sectionTier;
  final bool showLockIcon;
  final VoidCallback? onUpgradeTap;
  final Color? accentColor;
  final EdgeInsets padding;

  const FeatureSection({
    Key? key,
    required this.sectionTitle,
    required this.features,
    required this.userTier,
    required this.sectionTier,
    this.showLockIcon = true,
    this.onUpgradeTap,
    this.accentColor,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUnlocked = PlanHierarchy.canAccessTier(userTier, sectionTier);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with lock/unlock badge
          Row(
            children: [
              Expanded(
                child: Text(
                  sectionTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (showLockIcon && !isUnlocked)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, size: 12, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        PlanHierarchy.getTierName(sectionTier),
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Features list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return FeatureItem(
                featureName: features[index],
                userTier: userTier,
                showLockIcon: showLockIcon,
                onLockedTap: isUnlocked ? null : onUpgradeTap,
                accentColor: accentColor,
              );
            },
          ),

          // Upgrade prompt for locked sections
          if (!isUnlocked && onUpgradeTap != null) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onUpgradeTap,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (accentColor ?? Colors.blue).withOpacity(0.1),
                  border: Border.all(
                    color: (accentColor ?? Colors.blue).withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.upgrade,
                      size: 16,
                      color: accentColor ?? Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Upgrade to ${PlanHierarchy.getTierName(sectionTier)} Plan',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: accentColor ?? Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget to display all features organized by tiers
class FeatureComparison extends StatelessWidget {
  final PlanTier userTier;
  final VoidCallback? onUpgradeTap;
  final Color? accentColor;
  final bool showLockedOnly;

  const FeatureComparison({
    Key? key,
    required this.userTier,
    this.onUpgradeTap,
    this.accentColor,
    this.showLockedOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Basic Plan Features
        FeatureSection(
          sectionTitle: '${PlanHierarchy.getTierName(PlanTier.basic)} Features',
          features: FeatureAvailabilityManager.getExclusiveFeaturesForTier(
            PlanTier.basic,
          ),
          userTier: userTier,
          sectionTier: PlanTier.basic,
          onUpgradeTap: onUpgradeTap,
          accentColor: accentColor,
        ),

        // Classic Plan Features
        if (!showLockedOnly ||
            !PlanHierarchy.canAccessTier(userTier, PlanTier.classic))
          FeatureSection(
            sectionTitle:
                '${PlanHierarchy.getTierName(PlanTier.classic)} Features',
            features: FeatureAvailabilityManager.getExclusiveFeaturesForTier(
              PlanTier.classic,
            ),
            userTier: userTier,
            sectionTier: PlanTier.classic,
            onUpgradeTap: onUpgradeTap,
            accentColor: accentColor,
          ),

        // Premium Plan Features
        if (!showLockedOnly ||
            !PlanHierarchy.canAccessTier(userTier, PlanTier.premium))
          FeatureSection(
            sectionTitle:
                '${PlanHierarchy.getTierName(PlanTier.premium)} Features',
            features: FeatureAvailabilityManager.getExclusiveFeaturesForTier(
              PlanTier.premium,
            ),
            userTier: userTier,
            sectionTier: PlanTier.premium,
            onUpgradeTap: onUpgradeTap,
            accentColor: accentColor,
          ),
      ],
    );
  }
}
