import 'dart:async';
// Added for the decorative circle
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
  final PageController _pageController = PageController(viewportFraction: 0.93);
  Timer? _autoScrollTimer;
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
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
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
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
            curve: Curves.easeInOutCubic,
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
          Listener(
            onPointerDown: (_) => _stopAutoScroll(),
            onPointerUp: (_) => _startAutoScroll(),
            child: SizedBox(
              height: 180, // Slightly taller for better spacing
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                physics: const BouncingScrollPhysics(),
                padEnds: false,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: _MainProgressCard(controller),
                  ),
                  ...cards.map((e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: _SectionCard(e),
                      )),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
          if (_totalPages > 1) ...[
            const SizedBox(height: 16),
            Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _totalPages,
                effect: ExpandingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  expansionFactor: 3,
                  spacing: 6,
                  activeDotColor: theme.primaryColor,
                  dotColor: isDark ? Colors.white24 : Colors.grey.shade300,
                ),
              ),
            ),
          ],
        ],
      );
    });
  }
}

// ───────── MAIN PROGRESS CARD (Premium/Dashboard Look) ─────────
class _MainProgressCard extends StatelessWidget {
  final ProfileProgressController controller;
  const _MainProgressCard(this.controller);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Using a Dark background for the main card (even in light mode) makes it pop
    // like a "Credit Card" or "Premium Feature".
    final cardBgColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFF1A237E); 
    final textColor = Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardBgColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative Background Circle
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "PROFILE STATUS",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getStrengthLabel(controller.completionPercent),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: cardBgColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          minimumSize: const Size(0, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Get.toNamed('/profile'),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Complete Now", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Circular Indicator
                const SizedBox(width: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(
                        value: 1,
                        strokeWidth: 8,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: controller.completionPercent),
                      duration: const Duration(seconds: 1),
                      builder: (context, value, _) => SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          value: value,
                          strokeWidth: 8,
                          strokeCap: StrokeCap.round,
                          color: Colors.greenAccent, // Distinct success color
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${controller.completionPercentInt}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStrengthLabel(double percent) {
    if (percent < 0.3) return "Beginner";
    if (percent < 0.6) return "Intermediate";
    if (percent < 0.9) return "Advanced";
    return "Excellent";
  }
}

// ───────── SECTION CARD (Task/Action Look) ─────────
class _SectionCard extends StatelessWidget {
  final ProfileSectionCard data;
  const _SectionCard(this.data);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Modern colors
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final iconBgColor = theme.primaryColor.withOpacity(0.08);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4), // Margin for shadow
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: const Color(0xFF90A4AE).withOpacity(0.15), // Blue-grey shadow
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Icon Box
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(data.icon, color: theme.primaryColor, size: 24),
              ),
              const SizedBox(width: 14),
              
              // 2. Title & Desc
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            data.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // "Time Estimate" Badge - Psychological trick
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, size: 10, color: Colors.orange),
                              const SizedBox(width: 2),
                              Text(
                                "1 min", // Dynamic?
                                style: TextStyle(fontSize: 10, color: Colors.orange[800], fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const Spacer(),
          
          // 3. Action Button (Full Width Tonal)
          SizedBox(
            width: double.infinity,
            height: 40,
            child: FilledButton.tonal(
              onPressed: () => Get.toNamed(data.route),
              style: FilledButton.styleFrom(
                backgroundColor: theme.primaryColor.withOpacity(0.08),
                foregroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Add Details", style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(width: 6),
                  Icon(Icons.add_circle_outline_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}