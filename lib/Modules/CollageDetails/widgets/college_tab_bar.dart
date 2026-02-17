import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:Gixa/Modules/CollageDetails/controller/collage_detail_controller.dart';

class CollegeTabs extends GetView<CollegeDetailController> {
  const CollegeTabs({super.key});

  static const List<String> tabs = [
    "Overview",
    "Courses",
    "Fees",
    "Cutoffs",
    "Reviews",
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme Colors
    final Color kPrimaryBlue = const Color(0xFF2979FF); // More vibrant blue
    final Color inactiveText = isDark ? Colors.grey[500]! : Colors.grey[600]!;
    final Color borderColor = isDark ? const Color(0xFF333333) : Colors.grey.shade200;
    final Color backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;

    return Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 48, // Increased height slightly for better touch target
            child: Obx(() {
              final selectedIndex = controller.selectedTabIndex.value;

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                // Add padding to the start/end of list so it doesn't touch screen edges
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 32),
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  final isPremium = tabs[index] == "Fees" || tabs[index] == "Cutoffs";

                  return GestureDetector(
                    onTap: () => controller.changeTab(index),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Row(
                          children: [
                            // Tab Text with Animation
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected ? kPrimaryBlue : inactiveText,
                              ),
                              child: Text(tabs[index]),
                            ),
                            
                            // Optional: Lock Icon for Premium Tabs
                            if (isPremium) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.lock_outline_rounded,
                                size: 12,
                                color: isSelected 
                                    ? kPrimaryBlue.withOpacity(0.8) 
                                    : inactiveText.withOpacity(0.6),
                              )
                            ]
                          ],
                        ),
                        const Spacer(),
                        
                        // Animated Underline Indicator
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          height: 3,
                          width: isSelected ? 24 : 0, // Grows from 0 to 24
                          decoration: BoxDecoration(
                            color: kPrimaryBlue,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          // Bottom Divider
          Container(
            height: 1,
            width: double.infinity,
            color: borderColor,
          ),
        ],
      ),
    );
  }
}