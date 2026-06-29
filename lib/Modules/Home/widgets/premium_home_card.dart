import 'dart:async';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/Modules/subscription/model/subscription_plan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gixa/services/app_verification_controller.dart';

class HomePlansSection extends StatefulWidget {
  const HomePlansSection({super.key});

  @override
  State<HomePlansSection> createState() => _HomePlansSectionState();
}

class _HomePlansSectionState extends State<HomePlansSection>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<SubscriptionController>();

  // PageController — premium (index 1) starts in center if available
  late PageController _pageController;
  int _currentPage = 1;

  // Peek animation state
  late final AnimationController _peekController;
  late Animation<double> _peekAnimation;
  Timer? _peekTimer;
  bool _peekAnimationDone = false;
  bool _hasInitializedPage = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: 1, // Will be corrected in build if plans < 3
      viewportFraction: 0.85,
    );

    _peekController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );

    // Delay peek until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _schedulePeekAnimation();
    });
  }

  List<SubscriptionPlan> _getCurrentPlans() {
    return controller.isSubscribed
        ? _upgradePlans(controller.plans, controller.activePlan.value)
        : _corePlans(controller.plans);
  }

  /// Runs the intro peek: center → peek right (Basic) → center → peek left (Standard) → center
  void _schedulePeekAnimation() {
    _peekTimer = Timer(const Duration(milliseconds: 600), () async {
      if (!mounted || _peekAnimationDone) return;
      
      final plans = _getCurrentPlans();
      if (plans.length < 3) {
        _peekAnimationDone = true;
        _startAutoScroll();
        return;
      }

      // Step 1: peek right (scroll toward page 0 = Basic)
      await _pageController.animateTo(
        _pageController.offset - _peekOffset,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeInOut,
      );
      await Future.delayed(const Duration(milliseconds: 320));
      if (!mounted) return;

      // Step 2: back to center (Premium)
      await _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 460),
        curve: Curves.easeInOut,
      );
      await Future.delayed(const Duration(milliseconds: 340));
      if (!mounted) return;

      // Step 3: peek left (scroll toward page 2 = Standard)
      await _pageController.animateTo(
        _pageController.offset + _peekOffset,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeInOut,
      );
      await Future.delayed(const Duration(milliseconds: 320));
      if (!mounted) return;

      // Step 4: back to center (Premium)
      await _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 460),
        curve: Curves.easeInOut,
      );

      _peekAnimationDone = true;
      _startAutoScroll();
    });
  }

  double get _peekOffset {
    // peek by ~55% of a page width
    final pageWidth = _pageController.hasClients
        ? _pageController.position.viewportDimension *
              _pageController.viewportFraction
        : 220.0;
    return pageWidth * 0.55;
  }

  void _startAutoScroll() {
    _peekTimer?.cancel();
    _peekTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final plans = _getCurrentPlans();
      if (plans.length <= 1) return;
      final next = (_currentPage + 1) % plans.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 460),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _peekTimer?.cancel();
    _peekController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (AppVerificationController.to.hideSubscriptionUi) return const SizedBox();
      if (controller.plans.isEmpty) return const SizedBox();

      final bool hasActivePlan = controller.isSubscribed;
      final plans = _getCurrentPlans();
      if (plans.isEmpty) return const SizedBox();

      final isCompact = MediaQuery.of(context).size.width < 600;
      final isDark = Theme.of(context).brightness == Brightness.dark;

      if (!_hasInitializedPage) {
        _hasInitializedPage = true;
        _currentPage = plans.length >= 3 ? 1 : 0;
        _pageController.dispose();
        _pageController = PageController(
          initialPage: _currentPage,
          viewportFraction: 0.85,
        );
      }

      // Reset page if plans changed and out of bounds
      if (_currentPage >= plans.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _currentPage = 0;
              if (_pageController.hasClients) {
                _pageController.jumpToPage(0);
              }
            });
          }
        });
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasActivePlan
                            ? "Upgrade Your Plan"
                            : "Choose Your Guidance Plan",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : null,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        hasActivePlan
                            ? "Explore higher plans and add-ons to boost your journey"
                            : "Simple options for every stage of admission support",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          height: 1.25,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => Get.toNamed('/subscription'),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    "View All",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      height: 1.0,
                      color: isDark ? Colors.white70 : null,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── Cards PageView ───────────────────────────────────
          SizedBox(
            height: isCompact ? 500 : 540,
            child: PageView.builder(
              controller: _pageController,
              padEnds: false,
              physics: const BouncingScrollPhysics(),
              itemCount: plans.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, index) {
                final plan = plans[index];

                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double scale = 0.88;
                    double opacity = 0.68;

                    if (_pageController.hasClients &&
                        _pageController.position.haveDimensions) {
                      final page =
                          _pageController.page ?? _currentPage.toDouble();
                      final dist = (page - index).abs().clamp(0.0, 1.0);
                      scale = 1.0 - dist * 0.12;
                      opacity = 1.0 - dist * 0.22;
                    } else if (_currentPage == index) {
                      scale = 1.0;
                      opacity = 1.0;
                    }

                    return Transform.scale(
                      scale: scale,
                      child: Opacity(opacity: opacity, child: child),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Builder(
                      builder: (context) {
                        final card = _PlanCard(
                          plan: plan,
                          imagePath: _getGenie(index),
                          onTap: () => Get.toNamed('/subscription'),
                          isCentered: index == _currentPage,
                          cardIndex: index,
                        );

                        if (plan.isAddon == true) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF4E5).withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFFFB020), width: 1.5),
                                ),
                                child: Text(
                                  "SUBSCRIBE ADDON PLANS: FOR ROUND BY ROUND CHOICE FILLING PROCESS",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFD97706),
                                  ),
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFFB020), size: 24),
                              Expanded(child: card),
                            ],
                          );
                        }

                        return Column(
                          children: [
                            const SizedBox(height: 58), // spacer to align with addon card
                            Expanded(child: card),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Dot indicators ───────────────────────────────────
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(plans.length, (i) {
              final active = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: active
                      ? const LinearGradient(
                          colors: [Color(0xFFFF8A00), Color(0xFFE94057)],
                        )
                      : null,
                  color: active
                      ? null
                      : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                ),
              );
            }),
          ),
        ],
      );
    });
  }

  // ─── Helpers ────────────────────────────────────────────────

  /// Rank a plan by tier for ordering & comparison.
  /// Lower rank = lower tier.
  static int _planRank(SubscriptionPlan plan) {
    final name = '${plan.planName} ${plan.planCode} ${plan.planType}'
        .toLowerCase();
    if (name.contains('basic')) return 1;
    if (name.contains('classic')) return 2;
    if (name.contains('premium')) return 3;
    if (name.contains('round')) return 4;
    return 0; // unknown
  }

  /// Plans to show when user is NOT subscribed (core plans).
  List<SubscriptionPlan> _corePlans(List<SubscriptionPlan> plans) {
    final sortedPlans = plans.toList();
    sortedPlans.sort((a, b) {
      final rankA = _planRank(a);
      final rankB = _planRank(b);
      if (rankA != rankB) return rankA.compareTo(rankB);
      if (a.isAddon == b.isAddon) {
        return a.planName.compareTo(b.planName);
      }
      return a.isAddon ? 1 : -1;
    });
    return sortedPlans;
  }

  /// Plans to show when user HAS an active plan:
  /// higher-tier regular plans + all add-ons.
  List<SubscriptionPlan> _upgradePlans(
    List<SubscriptionPlan> allPlans,
    SubscriptionPlan? active,
  ) {
    final int activeRank = active != null ? _planRank(active) : 0;

    // Collect higher-tier regular plans (exclude current active)
    final higherRegular = allPlans.where((p) {
      if (p.id == active?.id) return false;
      if (p.isAddon) return false;
      return _planRank(p) > activeRank;
    }).toList();

    // Collect all add-on plans
    final addons = allPlans.where((p) => p.isAddon == true).toList();

    final combined = [...higherRegular, ...addons];
    combined.sort((a, b) {
      final rankA = _planRank(a);
      final rankB = _planRank(b);
      if (rankA != rankB) return rankA.compareTo(rankB);
      if (a.isAddon == b.isAddon) {
        return a.planName.compareTo(b.planName);
      }
      return a.isAddon ? 1 : -1;
    });

    return combined;
  }

  bool _isCorePlan(SubscriptionPlan plan) {
    return true;
  }

  bool _matchesPlan(SubscriptionPlan plan, String keyword) =>
      '${plan.planName} ${plan.planCode} ${plan.planType}'
          .toLowerCase()
          .contains(keyword.toLowerCase());

  String _getGenie(int index) {
    switch (index % 3) {
      case 0:
        return "assets/icons/G1.png";
      case 1:
        return "assets/icons/G2.png";
      case 2:
      default:
        return "assets/icons/G3.png";
    }
  }
}

