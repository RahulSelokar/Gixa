import 'dart:async';

import 'package:Gixa/Modules/Assistance/controller/guidance_requests_controller.dart';
import 'package:Gixa/Modules/Assistance/model/request_guidance_model.dart';
import 'package:Gixa/Modules/Assistance/view/request_guidance_view.dart';
import 'package:Gixa/Modules/subscription/model/subscription_plan.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:Gixa/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CounselorListView extends StatefulWidget {
  const CounselorListView({super.key});

  @override
  State<CounselorListView> createState() => _CounselorListViewState();
}

class _CounselorListViewState extends State<CounselorListView> {
  late final GuidanceRequestsController controller;
  final GlobalKey _supportSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = Get.put(GuidanceRequestsController());
  }

  @override
  void dispose() {
    if (Get.isRegistered<GuidanceRequestsController>()) {
      Get.delete<GuidanceRequestsController>();
    }
    super.dispose();
  }

  Future<void> _scrollToSupportSection() async {
    final targetContext = _supportSectionKey.currentContext;
    if (targetContext == null) return;

    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  Future<void> _showPlanDetails(SubscriptionPlan plan) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final enabledFeatures = plan.features
        .where((feature) => feature.isEnabled)
        .toList();

    final hasDescription = plan.description.trim().isNotEmpty;

    final normalizedPlanType = plan.planType.trim();
    final normalizedPlanCode = plan.planCode.trim();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.78,
          minChildSize: 0.55,
          maxChildSize: 0.96,

          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),

              decoration: BoxDecoration(
                color: isDark ? UColors.darkCard : Colors.white,

                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),

              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// Drag Handle
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,

                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// Plan Name
                    Text(
                      plan.planName,

                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// Chips
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,

                      children: [
                        _InfoChip(
                          icon: Icons.sell_rounded,
                          label: _formatPlanPrice(plan.amount),
                        ),

                        _InfoChip(
                          icon: Icons.schedule_rounded,
                          label: _formatPlanDuration(plan.durationDays),
                        ),

                        if (plan.isRecommended)
                          const _InfoChip(
                            icon: Icons.auto_awesome_rounded,
                            label: 'Recommended',
                          ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// Description Title
                    Text(
                      'Plan Description',

                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Description
                    /// Description
                    Container(
                      width: double.infinity,

                      constraints: const BoxConstraints(maxHeight: 220),

                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.04)
                            : Colors.grey.shade50,

                        borderRadius: BorderRadius.circular(18),

                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.06)
                              : Colors.grey.shade200,
                        ),
                      ),

                      child: Stack(
                        children: [
                          /// 🔥 Scrollable Description
                          Scrollbar(
                            thumbVisibility: true,

                            radius: const Radius.circular(20),

                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),

                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 8,
                                  bottom: 18,
                                ),

                                child: Text(
                                  hasDescription
                                      ? plan.description
                                      : '',

                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    height: 1.8,

                                    color: theme.textTheme.bodyMedium?.color
                                        ?.withOpacity(0.84),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          /// 🔥 Scroll Down Indicator
                          Positioned(
                            bottom: 0,
                            right: 0,

                            child: Container(
                              padding: const EdgeInsets.all(4),

                              decoration: BoxDecoration(
                                color: isDark ? Colors.black54 : Colors.white,

                                shape: BoxShape.circle,

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),

                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,

                                size: 18,

                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Metadata
                    if (normalizedPlanType.isNotEmpty ||
                        normalizedPlanCode.isNotEmpty) ...[
                      const SizedBox(height: 24),

                      Text(
                        'Plan Metadata',

                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,

                        children: [
                          if (normalizedPlanType.isNotEmpty)
                            _InfoChip(
                              icon: Icons.category_rounded,
                              label: normalizedPlanType,
                            ),

                          if (normalizedPlanCode.isNotEmpty)
                            _InfoChip(
                              icon: Icons.code_rounded,
                              label: normalizedPlanCode,
                            ),
                        ],
                      ),
                    ],

                    /// Features
                    const SizedBox(height: 24),

                    Text(
                      'Included Features',

                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 14),

                    if (enabledFeatures.isNotEmpty)
                      ...enabledFeatures.map(
                        (feature) => Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(14),

                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.06),

                            borderRadius: BorderRadius.circular(18),
                          ),

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 2),

                                child: Icon(
                                  Icons.check_circle_rounded,
                                  size: 20,
                                  color: theme.primaryColor,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      feature.featureTitle.trim().isEmpty
                                          ? 'Feature'
                                          : feature.featureTitle,

                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    if (feature.featureDescription
                                        .trim()
                                        .isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),

                                        child: Text(
                                          feature.featureDescription,

                                          style: GoogleFonts.inter(
                                            fontSize: 12.8,
                                            height: 1.55,

                                            color: theme
                                                .textTheme
                                                .bodyMedium
                                                ?.color
                                                ?.withOpacity(0.72),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Text(
                        'Feature details are not available for this plan right now.',

                        style: GoogleFonts.inter(
                          fontSize: 14,
                          height: 1.6,

                          color: theme.textTheme.bodyMedium?.color?.withOpacity(
                            0.8,
                          ),
                        ),
                      ),

                    const SizedBox(height: 28),

                    /// Button
                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: () {
                          controller.selectPlan(plan);

                          Get.back();

                          _scrollToSupportSection();
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: UColors.primary,
                          foregroundColor: Colors.white,

                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),

                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),

                        child: Text(
                          'Select This Plan',

                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openRequestDetails(GuidanceRequestItem request) async {
    final requestFuture = controller.fetchRequestDetail(request.requestId);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _GuidanceRequestDetailsSheet(requestFuture: requestFuture);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? UColors.darkSurface : const Color(0xFFFFFBF7);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          'Subscription Help',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: bg,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    Color(0xFF120F1C),
                    Color(0xFF171320),
                    Color(0xFF101626),
                  ]
                : const [
                    Color(0xFFFFFBF7),
                    Color(0xFFFFF2E8),
                    Color(0xFFF8F1FF),
                  ],
          ),
        ),
        child: Obx(() {
          final requests = controller.requests.toList();
          final plans = controller.plans.toList();
          final selectedPlan = controller.selectedPlan.value;

          if (controller.isLoading.value &&
              controller.isPlansLoading.value &&
              requests.isEmpty &&
              plans.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final acceptedCount = requests
              .where((item) => item.isAccepted)
              .length;
          final pendingCount = requests
              .where((item) => item.status.toLowerCase() == 'pending')
              .length;

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchRequests();
              await controller.fetchPlans(forceRefresh: true);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                _GuidanceHeroCard(
                  title: 'Need help choosing a subscription?',
                  subtitle:
                      'Explore the plans in our brand new slider, compare the essentials, and send one clean request for personalized subscription advice.',
                  actionLabel: 'Go to request form',
                  onActionTap: _scrollToSupportSection,
                ),
                if (requests.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _StatusStatCard(
                          label: 'Total requests',
                          value: requests.length.toString(),
                          icon: Icons.list_alt_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatusStatCard(
                          label: 'Accepted',
                          value: acceptedCount.toString(),
                          icon: Icons.verified_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatusStatCard(
                          label: 'Pending',
                          value: pendingCount.toString(),
                          icon: Icons.schedule_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                Container(
                  key: _supportSectionKey,
                  child: Column(
                    children: [
                      _SubscriptionPlansSection(
                        plans: plans,
                        selectedPlan: selectedPlan,
                        isLoading: controller.isPlansLoading.value,
                        onSelectPlan: controller.selectPlan,
                        onSeeMore: _showPlanDetails,
                      ),
                      const SizedBox(height: 18),
                      RequestGuidanceDialog(
                        closeOnSuccess: false,
                        selectedPlan: selectedPlan,
                        onSuccess: () {
                          controller.fetchRequests();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (requests.isEmpty)
                  const _InlineNoticeCard(
                    icon: Icons.mark_email_read_outlined,
                    title: 'No requests yet',
                    description:
                        'Once you submit a subscription help request, its status and counselor updates will appear here.',
                  )
                else ...[
                  Text(
                    'Previous Requests',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Track each request and open accepted ones to view counselor details.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.68,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...requests.map(
                    (request) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _GuidanceRequestCard(
                        request: request,
                        onViewDetails: request.isAccepted
                            ? () => _openRequestDetails(request)
                            : null,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _GuidanceHeroCard extends StatelessWidget {
  const _GuidanceHeroCard({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onActionTap,
  });

  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF241A33),
                  Color(0xFF2B2040),
                  Color(0xFF1B2542),
                ],
              )
            : kHomeBrandGradient,
        boxShadow: [
          BoxShadow(
            color: (isDark ? UColors.primaryDark : UColors.primaryLight)
                .withOpacity(0.22),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -18,
            child: CircleAvatar(
              radius: 54,
              backgroundColor: Colors.white.withOpacity(0.10),
            ),
          ),
          Positioned(
            left: -18,
            bottom: -30,
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Colors.white.withOpacity(0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.white.withOpacity(0.92),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onActionTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark
                        ? UColors.primaryLight
                        : UColors.primary,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.65)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: Text(
                    actionLabel,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubscriptionPlansSection extends StatefulWidget {
  const _SubscriptionPlansSection({
    required this.plans,
    required this.selectedPlan,
    required this.isLoading,
    required this.onSelectPlan,
    required this.onSeeMore,
  });

  final List<SubscriptionPlan> plans;
  final SubscriptionPlan? selectedPlan;
  final bool isLoading;
  final ValueChanged<SubscriptionPlan> onSelectPlan;
  final ValueChanged<SubscriptionPlan> onSeeMore;

  @override
  State<_SubscriptionPlansSection> createState() =>
      _SubscriptionPlansSectionState();
}

class _SubscriptionPlansSectionState extends State<_SubscriptionPlansSection> {
  late final PageController _pageController;
  Timer? _autoSlideTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.86);
    // _startAutoSlide();
  }

  @override
  void didUpdateWidget(covariant _SubscriptionPlansSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    final selectedId = widget.selectedPlan?.id;
    if (selectedId != null) {
      final targetIndex = widget.plans.indexWhere(
        (plan) => plan.id == selectedId,
      );
      if (targetIndex >= 0 && targetIndex != _currentIndex) {
        _currentIndex = targetIndex;
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            targetIndex,
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
          );
        }
      }
    }

    // if (oldWidget.plans.length != widget.plans.length) {
    //   _restartAutoSlide();
    // }
  }

  @override
  void dispose() {
    // _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // void _startAutoSlide() {
  //   _autoSlideTimer?.cancel();
  //   _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (_) {
  //     if (!_pageController.hasClients || widget.plans.length < 2) return;

  //     final nextIndex = (_currentIndex + 1) % widget.plans.length;
  //     _pageController.animateToPage(
  //       nextIndex,
  //       duration: const Duration(milliseconds: 420),
  //       curve: Curves.easeInOutCubic,
  //     );
  //   });
  // }

  // void _restartAutoSlide() {
  //   _currentIndex = 0;
  //   _startAutoSlide();
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? UColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? UColors.darkBorder.withOpacity(0.80) : UColors.border,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: UColors.primary.withOpacity(0.10),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Subscription Support',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: theme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Subscription Plans',
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Pick a plan you want help with. We only show the key details here, and you can open more info for the full description.',
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.5,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.72),
            ),
          ),
          const SizedBox(height: 18),
          if (widget.isLoading)
            const SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (widget.plans.isEmpty)
            const _InlineNoticeCard(
              icon: Icons.subscriptions_outlined,
              title: 'Plans not available',
              description:
                  'We could not load subscription plans right now. Please try again in a moment.',
            )
          else
            Column(
              children: [
                SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.plans.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                      // widget.onSelectPlan(widget.plans[index]);
                    },
                    itemBuilder: (context, index) {
                      final plan = widget.plans[index];
                      final isSelected = widget.selectedPlan?.id == plan.id;

                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _PlanSliderCard(
                          plan: plan,
                          isSelected: isSelected,
                          onTap: () {
                            widget.onSelectPlan(plan);
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 320),
                              curve: Curves.easeOutCubic,
                            );
                          },
                          onSeeMore: () => widget.onSeeMore(plan),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.plans.length, (index) {
                    final isActive = index == _currentIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: isActive ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isActive
                            ? theme.primaryColor
                            : theme.primaryColor.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PlanSliderCard extends StatelessWidget {
  const _PlanSliderCard({
    required this.plan,
    required this.isSelected,
    required this.onTap,
    required this.onSeeMore,
  });

  final SubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onSeeMore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    UColors.primary,
                    UColors.primaryLight,
                    UColors.primaryDark,
                  ],
                )
              : null,
          color: isSelected
              ? null
              : (isDark ? const Color(0xFF1B1526) : UColors.softSurface),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark
                      ? UColors.darkBorder.withOpacity(0.70)
                      : UColors.border.withOpacity(0.90)),
            width: 1.2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: UColors.primaryLight.withOpacity(0.22),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (plan.isRecommended)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.18)
                          : theme.primaryColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Recommended',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : theme.primaryColor,
                      ),
                    ),
                  ),
                const Spacer(),
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isSelected
                      ? Colors.white
                      : theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                ),
              ],
            ),
            // const Spacer(),
            Text(
              plan.planName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? Colors.white
                    : theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _formatPlanPrice(plan.amount),
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : UColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatPlanDuration(plan.durationDays),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white.withOpacity(0.9)
                    : theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    isSelected
                        ? 'Selected for your request'
                        : 'Tap card to select',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white.withOpacity(0.92)
                          : theme.textTheme.bodyMedium?.color?.withOpacity(
                              0.68,
                            ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onSeeMore,
                  style: TextButton.styleFrom(
                    foregroundColor: isSelected
                        ? Colors.white
                        : theme.primaryColor,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'See more',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusStatCard extends StatelessWidget {
  const _StatusStatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? UColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? UColors.darkBorder.withOpacity(0.80) : UColors.border,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: UColors.primary.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: theme.primaryColor),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.68),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidanceRequestCard extends StatelessWidget {
  const _GuidanceRequestCard({
    required this.request,
    required this.onViewDetails,
  });

  final GuidanceRequestItem request;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = _statusColor(request.status);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? UColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? UColors.darkBorder.withOpacity(0.80) : UColors.border,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: UColors.primary.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request #${request.requestId}',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateTime(request.createdAt),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(label: request.statusLabel, color: statusColor),
            ],
          ),
          const SizedBox(height: 16),
          _LabelValueRow(
            label: 'Updated',
            value: _formatDateTime(request.updatedAt),
          ),
          if (request.subscriptionPlanName.isNotEmpty) ...[
            const SizedBox(height: 14),
            _LabelValueRow(label: 'Plan', value: request.subscriptionPlanName),
          ],
          const SizedBox(height: 14),
          Text(
            'Your message',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            request.message.isEmpty ? 'No message provided' : request.message,
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.5,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.78),
            ),
          ),
          const SizedBox(height: 16),
          if (onViewDetails != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onViewDetails,
                icon: const Icon(Icons.visibility_rounded),
                label: const Text('View Details'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          // else
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          //   decoration: BoxDecoration(
          //     color: statusColor.withOpacity(0.08),
          //     borderRadius: BorderRadius.circular(14),
          //   ),
          //   child: Text(
          //     request.isCounselorAssigned
          //         ? 'Counselor is assigned. Details will be available once the request is accepted.'
          //         : 'Your request is under review.',
          //     style: GoogleFonts.inter(
          //       fontSize: 12,
          //       fontWeight: FontWeight.w600,
          //       color: statusColor,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _GuidanceRequestDetailsSheet extends StatelessWidget {
  const _GuidanceRequestDetailsSheet({required this.requestFuture});

  final Future<GuidanceRequestItem> requestFuture;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF171717) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: FutureBuilder<GuidanceRequestItem>(
        future: requestFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 280,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return SizedBox(
              height: 280,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Unable to load request details',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            );
          }

          final request = snapshot.data!;
          final counselor = request.counselor;
          final statusColor = _statusColor(request.status);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Request Details',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _StatusBadge(
                      label: request.statusLabel,
                      color: statusColor,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _DetailSection(
                  title: 'Request info',
                  child: Column(
                    children: [
                      _DetailRow(
                        label: 'Request ID',
                        value: request.requestId.toString(),
                      ),
                      _DetailRow(
                        label: 'Created',
                        value: _formatDateTime(request.createdAt),
                      ),
                      _DetailRow(
                        label: 'Updated',
                        value: _formatDateTime(request.updatedAt),
                      ),
                      if ((request.acceptedAt ?? '').isNotEmpty)
                        _DetailRow(
                          label: 'Accepted at',
                          value: _formatDateTime(request.acceptedAt!),
                        ),
                      _DetailRow(
                        label: 'Student',
                        value: request.fullName.isEmpty
                            ? 'Not available'
                            : request.fullName,
                      ),
                      _DetailRow(
                        label: 'Mobile',
                        value: request.mobileNumber.isEmpty
                            ? 'Not available'
                            : request.mobileNumber,
                      ),
                      if (request.subscriptionPlanName.isNotEmpty)
                        _DetailRow(
                          label: 'Plan',
                          value: request.subscriptionPlanName,
                        ),
                      if (request.subscriptionPlanCode.isNotEmpty)
                        _DetailRow(
                          label: 'Plan code',
                          value: request.subscriptionPlanCode,
                        ),
                      if (request.email.isNotEmpty)
                        _DetailRow(label: 'Email', value: request.email),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _DetailSection(
                  title: 'Message',
                  child: Text(
                    request.message.isEmpty
                        ? 'No message provided'
                        : request.message,
                    style: GoogleFonts.inter(fontSize: 14, height: 1.5),
                  ),
                ),
                if ((request.counselorMessage ?? '').isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _DetailSection(
                    title: 'Counselor message',
                    child: Text(
                      request.counselorMessage!,
                      style: GoogleFonts.inter(fontSize: 14, height: 1.5),
                    ),
                  ),
                ],
                if (counselor != null) ...[
                  const SizedBox(height: 16),
                  _DetailSection(
                    title: 'Assigned Counsellor',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: theme.primaryColor.withOpacity(
                                0.12,
                              ),
                              backgroundImage: counselor.profileImage.isNotEmpty
                                  ? NetworkImage(counselor.profileImage)
                                  : null,
                              child: counselor.profileImage.isEmpty
                                  ? Icon(
                                      Icons.person_rounded,
                                      color: theme.primaryColor,
                                      size: 28,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Assigned Counsellor',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    counselor.publicName.isEmpty
                                        ? counselor.primarySpecialization
                                        : counselor.publicName,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: theme.textTheme.bodyMedium?.color
                                          ?.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _InfoChip(
                              icon: Icons.medical_services_outlined,
                              label: counselor.primarySpecialization.isEmpty
                                  ? 'General support'
                                  : counselor.primarySpecialization,
                            ),
                            _InfoChip(
                              icon: Icons.work_outline_rounded,
                              label: '${counselor.experienceYears} yrs exp',
                            ),
                            _InfoChip(
                              icon: Icons.star_rounded,
                              label: counselor.rating.toStringAsFixed(1),
                            ),
                            _InfoChip(
                              icon: Icons.circle,
                              label: counselor.availability,
                            ),
                          ],
                        ),
                        // const SizedBox(height: 16),
                        // if (counselor.email.isNotEmpty)
                        //   _DetailRow(label: 'Email', value: counselor.email),
                        // if ((counselor.mobileNumber ?? '').isNotEmpty)
                        //   _DetailRow(
                        //     label: 'Mobile',
                        //     value: counselor.mobileNumber!,
                        //   ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? UColors.darkCard : UColors.softSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? UColors.darkBorder.withOpacity(0.80) : UColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.65),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _LabelValueRow extends StatelessWidget {
  const _LabelValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 62,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineNoticeCard extends StatelessWidget {
  const _InlineNoticeCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? UColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? UColors.darkBorder.withOpacity(0.80) : UColors.border,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: UColors.primary.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: theme.primaryColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.5,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.68),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'accepted':
      return const Color(0xFF16A34A);
    case 'rejected':
      return const Color(0xFFDC2626);
    case 'cancelled':
      return const Color(0xFF6B7280);
    default:
      return const Color(0xFFF59E0B);
  }
}

String _formatDateTime(String raw) {
  if (raw.isEmpty) return 'Not available';

  final parsed = DateTime.tryParse(raw)?.toLocal();
  if (parsed == null) {
    return raw;
  }

  final date =
      '${parsed.day.toString().padLeft(2, '0')}/'
      '${parsed.month.toString().padLeft(2, '0')}/'
      '${parsed.year}';
  final hour = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;
  final minute = parsed.minute.toString().padLeft(2, '0');
  final period = parsed.hour >= 12 ? 'PM' : 'AM';

  return '$date, $hour:$minute $period';
}

String _formatPlanPrice(String value) {
  final amount = value.trim();
  if (amount.isEmpty) return 'Price on request';
  return amount.startsWith('₹') ? amount : '₹$amount';
}

String _formatPlanDuration(int days) {
  if (days <= 0) return 'Custom duration';
  if (days % 30 == 0) {
    final months = days ~/ 30;
    return months == 1 ? '1 month' : '$months months';
  }
  if (days % 7 == 0) {
    final weeks = days ~/ 7;
    return weeks == 1 ? '1 week' : '$weeks weeks';
  }
  return days == 1 ? '1 day' : '$days days';
}
