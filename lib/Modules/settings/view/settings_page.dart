import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/Profile/views/logout_dailog.dart';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class AccountManageScreen extends StatelessWidget {
  AccountManageScreen({super.key});

  final ProfileController controller = Get.find<ProfileController>();
  final MainNavController navController = Get.find<MainNavController>();

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
          "Account",
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
            padding: const EdgeInsets.only(bottom: 100),
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
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black26
                            : const Color(0xFF1565C0).withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                          : [const Color(0xFF2563EB), const Color(0xFF1E3A8A)],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          backgroundImage: controller.profileImage.isNotEmpty
                              ? NetworkImage(controller.profileImage)
                              : null,
                          child: controller.profileImage.isEmpty
                              ? Text(
                                  controller.fullName.isNotEmpty
                                      ? controller.fullName[0].toUpperCase()
                                      : "U",
                                  style: const TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.fullName.isEmpty
                                  ? "Student"
                                  : controller.fullName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.mobile.isEmpty
                                  ? "Update your profile"
                                  : controller.mobile,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Icon(
                      //   Icons.edit_square,
                      //   color: Colors.white.withOpacity(0.8),
                      //   size: 24,
                      // ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// 🔹 SECTION 1
                _sectionTitle("General"),
                buildSection(context, isDark, [
                  buildTile(
                    context,
                    "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Identification%20card/3D/identification_card_3d.png",
                    "Personal Info",
                    () {
                      Get.toNamed("/profile");
                    },
                  ),
                  buildTile(
                    context,
                    "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/File%20folder/3D/file_folder_3d.png",
                    "Documents",
                    () {
                      Get.toNamed(AppRoutes.updateDocs);
                    },
                  ),
                  buildTile(
                    context,
                    "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Bar%20chart/3D/bar_chart_3d.png",
                    "Change AIR",
                    () {
                      Get.toNamed("/Change-rank");
                    },
                  ),
                  buildTile(
                    context,
                    "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Bell/3D/bell_3d.png",
                    "Notification Settings",
                    () {
                      Get.toNamed("/notification-settings");
                    },
                  ),
                ]),

                /// 🔹 SECTION 2
                _sectionTitle("Services"),
                buildSection(context, isDark, [
                  buildTile(
                    context,
                    "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Star/3D/star_3d.png",
                    "Plans",
                    () {
                      Get.toNamed(AppRoutes.subscription);
                    },
                  ),
                  buildTile(
                    context,
                    "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Package/3D/package_3d.png",
                    "My Packages",
                    () {
                      Get.toNamed(AppRoutes.myPackage);
                    },
                  ),

                  buildTile(
                    context,
                    "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Globe%20with%20meridians/3D/globe_with_meridians_3d.png",
                    "Language",
                    () {
                      Get.toNamed(AppRoutes.settings);
                    },
                  ),
                  buildTile(
                    context,
                    "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Money%20with%20wings/3D/money_with_wings_3d.png",
                    "Refer & Earn",
                    () {
                      Get.toNamed("/refer-earn");
                    },
                  ),
                ]),

                /// 🔹 SECTION 3
                _sectionTitle("Support"),
                buildSection(context, isDark, [
                  buildTile(
                    context,
                    "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Information/3D/information_3d.png",
                    "About",
                    () {
                      Get.toNamed("/about");
                    },
                  ),
                  buildTile(
                    context,
                    "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Headphone/3D/headphone_3d.png",
                    "Support",
                    () {
                      Get.toNamed("/support");
                    },
                  ),
                  buildTile(
                    context,
                    "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Speech%20balloon/3D/speech_balloon_3d.png",
                    "Share Feedback",
                    () {
                      Get.toNamed("/feedback");
                    },
                  ),
                ]),
                _sectionTitle("Data & Storage"),
                buildSection(context, isDark, [
                  buildTile(
                    context,
                    "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Floppy%20disk/3D/floppy_disk_3d.png",
                    "Data & Storage",
                    () {
                      Get.toNamed("/data-storage");
                    },
                  ),
                ]),

                /// 🔹 LOGOUT
                const SizedBox(height: 10),
                buildSection(context, isDark, [
                  buildTile(
                    context,
                    "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Door/3D/door_3d.png",
                    "Logout",
                    () {
                      showLogoutConfirmationDialog();
                    },
                    isLogout: true,
                  ),
                ]),

                const SizedBox(height: 20),

                Text(
                  "App Version 1.0.0",
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
  Widget buildTile(
    BuildContext context,
    String imageUrl,
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
                          : const Color(0xFF1565C0).withOpacity(0.08)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                height: 24,
                width: 24,
                errorBuilder: (context, error, stackTrace) => Icon(
                  isLogout ? Icons.logout : Icons.settings,
                  color: isLogout
                      ? Colors.red
                      : (isDark ? Colors.blueAccent : const Color(0xFF1565C0)),
                  size: 20,
                ),
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
