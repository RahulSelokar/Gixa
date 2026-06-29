import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/Profile/views/profile_screen.dart';
import 'package:Gixa/Modules/notification/controller/alerts_controller.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:Gixa/common/utils/app_responsive.dart';
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
    final profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());
    final alertsController = Get.isRegistered<AlertsController>()
        ? Get.find<AlertsController>()
        : Get.put(AlertsController());
    final subscriptionController = Get.isRegistered<SubscriptionController>()
        ? Get.find<SubscriptionController>()
        : Get.put(SubscriptionController());

    return Obx(() {
      final profile = profileController.profile.value;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final isTablet = AppResponsive.isTablet(context);
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
                radius: isTablet ? 30 : 26,
                backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
                child: ClipOval(
                  child:
                      (profile?.profilePictureUrl != null &&
                          profile!.profilePictureUrl!.isNotEmpty)
                      ? Image.network(
                          profile.profilePictureUrl!,
                          width: isTablet ? 60 : 52,
                          height: isTablet ? 60 : 52,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, color: Colors.grey),
                        )
                      : Image.asset(
                          profileController.genderValue.value == 'F'
                              ? 'assets/images/female_avtar.png'
                              : profileController.genderValue.value == 'M'
                              ? 'assets/images/male_avtar.png'
                              : 'assets/images/default_avatar.png',

                          width: isTablet ? 60 : 52,
                          height: isTablet ? 60 : 52,
                          fit: BoxFit.cover,

                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, color: Colors.grey),
                        ),
                ),
              ),
            ),

            SizedBox(width: isTablet ? 18 : 14),

            /// ───── GREETING & NAME ─────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hii 👋",
                    style: GoogleFonts.inter(
                      color: greetingColor,
                      fontSize: isTablet ? 14 : 13,
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
                      fontSize: isTablet ? 20 : 18,
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
                AuthGuard.checkAccess(
                  onAllowed: () {
                    Get.toNamed(AppRoutes.alerts);
                  },
                );
              },
              child: Obx(() {
                return Badge(
                  isLabelVisible: alertsController.alertCount.value > 0,
                  backgroundColor: Colors.redAccent,
                  offset: const Offset(-2, 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  label: Text(
                    alertsController.alertCount.value > 99
                        ? '99+'
                        : alertsController.alertCount.value.toString(),
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(isTablet ? 12 : 10),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade900 : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      ),
                    ),
                    child: Icon(
                      Icons.notifications_none,
                      color: textPrimary,
                      size: isTablet ? 26 : 24,
                    ),
                  ),
                );
              }),
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
            color: kHomeAccentColor.withOpacity(0.2),
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
                    kHomeAccentColor,
                    Color(0xFFF59E0B),
                    Color(0xFFD97706),
                    kHomeAccentColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: kHomeAccentColor.withOpacity(0.5),
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
