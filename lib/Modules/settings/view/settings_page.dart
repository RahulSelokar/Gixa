import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/Profile/views/logout_dailog.dart';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/services/app_verification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:Gixa/utils/themes/theme_controller.dart';

// 🔥 GIXA COLORS (LOCAL)
class _GixaColors {
  static const Color orange = Color(0xFFFF8A00);
  static const Color pink = Color(0xFFFF3D6B);
  static const Color purple = Color(0xFF7B3FE4);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [orange, pink, purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient softGradient = LinearGradient(
    colors: [Color(0x26FF8A00), Color(0x26FF3D6B), Color(0x267B3FE4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AccountManageScreen extends StatefulWidget {
  AccountManageScreen({super.key});

  @override
  State<AccountManageScreen> createState() => _AccountManageScreenState();
}

class _AccountManageScreenState extends State<AccountManageScreen> {
  String appVersion = '';

  final ProfileController controller = Get.find<ProfileController>();
  final MainNavController navController = Get.find<MainNavController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;

    if (!mounted) return;

    setState(() {
      appVersion = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color bgColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF8F9FD);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "account".tr,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: theme.textTheme.bodyLarge!.color,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction != ScrollDirection.idle) {
              navController.updateScroll(notification.direction);
            }
            return false;
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            // padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                /// 🔹 PROFILE HEADER
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),

                    /// 🔥 PREMIUM SHADOW (brand glow)
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black26
                            : const Color(0xFFFF3D6B).withOpacity(0.25),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                    ],

                    /// 🔥 GIXA GRADIENT
                    gradient: isDark
                        ? const LinearGradient(
                            colors: [Color(0xFF1E1E2E), Color(0xFF12121A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : const LinearGradient(
                            colors: [
                              Color(0xFFFF8A00), // orange
                              Color(0xFFFF3D6B), // pink
                              Color(0xFF7B3FE4), // purple
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                  ),

                  child: Row(
                    children: [
                      /// 🔥 PROFILE IMAGE WITH GLOW
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF8A00),
                              Color(0xFFFF3D6B),
                              Color(0xFF7B3FE4),
                            ],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.white.withOpacity(0.15),
                          backgroundImage: controller.profileImage.isNotEmpty
                              ? NetworkImage(controller.profileImage)
                              : null,
                          child: controller.profileImage.isEmpty
                              ? ClipOval(
                                  child: Image.asset(
                                    controller.genderValue.value == 'F'
                                        ? 'assets/images/female_avtar.png'
                                        : controller.genderValue.value == 'M'
                                        ? 'assets/images/male_avtar.png'
                                        : 'assets/images/default_avatar.png',

                                    fit: BoxFit.cover,
                                    width: 76,
                                    height: 76,
                                  ),
                                )
                              : null,
                        ),
                      ),

                      const SizedBox(width: 20),

                      /// 🔥 USER INFO
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// NAME
                            Text(
                              controller.fullName.isEmpty
                                  ? 'student'.tr
                                  : controller.fullName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 4),

                            /// MOBILE
                            Text(
                              controller.mobile.isEmpty
                                  ? 'update_profile'.tr
                                  : controller.mobile,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.85),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// ✨ OPTIONAL EDIT ICON (matches gradient)
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// 🔹 SECTION 1
                _sectionTitle("general".tr),
                buildSection(context, isDark, [
                  buildTile(
                    context,
                    Iconsax.user,
                    "personal_info".tr,
                    () {
                      Get.toNamed("/profile");
                    },
                  ),
                  buildTile(
                    context,
                    Iconsax.document,
                    "documents".tr,
                    () {
                      Get.toNamed(AppRoutes.updateDocs);
                    },
                  ),
                ]),

                /// 🔹 SECTION 2
                _sectionTitle("services".tr),
                buildSection(context, isDark, [
                  Obx(() {
                    final isDarkTheme = themeController.isDark;
                    return buildThemeTile(
                      context,
                      isDark,
                      isDarkTheme,
                      () => themeController.toggleTheme(),
                    );
                  }),
                  if (!AppVerificationController.to.hideSubscriptionUi) ...[
                    buildTile(
                      context,
                      Iconsax.star,
                      "plans".tr,
                      () {
                        Get.toNamed(AppRoutes.subscription);
                      },
                    ),

                    buildTile(
                      context,
                      Iconsax.box,
                      "my_packages".tr,
                      () {
                        Get.toNamed(AppRoutes.myPackage);
                      },
                    ),
                  ],

                  buildTile(
                    context,
                    Iconsax.global,
                    "language".tr,
                    () {
                      Get.toNamed(AppRoutes.settings);
                    },
                  ),
                ]),

                /// 🔹 SECTION 3
                _sectionTitle("support".tr),
                buildSection(context, isDark, [
                  buildTile(
                    context,
                    Iconsax.info_circle,
                    "about".tr,
                    () {
                      Get.toNamed("/about");
                    },
                  ),
                  buildTile(
                    context,
                    Iconsax.headphone,
                    "support".tr,
                    () {
                      Get.toNamed("/support");
                    },
                  ),
                ]),

                /// 🔹 LOGOUT
                const SizedBox(height: 10),
                buildSection(context, isDark, [
                  buildTile(
                    context,
                    Iconsax.logout,
                    "logout".tr,
                    () {
                      showLogoutConfirmationDialog();
                    },
                    isLogout: true,
                  ),
                ]),

                const SizedBox(height: 20),

                Text(
                  appVersion.isEmpty
                      ? 'app_version'.tr
                      : '${'app_version'.tr} $appVersion',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey[600] : Colors.grey[400],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// 🔹 SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, bottom: 8, top: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  /// 🔹 SECTION CONTAINER
  Widget buildSection(
    BuildContext context,
    bool isDark,
    List<Widget> children,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: Colors.white10) : null,
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          int idx = entry.key;
          Widget tile = entry.value;
          return Column(
            children: [
              tile,
              if (idx != children.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark ? Colors.white10 : Colors.grey.shade100,
                  indent: 60,
                  endIndent: 20,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// 🔹 TILE
  Widget buildThemeTile(
    BuildContext context,
    bool isDark,
    bool isDarkTheme,
    VoidCallback onToggle,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kHomeAccentColor.withOpacity(isDark ? 0.18 : 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isDarkTheme
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                color: kHomeAccentColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'theme'.tr,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge!.color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isDarkTheme ? 'dark_mode'.tr : 'light_mode'.tr,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isDarkTheme,
              activeColor: kHomeAccentColor,
              onChanged: (_) => onToggle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isLogout
                    ? Colors.red.withOpacity(0.1)
                    : (isDark
                          ? Colors.white.withOpacity(0.05)
                          : kHomeAccentColor.withOpacity(0.08)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isLogout
                    ? Colors.red
                    : (isDark ? Colors.orangeAccent : kHomeAccentColor),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isLogout
                      ? Colors.red
                      : theme.textTheme.bodyLarge!.color,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
