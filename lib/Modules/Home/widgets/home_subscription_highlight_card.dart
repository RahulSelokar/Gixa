import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/Modules/subscription/model/subscription_plan.dart';
import 'package:Gixa/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gixa/services/app_verification_controller.dart';

// ─────────────────────────────────────────────────────────────
//  Brand colors
// ─────────────────────────────────────────────────────────────

const _kLogoOrange = Color(0xFFFF7A00);
const _kLogoPink = Color(0xFFFF0066);
const _kLogoPurple = Color(0xFF6600FF);

const _kGradient = LinearGradient(
  colors: [
    _kLogoOrange,
    _kLogoPink,
    _kLogoPurple,
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// ─────────────────────────────────────────────────────────────
//  Main popup card
// ─────────────────────────────────────────────────────────────
class SubscriptionPopupCard extends StatefulWidget {
  final VoidCallback onSubscribe;
  const SubscriptionPopupCard({super.key, required this.onSubscribe});

  @override
  State<SubscriptionPopupCard> createState() => _SubscriptionPopupCardState();
}

class _SubscriptionPopupCardState extends State<SubscriptionPopupCard> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();
    final isThemeDark = Theme.of(context).brightness == Brightness.dark;
    final isDark = true; // Force dark mode content styles because of vibrant gradient background

    // ── Responsive metrics ───────────────────────────────────
    final media = MediaQuery.of(context);
    final screenW = media.size.width;
    final bool isCompact = screenW < 360;

    final double horizontalMargin = isCompact ? 12 : 18;
    final double contentPadding = isCompact ? 16 : 22;

    return Material(
      color: Colors.transparent,
      child: Obx(() {
        if (AppVerificationController.to.hideSubscriptionUi) {
          return const SizedBox();
        }
        final allPlans = controller.plans;
        if (allPlans.isEmpty) return const SizedBox();

        return Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          constraints: const BoxConstraints(maxWidth: 440),
          decoration: BoxDecoration(
            gradient: _kGradient,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isThemeDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isThemeDark ? Colors.black.withOpacity(0.5) : _kLogoPurple.withOpacity(0.15),
                blurRadius: 40,
                spreadRadius: 4,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: _kLogoOrange.withOpacity(isThemeDark ? 0.15 : 0.08),
                blurRadius: 60,
                spreadRadius: -10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              children: [
                // Soft decorative glow in the top-right corner
                Positioned(
                  top: -50,
                  right: -40,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _kLogoOrange.withOpacity(isDark ? 0.12 : 0.06),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -60,
                  left: -50,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _kLogoPurple.withOpacity(isDark ? 0.08 : 0.04),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.all(contentPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTopBar(isDark),
                      const SizedBox(height: 14),
                      _buildHero(isCompact, isDark),
                      const SizedBox(height: 16),
                      _buildChips(isDark),
                      const SizedBox(height: 20),
                      _buildSectionLabel('CHOOSE YOUR PLAN', isDark),
                      const SizedBox(height: 10),
                      _buildPlanList(allPlans, isDark),
                      const SizedBox(height: 18),
                      _buildCTA(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ── Top bar ──────────────────────────────────────────────
  Widget _buildTopBar(bool isDark) {
    return Row(
      children: [
        _pill('SUBSCRIPTION PLANS', isDark),
        const Spacer(),
        _circleBtn(Icons.close_rounded, () => Get.back(), isDark),
      ],
    );
  }

  Widget _pill(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.08) : _kLogoPink.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.12) : _kLogoPink.withOpacity(0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            color: isDark ? _kLogoOrange.withOpacity(0.9) : _kLogoPink,
            size: 12,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: isDark ? Colors.white70 : _kLogoPurple,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: .7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap, bool isDark) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.04),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.12)
                  : Colors.black.withOpacity(0.08),
            ),
          ),
          child: Icon(
            Icons.close_rounded,
            color: isDark ? Colors.white70 : Colors.black87,
            size: 16,
          ),
        ),
      ),
    );
  }

  // ── Hero row ─────────────────────────────────────────────
  Widget _buildHero(bool isCompact, bool isDark) {
    final double logoSize = isCompact ? 64 : 72;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: logoSize,
          width: logoSize,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : _kLogoPurple.withOpacity(0.03),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.10) : _kLogoPurple.withOpacity(0.10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset('assets/icons/gixxa4.png', fit: BoxFit.contain),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Unlock Premium',
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: isCompact ? 17 : 19,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'AI-powered NEET counselling & rank-to-right-college prediction',
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.white60 : Colors.black54,
                  fontSize: 11,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Feature chips ─────────────────────────────────────────
  Widget _buildChips(bool isDark) {
    const chips = ['AI Prediction', 'All States', 'Counselling', 'Seat Matrix'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips.map((c) => _chip(c, isDark)).toList(),
    );
  }

  Widget _chip(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(.06)
            : UColors.success.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(.08)
              : UColors.success.withOpacity(0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: isDark ? Colors.greenAccent : UColors.success,
            size: 12,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section label ─────────────────────────────────────────
  Widget _buildSectionLabel(String text, bool isDark) {
    return Row(
      children: [
        Text(
          text,
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white54 : Colors.black45,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: .8,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.06),
          ),
        ),
      ],
    );
  }

  // ── Plan list (expandable) ────────────────────────────────
  Widget _buildPlanList(List<SubscriptionPlan> plans, bool isDark) {
    final meta = _planMeta(plans);
    return Column(
      children: List.generate(plans.length, (i) {
        final plan = plans[i];
        final m = i < meta.length ? meta[i] : _PlanMeta('📋', null, false);
        final isExpanded = _expandedIndex == i;
        final card = _PlanCard(
          plan: plan,
          icon: m.icon,
          badge: m.badge,
          isBest: m.isBest,
          isExpanded: isExpanded,
          onTap: () => setState(() {
            _expandedIndex = isExpanded ? null : i;
          }),
        );

        if (plan.isAddon == true) {
          return Column(
            children: [
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 233, 220, 225).withOpacity(0.08)
                      : _kLogoPink.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? _kLogoPink.withOpacity(0.4)
                        : _kLogoPink.withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.add_circle_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "SUBSCRIBE ADDON PLANS: FOR ROUND BY ROUND CHOICE FILLING PROCESS",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white70,
                size: 24,
              ),
              const SizedBox(height: 8),
              card,
            ],
          );
        }

        return card;
      }),
    );
  }

  // Map backend plans by index to UI metadata
  List<_PlanMeta> _planMeta(List<SubscriptionPlan> plans) {
    // Adjust badges/icons based on plan name heuristics
    return plans.map((p) {
      final name = p.planName.toLowerCase();
      if (name.contains('basic')) {
        return _PlanMeta('📚', 'Best Value', false);
      } else if (name.contains('classic')) {
        return _PlanMeta('🏛️', 'POPULAR', false);
      } else if (name.contains('premium')) {
        return _PlanMeta('⭐', 'BEST', true);
      } else if (name.contains('vip')) {
        return _PlanMeta('👑', 'ALL-IN', false);
      }
      return _PlanMeta('💎', p.isRecommended ? 'BEST' : null, p.isRecommended);
    }).toList();
  }

  // ── CTA button ────────────────────────────────────────────
  Widget _buildCTA() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          gradient: _kGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _kLogoPink.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.onSubscribe,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Explore Plans',
                  style: GoogleFonts.poppins(
                    color: UColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: UColors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Plan meta helper
// ─────────────────────────────────────────────────────────────
class _PlanMeta {
  final String icon;
  final String? badge;
  final bool isBest;
  const _PlanMeta(this.icon, this.badge, this.isBest);
}

// ─────────────────────────────────────────────────────────────
//  Expandable plan card
// ─────────────────────────────────────────────────────────────
class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final String icon;
  final String? badge;
  final bool isBest;
  final bool isExpanded;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.icon,
    required this.badge,
    required this.isBest,
    required this.isExpanded,
    required this.onTap,
  });

  // Map plan features
  List<String> get _features {
    if (plan.features.isNotEmpty) {
      return plan.features.map((f) => f.featureTitle).toList();
    }
    return ['Access to all features in this plan'];
  }

  int get _amountInt => int.tryParse(plan.amount.toString()) ?? 0;
  int get _originalAmountInt =>
      int.tryParse(plan.amount?.toString() ?? '') ?? 0;

  String get _priceRow {
    if (plan.amount != null && _originalAmountInt > _amountInt) {
      return '₹${plan.amount}  →  ₹${plan.amount}';
    }
    return '₹${plan.amount}';
  }

  bool get _hasDiscount =>
      plan.amount != null && _originalAmountInt > _amountInt;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isExpanded
                ? (isDark ? UColors.darkCard.withOpacity(0.9) : UColors.white)
                : (isDark
                      ? UColors.darkCard.withOpacity(0.6)
                      : UColors.lightGrey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isBest
                  ? _kLogoPink.withOpacity(0.5)
                  : (isExpanded
                        ? (isDark
                              ? Colors.white.withOpacity(0.12)
                              : UColors.border)
                        : (isDark
                              ? Colors.white.withOpacity(0.04)
                              : Colors.black.withOpacity(0.03))),
              width: isBest ? 1.5 : 1,
            ),
            boxShadow: isBest
                ? [
                    BoxShadow(
                      color: _kLogoPink.withOpacity(
                        isDark ? 0.12 : 0.08,
                      ),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ]
                : (isExpanded && !isDark)
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              // Header row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon box
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : _kLogoPurple.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : _kLogoPurple.withOpacity(0.1),
                      ),
                    ),
                    child: Center(
                      child: Text(icon, style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Plan name + price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.planName,
                          style: GoogleFonts.poppins(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        if (plan.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            plan.description,
                            style: GoogleFonts.poppins(
                              color: isDark ? Colors.white54 : Colors.black54,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        _buildPriceRow(isDark),
                      ],
                    ),
                  ),

                  // Badge & expand icon column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (badge != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: isBest ? _kGradient : null,
                            color: isBest
                                ? null
                                : (isDark
                                      ? Colors.white.withOpacity(0.1)
                                      : _kLogoPurple.withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge!,
                            style: GoogleFonts.poppins(
                              color: isBest
                                  ? Colors.white
                                  : (isDark
                                        ? Colors.white
                                        : _kLogoPurple),
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                      AnimatedRotation(
                        turns: isExpanded ? .5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.black.withOpacity(0.04),
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: isDark ? Colors.white70 : Colors.black54,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Expanded features
              AnimatedCrossFade(
                firstChild: const SizedBox(height: 0, width: double.infinity),
                secondChild: _buildFeatures(isDark),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 220),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(bool isDark) {
    if (_hasDiscount) {
      return Row(
        children: [
          Text(
            '₹${plan.amount}',
            style: GoogleFonts.poppins(
              color: isDark ? Colors.white38 : Colors.black38,
              fontSize: 11,
              decoration: TextDecoration.lineThrough,
              decorationColor: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '→  ₹${plan.amount}',
            style: GoogleFonts.poppins(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
    }
    return Text(
      '₹${plan.amount}',
      style: GoogleFonts.poppins(
        color: isBest
            ? _kLogoPink
            : (isDark ? Colors.white70 : Colors.black87),
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildFeatures(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: isDark
                ? Colors.white.withOpacity(.08)
                : Colors.black.withOpacity(0.06),
            height: 1,
          ),
          const SizedBox(height: 12),
          ..._features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.greenAccent.withOpacity(0.15)
                          : UColors.success.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: isDark ? Colors.greenAccent : UColors.success,
                      size: 10,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      f,
                      style: GoogleFonts.poppins(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontSize: 11,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Add-on card
// ─────────────────────────────────────────────────────────────
class _AddOnCard extends StatelessWidget {
  final SubscriptionPlan addon;
  const _AddOnCard({required this.addon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? UColors.darkCard.withOpacity(0.5) : UColors.lightGrey,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(.08)
              : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  addon.planName,
                  style: GoogleFonts.poppins(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (addon.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    addon.description,
                    style: GoogleFonts.poppins(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 10,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '₹${addon.amount}',
            style: GoogleFonts.poppins(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
