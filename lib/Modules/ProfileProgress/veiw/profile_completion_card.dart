import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controller/profile_progress_controller.dart';
import '../model/profile_section_model.dart';

class ProfileCompletionSlider extends StatefulWidget {
  const ProfileCompletionSlider({super.key});

  @override
  State<ProfileCompletionSlider> createState() =>
      _ProfileCompletionSliderState();
}

class _ProfileCompletionSliderState extends State<ProfileCompletionSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  Timer? _autoScrollTimer;
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    // Delay slightly to let the controller initialize
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_totalPages > 1 && _pageController.hasClients) {
        int nextPage = _currentPage + 1;
        if (nextPage >= _totalPages) {
          nextPage = 0;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn,
          );
        } else {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileProgressController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      if (controller.isProfileComplete) {
        return const SizedBox.shrink();
      }

      final cards = controller.incompleteSectionCards;
      _totalPages = 1 + cards.length;

      return Column(
        children: [
          // Wrap in Listener to pause auto-scroll on user interaction
          Listener(
            onPointerDown: (_) => _stopAutoScroll(),
            onPointerUp: (_) => _startAutoScroll(),
            child: SizedBox(
              height: 200, // Slightly taller for modern spacing
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                physics: const BouncingScrollPhysics(),
                children: [
                  _MainProgressCard(controller),
                  ...cards.map((e) => _SectionCard(e)),
                ],
              ),
            ),
          ),
          if (_totalPages > 1) ...[
            const SizedBox(height: 16),
            SmoothPageIndicator(
              controller: _pageController,
              count: _totalPages,
              effect: ExpandingDotsEffect(
                dotHeight: 6,
                dotWidth: 6,
                expansionFactor: 4,
                activeDotColor: theme.primaryColor,
                dotColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              ),
            ),
          ],
        ],
      );
    });
  }
}

// ───────── MAIN CARD ─────────
class _MainProgressCard extends StatelessWidget {
  final ProfileProgressController controller;
  const _MainProgressCard(this.controller);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return _BaseCard(
      child: Row(
        children: [
          // Circular Progress Section
          SizedBox(
            height: 90,
            width: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background Circle
                SizedBox(
                  height: 90,
                  width: 90,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 8,
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
                  ),
                ),
                // Actual Progress
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: controller.completionPercent),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, _) {
                    return SizedBox(
                      height: 90,
                      width: 90,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                        color: theme.primaryColor,
                      ),
                    );
                  },
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${controller.completionPercentInt}%",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Text Content
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Almost there!",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Complete your profile to unlock all insights.",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Get.toNamed('/profile'),
                    child: const Text("Finish Setup"),
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

// ───────── SECTION CARD ─────────
class _SectionCard extends StatelessWidget {
  final ProfileSectionCard data;
  const _SectionCard(this.data);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return _BaseCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(data.icon, color: theme.primaryColor, size: 28),
                ),
                const Spacer(),
                Text(
                  data.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 40,
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Get.toNamed(data.route),
                  child: const Text("Start"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// ───────── BASE CARD ─────────
class _BaseCard extends StatelessWidget {
  final Widget child;
  const _BaseCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
        ],
      ),
      child: child,
    );
  }
}