import 'dart:async';
import 'dart:math' as math;

import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/subscription/controller/subsciption_history_controller.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/Modules/subscription/model/subscription_history_model.dart';
import 'package:Gixa/Modules/subscription/model/subscription_plan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gixa/services/app_verification_controller.dart';

enum _PremiumSectionState { loading, free, basic, premium, error }

class HomePremiumCounsellingCard extends StatefulWidget {
  final VoidCallback onTap;

  const HomePremiumCounsellingCard({super.key, required this.onTap});

  @override
  State<HomePremiumCounsellingCard> createState() =>
      _HomePremiumCounsellingCardState();
}

class _HomePremiumCounsellingCardState extends State<HomePremiumCounsellingCard>
    with TickerProviderStateMixin {
  late final SubscriptionController _subscriptionController;
  late final SubscriptionHistoryController _historyController;
  late final AnimationController _shimmerController;
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  final RxBool _isBootstrapping = true.obs;

  @override
  void initState() {
    super.initState();
    _subscriptionController = Get.isRegistered<SubscriptionController>()
        ? Get.find<SubscriptionController>()
        : Get.put(SubscriptionController());
    _historyController = Get.isRegistered<SubscriptionHistoryController>()
        ? Get.find<SubscriptionHistoryController>()
        : Get.put(SubscriptionHistoryController());

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    try {
      await _subscriptionController.ensurePlanCatalogLoaded();

      final profileController = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : null;
      final hasUserId = profileController?.profile.value?.user.id != null;

      if (hasUserId) {
        await Future.wait([
          _historyController.ensureLoaded(),
          _subscriptionController.ensureActivePlanReady(),
        ]);
      } else {
        await _subscriptionController.ensureActivePlanReady();
      }
    } catch (_) {
      // Keep usable if refresh fails
    } finally {
      if (mounted) {
        _isBootstrapping.value = false;
      }
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  _PremiumSectionState _resolveState() {
    if (_isBootstrapping.value ||
        _subscriptionController.isLoading.value ||
        _historyController.isLoading.value) {
      return _PremiumSectionState.loading;
    }

    if (_historyController.errorMessage.value.isNotEmpty &&
        !_subscriptionController.isSubscribed) {
      return _PremiumSectionState.error;
    }

    final plan = _subscriptionController.activePlan.value;
    if (plan == null) return _PremiumSectionState.free;

    return _looksPremium(plan)
        ? _PremiumSectionState.premium
        : _PremiumSectionState.basic;
  }

  bool _looksPremium(SubscriptionPlan plan) {
    final combined =
        '${plan.planName} ${plan.planCode} ${plan.planType}'.toLowerCase();
    return combined.contains('premium') ||
        combined.contains('pro') ||
        combined.contains('gold') ||
        combined.contains('platinum') ||
        combined.contains('vip');
  }

  SubscriptionHistory? get _activeHistory {
    for (final item in _historyController.historyList) {
      if (item.isActive && !item.isExpired) return item;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (AppVerificationController.to.hideSubscriptionUi) {
        return const SizedBox.shrink();
      }

      final state = _resolveState();
      final activePlan = _subscriptionController.activePlan.value;
      final activeHistory = _activeHistory;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _buildCard(state, isDark, activePlan, activeHistory),
        ),
      );
    });
  }

  Widget _buildCard(
    _PremiumSectionState state,
    bool isDark,
    SubscriptionPlan? activePlan,
    SubscriptionHistory? activeHistory,
  ) {
    if (state == _PremiumSectionState.loading) {
      return _LoadingCard(key: const ValueKey('loading'), isDark: isDark);
    }
    if (state == _PremiumSectionState.error) {
      return _ErrorCard(
        key: const ValueKey('error'),
        isDark: isDark,
        onRetry: () => unawaited(_bootstrap()),
      );
    }

    final isPremium = state == _PremiumSectionState.premium;
    final isBasic = state == _PremiumSectionState.basic;

    if (isPremium) {
      return _PremiumActiveCard(
        key: const ValueKey('premium'),
        isDark: isDark,
        activePlan: activePlan,
        activeHistory: activeHistory,
        floatAnimation: _floatAnimation,
        onTap: widget.onTap,
      );
    }

    if (isBasic) {
      return _UpgradeCard(
        key: const ValueKey('basic'),
        isDark: isDark,
        isPro: true,
        onTap: widget.onTap,
      );
    }

    return _UpgradeCard(
      key: const ValueKey('free'),
      isDark: isDark,
      isPro: false,
      onTap: widget.onTap,
    );
  }
}

// ─────────────────────────────────────────────
//  PREMIUM ACTIVE CARD
// ─────────────────────────────────────────────
class _PremiumActiveCard extends StatelessWidget {
  final bool isDark;
  final SubscriptionPlan? activePlan;
  final SubscriptionHistory? activeHistory;
  final Animation<double> floatAnimation;
  final VoidCallback onTap;

  const _PremiumActiveCard({
    super.key,
    required this.isDark,
    required this.activePlan,
    required this.activeHistory,
    required this.floatAnimation,
    required this.onTap,
  });

  String _validityText() {
    final endDate = activeHistory?.endDate;
    if (endDate == null) return 'Active';
    final remaining = endDate.difference(DateTime.now()).inDays;
    if (remaining < 0) return 'Expired';
    if (remaining == 0) return 'Expires today';
    if (remaining == 1) return '1 day left';
    return '$remaining days left';
  }