// ────────────────────────────────────────────────────────────────
//  Plan Card
// ────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final String imagePath;
  final VoidCallback onTap;
  final bool isCentered;
  final int cardIndex;

  const _PlanCard({
    required this.plan,
    required this.imagePath,
    required this.onTap,
    required this.isCentered,
    required this.cardIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isPremium = plan.isRecommended;
    final isClassic = _isClassic(plan);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Colors ──────────────────────────────────────────────────
    final titleColor = isPremium
        ? const Color(0xFFE94057)
        : isClassic
            ? const Color(0xFF2D7FF9)
            : const Color(0xFFFF8A00);

    final badgeGradient = isPremium
        ? const LinearGradient(colors: [Color(0xFFFF8A00), Color(0xFFE94057)])
        : isClassic
            ? const LinearGradient(colors: [Color(0xFF3A8DFF), Color(0xFF7B3FE4)])
            : const LinearGradient(colors: [Color(0xFFFFC46B), Color(0xFFFF8A00)]);

    final badgeLabel = isPremium
        ? "MOST POPULAR"
        : isClassic
            ? "CLASSIC"
            : "BASIC";

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Card shell ──────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF141A26) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: isPremium
                    ? const Color(0xFFE94057).withOpacity(isCentered ? .18 : .08)
                    : (isDark
                        ? Colors.black.withOpacity(.35)
                        : Colors.black.withOpacity(.05)),
                blurRadius: isPremium ? (isCentered ? 32 : 16) : 16,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: isPremium
                  ? const Color(0xFFE94057).withOpacity(isCentered ? .40 : .20)
                  : (isDark ? Colors.white.withOpacity(.08) : Colors.grey.shade200),
              width: isPremium ? 2.0 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header / Pricing Area ───────────────────────
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0D121B) : Colors.grey.shade50,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                ),
                child: Stack(
                  children: [
                    // Genie Image
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Opacity(
                        opacity: isDark ? 0.8 : 0.9,
                        child: Image.asset(
                          imagePath,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
                      child: Column(
                        children: [
                          Text(
                            plan.planName,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: isPremium ? 22 : 18,
                              fontWeight: FontWeight.w800,
                              color: titleColor,
                            ),
                          ),
                          if (plan.description.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              plan.description,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: isDark ? Colors.white70 : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "₹",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              Text(
                                plan.amount.replaceAll(".00", "").replaceAll("₹", ""),
                                style: GoogleFonts.poppins(
                                  fontSize: isPremium ? 36 : 30,
                                  fontWeight: FontWeight.w800,
                                  height: 1.0,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4, left: 4),
                                child: Text(
                                  "/mo",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                height: 1,
                color: isDark ? Colors.white10 : Colors.grey.shade200,
              ),

              // ── Features List ────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: plan.features.take(5).map((f) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: f.isEnabled
                                    ? Colors.green.withOpacity(isDark ? .22 : .13)
                                    : Colors.red.withOpacity(isDark ? .18 : .10),
                              ),
                              child: Icon(
                                f.isEnabled ? Icons.check : Icons.close,
                                size: 12,
                                color: f.isEnabled ? Colors.green : Colors.red.shade400,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                f.featureTitle,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // ── Footer CTA ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: badgeGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: badgeGradient.colors.first.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Explore Now",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── MOST POPULAR badge ──────────────────────────────────
        if (isPremium)
          Positioned(
            top: -14,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                decoration: BoxDecoration(
                  gradient: badgeGradient,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE94057).withOpacity(isDark ? .28 : .38),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  badgeLabel,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool _isClassic(SubscriptionPlan plan) =>
      '${plan.planName} ${plan.planCode} ${plan.planType}'.toLowerCase().contains('classic') ||
      '${plan.planName} ${plan.planCode} ${plan.planType}'.toLowerCase().contains('standard');
}
