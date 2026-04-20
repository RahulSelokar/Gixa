import 'dart:ui';
import 'package:Gixa/Modules/Collage/controller/collage_list_controller.dart';
import 'package:Gixa/Modules/Collage/widgets/collage_list_simmer.dart';
import 'package:Gixa/Modules/Collage/widgets/filter_bar.dart';
import 'package:Gixa/Modules/comparison/controller/college_compare_controller.dart';
import 'package:Gixa/Modules/seatMatrix/controller/seat_matrix_controller.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/Modules/subscription/features/feature_names.dart';
import 'package:Gixa/common/widgets/primeum_dailog.dart';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../../routes/app_routes.dart';

// ── Free colleges limit ───────────────────────────────────────────────────────
const int kFreeCollegeLimit = 2;

class CollegeListPage extends StatefulWidget {
  CollegeListPage({super.key});

  @override
  State<CollegeListPage> createState() => _CollegeListPageState();
}

class _CollegeListPageState extends State<CollegeListPage> {
  final controller = Get.put(CollegeListController());
  final comapreController = Get.find<CollegeCompareController>();
  final navController = Get.find<MainNavController>();
  final seatController = Get.put(SeatMatrixController());
  final subscriptionController = Get.find<SubscriptionController>();

  static const kPrimaryBlue = Color(0xFF1565C0);
  // ── Add these to your state class ────────────────────────────────
  int _activeFilterCount = 0;
  bool _isSortActive = false;
  bool _isStateActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      comapreController.selectedColleges.clear();
    });
  }

  void _openFilterSheet() {
    String? state;
    String? instituteType;
    String? year;
    String? quota;
    String? round;
    int? minSeats;
    int? maxSeats;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (context, setStateSheet) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      hint: Text('state'.tr),
                      items: ["Maharashtra", "Delhi", "Karnataka"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => state = v.toString(),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField(
                      hint: Text('institute_type'.tr),
                      items: ["Private", "Government"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => instituteType = v.toString(),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      decoration: InputDecoration(labelText: 'min_seats'.tr),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => minSeats = int.tryParse(v),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      decoration: InputDecoration(labelText: 'max_seats'.tr),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => maxSeats = int.tryParse(v),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('cancel'.tr),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              controller.applyFilters(
                                stateValue: state,
                                instituteTypeValue: instituteType,
                                yearValue: year,
                                quotaValue: quota,
                                roundValue: round,
                                minSeatsValue: minSeats,
                                maxSeatsValue: maxSeats,
                              );

                              setState(() {
                                _activeFilterCount = [
                                  state,
                                  instituteType,
                                  year,
                                  quota,
                                  round,
                                  minSeats,
                                  maxSeats,
                                ].where((e) => e != null).length;
                              });

                              Navigator.pop(context);
                            },
                            child: Text('apply_filters'.tr),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FD);
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111111);
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final iconBoxColor = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFF0F4F8);

    return WillPopScope(
      onWillPop: () async {
        comapreController.selectedColleges.clear();
        return true;
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text(
            'top_institutes'.tr,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: textColor,
            ),
          ),
          backgroundColor: surfaceColor,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: textColor),
          scrolledUnderElevation: 0,
          actions: [
            Obx(() {
              if (comapreController.selectedColleges.length == 2) {
                return IconButton(
                  tooltip: 'compare_colleges'.tr,
                  icon: const Icon(Icons.compare_arrows),
                  onPressed: () {
                    final codes = List<String>.from(
                      comapreController.selectedColleges,
                    );
                    Get.toNamed(
                      AppRoutes.compareCollage,
                      arguments: {'collegeCodes': codes},
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            }),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Get.toNamed(AppRoutes.search),
            ),
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () => Get.toNamed(AppRoutes.fevouriteCollage),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            FilterBar(
              // ← use whatever class name you gave it
              isDark: isDark,
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              activeFilterCount: _activeFilterCount,
              isSortActive: _isSortActive,
              isStateActive: _isStateActive,
              onSortTap: () => setState(() => _isSortActive = !_isSortActive),
              onFilterTap: () {
                _openFilterSheet();
              },
              onStateTap: () =>
                  setState(() => _isStateActive = !_isStateActive),
            ),

            Divider(height: 1, thickness: 0.5, color: borderColor),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.colleges.isEmpty) {
                  return CollegeListShimmer(isDark: isDark);
                }

                if (controller.colleges.isEmpty) {
                  return LiquidPullToRefresh(
                    color: kPrimaryBlue,
                    onRefresh: () async {
                      comapreController.selectedColleges.clear();
                      await controller.refreshList();
                    },
                    height: 110,
                    animSpeedFactor: 2.5,
                    showChildOpacityTransition: false,
                    springAnimationDurationInMilliseconds: 500,
                    child: NotificationListener<UserScrollNotification>(
                      onNotification: (n) {
                        navController.updateScroll(n.direction);
                        return false;
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: _buildEmptyState(subTextColor),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Total list items: 2 free cards + lock wall + locked ghost cards
                final freeCount = kFreeCollegeLimit.clamp(
                  0,
                  controller.colleges.length,
                );
                final lockedCount = controller.colleges.length - freeCount;

                // items = free cards + 1 lockwall + ghost placeholders (max 3 visible)
                final ghostCount = lockedCount.clamp(0, 3);
                final hasCollegeListAccess =
                    subscriptionController.activePlan.value != null &&
                    subscriptionController.hasFeature(
                      FeatureNames.selectedStateCollegeList,
                    );

                final totalItems = hasCollegeListAccess
                    ? controller.colleges.length
                    : freeCount + 1 + ghostCount; // +1 for lock wall

                return LiquidPullToRefresh(
                  color: kPrimaryBlue,
                  onRefresh: controller.refreshList,
                  height: 50,
                  animSpeedFactor: 2.5,
                  showChildOpacityTransition: false,
                  springAnimationDurationInMilliseconds: 500,
                  child: NotificationListener<UserScrollNotification>(
                    onNotification: (n) {
                      navController.updateScroll(n.direction);
                      return false;
                    },
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                      itemCount: totalItems,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        // ── Free cards (index 0..freeCount-1) ──────────────────
                        if (hasCollegeListAccess || index < freeCount) {
                          final college = controller.colleges[index];
                          return _CollegeCard(
                            college: college,
                            isDark: isDark,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            subTextColor: subTextColor,
                            borderColor: borderColor,
                            iconBoxColor: iconBoxColor,
                            comapreController: comapreController,
                            onTap: () => Get.toNamed(
                              AppRoutes.collageDetails,
                              arguments: {'collegeId': college.id},
                            ),
                          );
                        }

                        // ── Lock wall (index == freeCount) ──────────────────────
                        if (index == freeCount) {
                          return _ChainLockWall(
                            isDark: isDark,
                            lockedCount: lockedCount,
                            onUnlock: () {
                              HapticFeedback.mediumImpact();
                              showPremiumLockDialog(context);
                            },
                          );
                        }

                        // ── Ghost / blurred teaser cards ────────────────────────
                        return _GhostCollegeCard(
                          isDark: isDark,
                          opacity: 1.0 - ((index - freeCount - 1) * 0.28),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            showPremiumLockDialog(context);
                          },
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color subTextColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school_outlined, size: 60, color: subTextColor),
          ),
          const SizedBox(height: 24),
          Text(
            'no_colleges_found'.tr,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: subTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'adjust_filters'.tr,
            style: GoogleFonts.inter(color: subTextColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  CHAIN LOCK WALL — animated chains + lock icon + CTA
// ─────────────────────────────────────────────────────────────────────────────
class _ChainLockWall extends StatefulWidget {
  final bool isDark;
  final int lockedCount;
  final VoidCallback onUnlock;

  const _ChainLockWall({
    required this.isDark,
    required this.lockedCount,
    required this.onUnlock,
  });

  @override
  State<_ChainLockWall> createState() => _ChainLockWallState();
}

class _ChainLockWallState extends State<_ChainLockWall>
    with TickerProviderStateMixin {
  // ── Lock entrance bounce ──────────────────────────────────────
  late final AnimationController _lockCtrl;
  late final Animation<double> _lockScale;
  late final Animation<double> _lockRotate;

  // ── Chains swing left & right ────────────────────────────────
  late final AnimationController _chainCtrl;
  late final Animation<double> _chainLeft;
  late final Animation<double> _chainRight;

  // ── Pulse glow on lock ───────────────────────────────────────
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulse;

  // ── Staggered content fade-up ────────────────────────────────
  late final AnimationController _contentCtrl;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  // ── CTA press ────────────────────────────────────────────────
  bool _pressed = false;

  static const _kBlue = Color(0xFF1565C0);

  @override
  void initState() {
    super.initState();

    // Lock bounce
    _lockCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _lockScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _lockCtrl, curve: Curves.elasticOut));
    _lockRotate = Tween<double>(
      begin: -0.2,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _lockCtrl, curve: Curves.easeOutCubic));

    // Chains swing — repeating pendulum
    _chainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _chainLeft = Tween<double>(
      begin: -0.12,
      end: 0.06,
    ).animate(CurvedAnimation(parent: _chainCtrl, curve: Curves.easeInOut));
    _chainRight = Tween<double>(
      begin: 0.12,
      end: -0.06,
    ).animate(CurvedAnimation(parent: _chainCtrl, curve: Curves.easeInOut));

    // Pulse glow
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // Content stagger
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _contentFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut));
    _contentSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOutCubic),
        );

    // Fire animations
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _lockCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _contentCtrl.forward();
    });
  }

  @override
  void dispose() {
    _lockCtrl.dispose();
    _chainCtrl.dispose();
    _pulseCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [const Color(0xFF1A1A2E), const Color(0xFF12122A)]
              : [const Color(0xFFEEF2FF), const Color(0xFFE8EDFF)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _kBlue.withOpacity(isDark ? 0.35 : 0.22),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: _kBlue.withOpacity(0.14),
            blurRadius: 24,
            spreadRadius: -6,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // ── Decorative bg circles ──────────────────────────
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kBlue.withOpacity(0.07),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kBlue.withOpacity(0.05),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
              child: Column(
                children: [
                  // ── Chains + Lock ────────────────────────────
                  SizedBox(
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Left chain
                        Positioned(
                          left: 50,
                          top: 0,
                          child: AnimatedBuilder(
                            animation: _chainCtrl,
                            builder: (_, child) => Transform.rotate(
                              angle: _chainLeft.value,
                              alignment: Alignment.topCenter,
                              child: child,
                            ),
                            child: _ChainWidget(isDark: isDark, flipped: false),
                          ),
                        ),
                        // Right chain
                        Positioned(
                          right: 50,
                          top: 0,
                          child: AnimatedBuilder(
                            animation: _chainCtrl,
                            builder: (_, child) => Transform.rotate(
                              angle: _chainRight.value,
                              alignment: Alignment.topCenter,
                              child: child,
                            ),
                            child: _ChainWidget(isDark: isDark, flipped: true),
                          ),
                        ),

                        // Pulse glow behind lock
                        AnimatedBuilder(
                          animation: _pulseCtrl,
                          builder: (_, __) => Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _kBlue.withOpacity(_pulse.value * 0.15),
                            ),
                          ),
                        ),

                        // Lock icon
                        AnimatedBuilder(
                          animation: _lockCtrl,
                          builder: (_, child) => Transform.rotate(
                            angle: _lockRotate.value,
                            child: Transform.scale(
                              scale: _lockScale.value,
                              child: child,
                            ),
                          ),
                          child: Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  _kBlue.withOpacity(0.9),
                                  const Color(0xFF0D47A1).withOpacity(0.95),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _kBlue.withOpacity(0.45),
                                  blurRadius: 20,
                                  spreadRadius: -4,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.lock_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ── Text + CTA ───────────────────────────────
                  FadeTransition(
                    opacity: _contentFade,
                    child: SlideTransition(
                      position: _contentSlide,
                      child: Column(
                        children: [
                          Text(
                            '${widget.lockedCount} Colleges Locked',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A1A2E),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Upgrade to Premium to unlock all\nmedical colleges & detailed insights',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              height: 1.55,
                              color: isDark ? Colors.white54 : Colors.grey[600],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Perk chips
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              _perkChip('all_colleges'.tr, isDark),
                              _perkChip('cutoff_data'.tr, isDark),
                              _perkChip('ai_predictor'.tr, isDark),
                              _perkChip('seat_matrix'.tr, isDark),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // CTA Button
                          GestureDetector(
                            onTapDown: (_) {
                              HapticFeedback.lightImpact();
                              setState(() => _pressed = true);
                            },
                            onTapUp: (_) {
                              setState(() => _pressed = false);
                              widget.onUnlock();
                            },
                            onTapCancel: () => setState(() => _pressed = false),
                            child: AnimatedScale(
                              scale: _pressed ? 0.96 : 1.0,
                              duration: const Duration(milliseconds: 110),
                              curve: Curves.easeOut,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 160),
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF1976D2),
                                      Color(0xFF1565C0),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _kBlue.withOpacity(
                                        _pressed ? 0.20 : 0.42,
                                      ),
                                      blurRadius: _pressed ? 8 : 18,
                                      spreadRadius: -4,
                                      offset: Offset(0, _pressed ? 2 : 7),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.lock_open_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'unlock_all_colleges'.tr,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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

  Widget _perkChip(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _kBlue.withOpacity(isDark ? 0.18 : 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBlue.withOpacity(0.25), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded, size: 11, color: Color(0xFF1565C0)),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1565C0),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  CHAIN SVG WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class _ChainWidget extends StatelessWidget {
  final bool isDark;
  final bool flipped;

  const _ChainWidget({required this.isDark, required this.flipped});

  @override
  Widget build(BuildContext context) {
    final linkColor = isDark
        ? const Color(0xFF3A4A6B)
        : const Color(0xFFBBCCEE);
    final highlightColor = isDark
        ? const Color(0xFF4A5C7D)
        : const Color(0xFFCCDDFF);

    return Transform.scale(
      scaleX: flipped ? -1 : 1,
      child: SizedBox(
        width: 28,
        height: 90,
        child: CustomPaint(
          painter: _ChainPainter(
            linkColor: linkColor,
            highlightColor: highlightColor,
          ),
        ),
      ),
    );
  }
}

class _ChainPainter extends CustomPainter {
  final Color linkColor;
  final Color highlightColor;

  _ChainPainter({required this.linkColor, required this.highlightColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = linkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final highlightPaint = Paint()
      ..color = highlightColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Draw 4 chain links vertically
    const linkH = 18.0;
    const linkW = 14.0;
    const cx = 14.0;

    for (int i = 0; i < 5; i++) {
      final top = i * linkH;
      final bottom = top + linkH - 3;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - linkW / 2, top, linkW, bottom - top),
        const Radius.circular(7),
      );
      canvas.drawRRect(rect, paint);

      // Highlight shimmer line
      canvas.drawLine(
        Offset(cx - linkW / 2 + 3, top + 4),
        Offset(cx - linkW / 2 + 3, bottom - 4),
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ChainPainter old) =>
      old.linkColor != linkColor || old.highlightColor != highlightColor;
}

// ─────────────────────────────────────────────────────────────────────────────
//  GHOST / BLURRED COLLEGE CARD  (teaser cards below lock wall)
// ─────────────────────────────────────────────────────────────────────────────
class _GhostCollegeCard extends StatelessWidget {
  final bool isDark;
  final double opacity;
  final VoidCallback onTap;

  const _GhostCollegeCard({
    required this.isDark,
    required this.opacity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.05, 1.0),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Blurred skeleton
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 11,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.22),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 9,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.16),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 9,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 9,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Dark veil
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withOpacity(0.45)
                        : Colors.white.withOpacity(0.50),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.lock_rounded,
                      size: 22,
                      color: const Color(0xFF1565C0).withOpacity(0.60),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FREE COLLEGE CARD
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
//  COLLEGE CARD — Careers360 style
// ─────────────────────────────────────────────────────────────────────────────
class _CollegeCard extends StatefulWidget {
  final dynamic college;
  final bool isDark;
  final Color surfaceColor, textColor, subTextColor, borderColor, iconBoxColor;
  final CollegeCompareController comapreController;
  final VoidCallback onTap;

  const _CollegeCard({
    required this.college,
    required this.isDark,
    required this.surfaceColor,
    required this.textColor,
    required this.subTextColor,
    required this.borderColor,
    required this.iconBoxColor,
    required this.comapreController,
    required this.onTap,
  });

  @override
  State<_CollegeCard> createState() => _CollegeCardState();
}

class _CollegeCardState extends State<_CollegeCard> {
  bool _bookmarked = false;
  static const _kBlue = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    final c = widget.college;
    final isDark = widget.isDark;

    // ── Safe data reads ───────────────────────────────────────────
    final String name = c.name ?? 'unknown_college'.tr;
    final String? stateName = c.state?.name;
    final String? typeLabel = c.instituteType?.name;
    final int? yearEst = c.yearEstablished;
    final String? coverImage = c.displayImage;
    final int? totalSeats = c.totalSeats;
    final bool hostelAvail = c.hostelAvailable ?? false;
    final String? hostelFor = c.hostelFor;

    final List ugCourses = c.courses?.ug ?? [];
    final List pgCourses = c.courses?.pg ?? [];

    final String ugText = ugCourses.isNotEmpty
        ? ugCourses.map((e) => e.name ?? e.courseName ?? '').join(', ')
        : '';
    final String pgText = pgCourses.isNotEmpty
        ? pgCourses.map((e) => e.name ?? e.courseName ?? '').join(', ')
        : '';

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: widget.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: widget.borderColor),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. COVER IMAGE ────────────────────────────────────
            Stack(
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: coverImage != null && coverImage.isNotEmpty
                      ? Image.network(
                          coverImage,
                          height: 170,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return _ImagePlaceholder(isDark: isDark);
                          },
                          errorBuilder: (_, __, ___) =>
                              _ImagePlaceholder(isDark: isDark),
                        )
                      : _ImagePlaceholder(isDark: isDark),
                ),

                // ── Bookmark button (top-right) ───────────────────
                // Positioned(
                //   top: 10,
                //   right: 10,
                //   child: GestureDetector(
                //     onTap: () {
                //       HapticFeedback.lightImpact();
                //       setState(() => _bookmarked = !_bookmarked);
                //     },
                //     child: AnimatedContainer(
                //       duration: const Duration(milliseconds: 200),
                //       width: 36,
                //       height: 36,
                //       decoration: BoxDecoration(
                //         color: _bookmarked
                //             ? _kBlue
                //             : Colors.white.withOpacity(0.92),
                //         shape: BoxShape.circle,
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black.withOpacity(0.12),
                //             blurRadius: 8,
                //           ),
                //         ],
                //       ),
                //       child: Icon(
                //         _bookmarked
                //             ? Icons.bookmark_rounded
                //             : Icons.bookmark_border_rounded,
                //         size: 18,
                //         color: _bookmarked ? Colors.white : Colors.grey[700],
                //       ),
                //     ),
                //   ),
                // ),

                // ── Institute type badge (bottom-left over image) ─
                if (typeLabel != null)
                  Positioned(
                    bottom: 10,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _kBlue,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Text(
                        typeLabel,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // ── 2. COLLEGE NAME ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _kBlue,
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // ── 3. STATE + YEAR (only if not null) ────────────────
            if (stateName != null || yearEst != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 5, 14, 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: widget.subTextColor,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        [
                          if (stateName != null) stateName,
                          if (yearEst != null) 'Est. $yearEst',
                        ].join(' • '),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: widget.subTextColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // ── 4. INFO ROW: Exams | Degrees (Careers360 style) ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.04)
                      : const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: widget.borderColor),
                ),
                child: Row(
                  children: [
                    // Exams / Courses left col
                    Expanded(
                      child: _InfoBlock(
                        label: 'Degrees & Courses',
                        value: _buildCourseText(ugText, pgText),
                        icon: Icons.school_outlined,
                        subTextColor: widget.subTextColor,
                        textColor: widget.textColor,
                      ),
                    ),

                    // Divider
                    Container(width: 1, height: 36, color: widget.borderColor),

                    // Seats right col (only if not null)
                    Expanded(
                      child: _InfoBlock(
                        label: 'total_seats'.tr,
                        value: totalSeats != null && totalSeats > 0
                            ? totalSeats.toString()
                            : 'N/A',
                        icon: Icons.event_seat_outlined,
                        subTextColor: widget.subTextColor,
                        textColor: widget.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── 5. HOSTEL CHIP (only if hostelAvailable == true) ──
            if (hostelAvail) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.25)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 13,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        hostelFor != null && hostelFor.isNotEmpty
                            ? 'Hostel: $hostelFor'
                            : 'hostel_available'.tr,
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 12),

            // ── 6. BOTTOM CTA ─────────────────────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              width: double.infinity,
              height: 42,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : _kBlue.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _kBlue.withOpacity(isDark ? 0.2 : 0.15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'view_institute'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : _kBlue,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: isDark ? Colors.white70 : _kBlue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildCourseText(String ug, String pg) {
    if (ug.isNotEmpty && pg.isNotEmpty) return '$ug • $pg';
    if (ug.isNotEmpty) return ug;
    if (pg.isNotEmpty) return pg;
    return 'N/A';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  INFO BLOCK — reusable label + value column inside the info row
// ─────────────────────────────────────────────────────────────────────────────
class _InfoBlock extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color subTextColor;
  final Color textColor;

  const _InfoBlock({
    required this.label,
    required this.value,
    required this.icon,
    required this.subTextColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: subTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  IMAGE PLACEHOLDER — shown while loading or on error
// ─────────────────────────────────────────────────────────────────────────────
class _ImagePlaceholder extends StatelessWidget {
  final bool isDark;

  const _ImagePlaceholder({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFDCEEFF),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Icon(
        Icons.school_rounded,
        size: 52,
        color: const Color(0xFF1565C0).withOpacity(0.25),
      ),
    );
  }
}
