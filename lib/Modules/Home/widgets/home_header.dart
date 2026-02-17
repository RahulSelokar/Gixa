import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/Profile/views/profile_screen.dart';
import 'package:Gixa/Modules/settings/view/langauge_page.dart';
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

      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.to(() =>  ProfilePage());
        },
        child: Row(
          children: [
            /// ───── PROFILE IMAGE (FROM PROFILE MODEL) ─────
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: (profile?.profilePictureUrl != null &&
                      profile!.profilePictureUrl!.isNotEmpty)
                  ? NetworkImage(
                      profile.profilePictureUrl!,
                    )
                  : const AssetImage(
                      'assets/images/default_avatar.png',
                    ) as ImageProvider,
            ),

            const SizedBox(width: 12),

            /// ───── TEXT ─────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello 👋",
                  style: GoogleFonts.poppins(
                    color: textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  profile?.user.firstName ?? "User",
                  style: GoogleFonts.poppins(
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Spacer(),

            /// 🔔 Notification icon
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.notifications);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: textPrimary,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
