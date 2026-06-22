import 'dart:ui';
import 'package:Gixa/Modules/onbording/controller/onboarding_controller.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/routes/app_start_controller.dart';
import 'package:Gixa/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with TickerProviderStateMixin {
  final OnboardingController controller = Get.put(OnboardingController());
  late AnimationController _bgAnimationController;

  final Color primaryColor = UColors.primary;
  final Color accentColor = UColors.primaryLight;
  final Color secondaryColor = UColors.secondary;

  @override
  void initState() {
    super.initState();
    // Animation for the background blobs
    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF7),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Stack(
        children: [
          // ───────── 1. ANIMATED BACKGROUND ─────────
          // Top Left Blob
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              return Positioned(
                top: -100 + (_bgAnimationController.value * 50),
                left: -50 + (_bgAnimationController.value * 30),
                child: _BlurryBlob(
                  color: primaryColor.withOpacity(0.16),
                  size: 300,
                ),
              );
            },
          ),
          // Middle Right Blob
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              return Positioned(
                top: size.height * 0.3 + (_bgAnimationController.value * -40),
                right: -80,
                child: _BlurryBlob(
                  color: accentColor.withOpacity(0.16),
                  size: 250,
                ),
              );
            },
          ),
          // Bottom Left Blob
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              return Positioned(
                bottom: -50,
                left: -50 + (_bgAnimationController.value * -50),
                child: _BlurryBlob(
                  color: secondaryColor.withOpacity(0.14),
                  size: 350,
                ),
              );
            },
          ),

          // ───────── 2. MAIN CONTENT ─────────
          Column(
            children: [
              // --- TOP SECTION (Image & Skip) ---
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    // 1️⃣ PAGEVIEW FIRST (BACKGROUND)
                    PageView.builder(
                      controller: controller.pageController,
                      onPageChanged: controller.onPageChanged,
                      itemCount: controller.pages.length,
                      itemBuilder: (context, index) {
                        final item = controller.pages[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(28, 90, 28, 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.82),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(color: UColors.border),
                                  ),
                                  child: Text(
                                    item.badge,
                                    style: TextStyle(
                                      color: UColors.primaryDark,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.90),
                                        const Color(0xFFFFF1E6).withOpacity(0.92),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(36),
                                    border: Border.all(
                                      color: UColors.border,
                                      width: 1.4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.10),
                                        blurRadius: 30,
                                        offset: const Offset(0, 16),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Image.asset(
                                          item.image,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              primaryColor.withOpacity(0.12),
                                              accentColor.withOpacity(0.10),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                        child: Text(
                                          item.subtitle,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: UColors.primaryDark,
                                            letterSpacing: 0.2,
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
                      },
                    ),

                    Positioned(
                      top: 60,
                      right: 24,
                      child: Material(
                        color: Colors.transparent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: InkWell(
                              onTap: () {
                                Get.find<AppStartController>()
                                    .completeOnboarding();
                                Get.offAllNamed(AppRoutes.loginWithOtp);
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.70),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: UColors.border,
                                  ),
                                ),
                                child: Text(
                                  "Skip",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: UColors.primaryDark,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- BOTTOM SECTION (Glass Card) ---
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.88),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        border: Border(
                          top: BorderSide(
                            color: UColors.border.withOpacity(0.8),
                            width: 1.5,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.08),
                            blurRadius: 30,
                            offset: const Offset(0, -10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
                        child: Column(
                          children: [
                            // Text Content with Animation
                            Expanded(
                              child: Obx(() {
                                final index = controller.currentIndex.value;
                                final item = controller.pages[index];

                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  transitionBuilder:
                                      (
                                        Widget child,
                                        Animation<double> animation,
                                      ) {
                                        // Slide up and Fade
                                        final offsetAnimation = Tween<Offset>(
                                          begin: const Offset(0.0, 0.2),
                                          end: Offset.zero,
                                        ).animate(animation);
                                        return FadeTransition(
                                          opacity: animation,
                                          child: SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          ),
                                        );
                                      },
                                  child: Column(
                                    key: ValueKey<int>(index),
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                          color: UColors.primaryDark,
                                          height: 1.2,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        item.description,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          height: 1.6,
                                          color: const Color(0xFF6B7280),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),

                            // Bottom Controls
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Page Indicator
                                SmoothPageIndicator(
                                  controller: controller.pageController,
                                  count: controller.pages.length,
                                  effect: WormEffect(
                                    dotHeight: 10,
                                    dotWidth: 10,
                                    spacing: 12,
                                    activeDotColor: primaryColor,
                                    dotColor: UColors.border,
                                    type: WormType.thin,
                                  ),
                                ),

                                // Gradient Button
                                Obx(() {
                                  final bool isLast =
                                      controller.currentIndex.value ==
                                      controller.pages.length - 1;

                                  return InkWell(
                                    onTap: () {
                                      if (isLast) {
                                        Get.find<AppStartController>()
                                            .completeOnboarding();
                                        Get.offAllNamed(AppRoutes.loginWithOtp);
                                      } else {
                                        controller.nextPage();
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(50),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.elasticOut,
                                      height: 60,
                                      width: isLast ? 170 : 60,
                                      decoration: BoxDecoration(
                                        gradient: kHomeBrandGradient,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: UColors.primaryDark,
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryColor.withOpacity(
                                              0.4,
                                            ),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: isLast
                                          ? const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Get Started",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ],
                                            )
                                          : const Icon(
                                              Icons.arrow_forward_rounded,
                                              color: Colors.white,
                                              size: 26,
                                            ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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

// ───────── HELPER: BLURRY BLOB ─────────
class _BlurryBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _BlurryBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 60, spreadRadius: 20)],
      ),
    );
  }
}
