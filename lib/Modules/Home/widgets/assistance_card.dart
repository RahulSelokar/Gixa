import 'package:Gixa/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/home_controller.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';

class AssistanceCard extends StatelessWidget {
  const AssistanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    const Color kPrimaryBrown = Color.fromARGB(255, 236, 139, 4);

    return Obx(() {
      final hasAccess = controller.canAccessCounsellingSteps();

      // ðŸŽ¨ Dynamic Colors based on feature access
      final gradientColors = hasAccess
          ? [kPrimaryBrown, kPrimaryBrown.withOpacity(0.85)]
          : [kPrimaryBrown.withOpacity(0.6), kPrimaryBrown.withOpacity(0.9)];

      final shadowColor = kPrimaryBrown.withOpacity(0.35);
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
                AppSnackbar.show(
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
                border: Border.all(color: Colors.white.withOpacity(0.1)),
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
                          color: Colors.white.withOpacity(0.15),
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
                          color: Colors.white.withOpacity(0.15),
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

