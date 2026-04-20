import 'package:Gixa/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/home_controller.dart';

class AssistanceCard extends StatelessWidget {
  const AssistanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final hasAccess = controller.canAccessCounsellingSteps();

      // 🎨 Dynamic Colors based on feature access
      final gradientColors = hasAccess
          ? [const Color(0xFF4F46E5), const Color(0xFF818CF8)] // Indigo
          : [const Color(0xFFF59E0B), const Color(0xFFD97706)]; // Gold

      final shadowColor = hasAccess
          ? const Color(0xFF4F46E5).withOpacity(0.4)
          : const Color(0xFFF59E0B).withOpacity(0.4);

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              if (hasAccess) {
                Get.toNamed(AppRoutes.assistance);
              } else {
                Get.toNamed(AppRoutes.subscription);
                Get.snackbar(
                  "Premium Feature",
                  "Upgrade to unlock expert Admission Assistance.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFF1F2937),
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  icon: const Icon(Icons.star, color: Colors.amber),
                  duration: const Duration(seconds: 4),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                  ),

                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          hasAccess
                              ? Icons.support_agent_rounded
                              : Icons.lock_outline_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Admission Assistance",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hasAccess
                                  ? "Get expert counselling now"
                                  : "Tap to unlock premium support",
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