  @override
  Widget build(BuildContext context) {
    const accentA = Color(0xFFBB47F5);
    const accentB = Color(0xFFFF4D8D);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF2D0B4E), const Color(0xFF1A0530)]
                : [const Color(0xFF7B2FBE), const Color(0xFFBB47F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: accentA.withOpacity(isDark ? 0.35 : 0.45),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative orbs
            Positioned(
              top: -18,
              right: -18,
              child: AnimatedBuilder(
                animation: floatAnimation,
                builder: (_, __) => Transform.translate(
                  offset: Offset(0, floatAnimation.value),
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentB.withOpacity(0.18),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -24,
              left: 30,
              child: AnimatedBuilder(
                animation: floatAnimation,
                builder: (_, __) => Transform.translate(
                  offset: Offset(0, -floatAnimation.value),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentA.withOpacity(0.15),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: badge + plan name
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.workspace_premium_rounded,
                                color: Colors.amber, size: 14),
                            const SizedBox(width: 5),
                            Text(
                              'PREMIUM',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _validityText(),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Main headline
                  Text(
                    'Your MBBS Journey\nis Fully Unlocked 🎉',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Personalized roadmap, expert counselling & priority support — all yours.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stats row
                  Row(
                    children: [
                      _statChip(
                          Icons.call_rounded, 'Counsellor Calls', 'Included'),
                      const SizedBox(width: 10),
                      _statChip(Icons.auto_awesome_rounded, 'AI Predictions',
                          'Enabled'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // CTA button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: onTap,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'View My Benefits →',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: accentA,
                        ),
                      ),
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

  Widget _statChip(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.white60,
                    ),
                    overflow: TextOverflow.ellipsis,
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

// ─────────────────────────────────────────────
//  UPGRADE CARD (free / basic)
// ─────────────────────────────────────────────
class _UpgradeCard extends StatelessWidget {
  final bool isDark;
  final bool isPro;
  final VoidCallback onTap;

  const _UpgradeCard({
    super.key,
    required this.isDark,
    required this.isPro,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor =
        isPro ? const Color(0xFF3B82F6) : const Color(0xFFFF7A18);
    final accentColorDark =
        isPro ? const Color(0xFF1D4ED8) : const Color(0xFFE05C00);

    final title = isPro ? 'Upgrade to Pro' : 'Expert Guidance Awaits';
    final subtitle = isPro
        ? 'Unlock personal counsellor calls & priority choice filling.'
        : 'AI predictions, live counselling & choice filling — all in one plan.';
    final btnText = isPro ? 'Upgrade Now' : 'View Plans';
    final tag = isPro ? 'PRO' : 'FREE PLAN';
    final features = isPro
        ? ['Priority choice filling', 'Counsellor calls', 'Seat predictions']
        : ['AI college predictions', 'Expert counselling', 'Starting ₹299'];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark ? const Color(0xFF13131A) : Colors.white,
          border: Border.all(
            color: accentColor.withOpacity(isDark ? 0.4 : 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Subtle top accent strip
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    colors: [accentColor, accentColorDark],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag + icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: accentColor,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isPro
                              ? Icons.auto_awesome_rounded
                              : Icons.explore_rounded,
                          color: accentColor,
                          size: 22,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Title
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Subtitle
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: isDark
                          ? Colors.white60
                          : const Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Feature pills
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: features
                        .map((f) => _featurePill(f, accentColor, isDark))
                        .toList(),
                  ),

                  const SizedBox(height: 20),

                  // CTA
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          colors: [accentColor, accentColorDark],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: onTap,
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          btnText,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
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

  Widget _featurePill(String text, Color accent, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: accent.withOpacity(isDark ? 0.12 : 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: accent, size: 12),
          const SizedBox(width: 5),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  LOADING CARD
// ─────────────────────────────────────────────
class _LoadingCard extends StatefulWidget {
  final bool isDark;

  const _LoadingCard({super.key, required this.isDark});

  @override
  State<_LoadingCard> createState() => _LoadingCardState();
}

class _LoadingCardState extends State<_LoadingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _shimmer = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.06);
    final highlight = widget.isDark
        ? Colors.white.withOpacity(0.12)
        : Colors.black.withOpacity(0.1);

    return AnimatedBuilder(
      animation: _shimmer,
      builder: (_, __) {
        final v = _shimmer.value;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:
                widget.isDark ? const Color(0xFF13131A) : Colors.white,
            border: Border.all(color: base),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _shimmerBox(80, 22, base, highlight, v,
                      radius: 20),
                  const Spacer(),
                  _shimmerBox(42, 42, base, highlight, v,
                      radius: 12),
                ],
              ),
              const SizedBox(height: 16),
              _shimmerBox(200, 20, base, highlight, v, radius: 6),
              const SizedBox(height: 10),
              _shimmerBox(double.infinity, 14, base, highlight, v,
                  radius: 4),
              const SizedBox(height: 6),
              _shimmerBox(double.infinity * 0.7, 14, base, highlight, v,
                  radius: 4),
              const SizedBox(height: 20),
              _shimmerBox(double.infinity, 48, base, highlight, v,
                  radius: 14),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerBox(
    double width,
    double height,
    Color base,
    Color highlight,
    double v, {
    double radius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Color.lerp(base, highlight, math.sin(v * math.pi).abs()),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  ERROR CARD
// ─────────────────────────────────────────────
class _ErrorCard extends StatelessWidget {
  final bool isDark;
  final VoidCallback onRetry;

  const _ErrorCard({super.key, required this.isDark, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    const errorColor = Color(0xFFEF4444);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? const Color(0xFF13131A) : Colors.white,
        border: Border.all(color: errorColor.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: errorColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(Icons.wifi_off_rounded, color: errorColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Couldn\'t load subscription',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Check your connection and try again.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color:
                        isDark ? Colors.white54 : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: errorColor.withOpacity(0.3)),
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: errorColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}