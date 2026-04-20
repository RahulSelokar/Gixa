import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/Profile/views/profile_screen.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/services/auth_guard.dart';
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
    final subscriptionController = Get.find<SubscriptionController>();

    return Obx(() {
      final profile = profileController.profile.value;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final greetingColor = isDark
          ? Colors.grey.shade400
          : Colors.grey.shade600;

      /// Check if user has active plan
      final isPremium = subscriptionController.activePlan.value != null;

      return InkWell(
        borderRadius: BorderRadius.circular(16),
        // onTap: () {
        //   Get.to(() => ProfilePage());
        // },
        onTap: () {
          AuthGuard.checkAccess(
            onAllowed: () {
              Get.to(() => ProfilePage());
            },
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// ───── PREMIUM PROFILE AVATAR ─────
            PremiumAvatar(
              isPremium: isPremium,
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
                children: [
                  Text(
                    "Hii 👋",
                    style: GoogleFonts.inter(
                      color: greetingColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    (profile?.user.firstName?.isNotEmpty == true)
                        ? profile!.user.firstName!
                        : "Student",
                    style: GoogleFonts.inter(
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

            /// 🔔 NOTIFICATION BELL
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

class PremiumAvatar extends StatefulWidget {
  final Widget child;
  final bool isPremium;

  const PremiumAvatar({
    super.key,
    required this.child,
    required this.isPremium,
  });

  @override
  State<PremiumAvatar> createState() => _PremiumAvatarState();
}

class _PremiumAvatarState extends State<PremiumAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPremium) {
      return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF1565C0).withOpacity(0.2),
            width: 2,
          ),
        ),
        child: widget.child,
      );
    }

    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  transform: GradientRotation(_controller.value * 6.28),
                  colors: const [
                    Color(0xFF1565C0),
                    Color(0xFF42A5F5),
                    Color(0xFF7E57C2),
                    Color(0xFF1565C0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1565C0).withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: widget.child,
            );
          },
        ),

        /// 👑 PREMIUM ICON BADGE
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Color(0xFFFFC107),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium,
              size: 12,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
