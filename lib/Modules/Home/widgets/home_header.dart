import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/Profile/views/profile_screen.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatelessWidget {
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;

  const HomeHeader({
    super.key,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    return Obx(() {
      final profile = profileController.profile.value;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final greetingColor = isDark
          ? Colors.grey.shade400
          : Colors.grey.shade600;

      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.to(() => ProfilePage());
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// ───── MODERN PROFILE AVATAR ─────
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF1565C0).withOpacity(0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 26,
                backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
                child: ClipOval(
                  child:
                      (profile?.profilePictureUrl != null &&
                          profile!.profilePictureUrl!.isNotEmpty)
                      ? Image.network(
                          profile.profilePictureUrl!,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, color: Colors.grey),
                        )
                      : Image.asset(
                          'assets/images/default_avatar.png',
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, color: Colors.grey),
                        ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            /// ───── GREETING & NAME ─────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hii 👋", // Or dynamic based on time
                    style: GoogleFonts.poppins(
                      color: greetingColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    profile?.user.firstName ?? "Student",
                    style: GoogleFonts.poppins(
                      color: textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            /// 🔔 NOTIFICATION BELL ─────
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.notifications);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade900 : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  ),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                  ],
                ),
                child: Badge(
                  backgroundColor: Colors.redAccent,
                  smallSize: 8,
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: textPrimary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
