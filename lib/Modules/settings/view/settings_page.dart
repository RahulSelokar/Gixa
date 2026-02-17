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
            fontWeight: FontWeight.w600,
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
            child: Column(
              children: [
                /// 🔹 PROFILE HEADER
                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(20),
                  //   gradient: LinearGradient(
                  //     colors: isDark
                  //         ? [
                  //             const Color(0xFF1E293B),
                  //             const Color(0xFF0F172A)
                  //           ]
                  //         : [
                  //             const Color(0xFF2563EB),
                  //             const Color(0xFF3B82F6)
                  //           ],
                  //   ),
                  // ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
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
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),

                      const SizedBox(height: 15),

                      Text(
                        controller.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        controller.mobile,
                        style: TextStyle(color: Colors.white.withOpacity(0.85)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// 🔹 SECTION 1
                _sectionTitle("General"),
                buildSection(context, isDark, [
                  buildTile(context, Icons.person_outline, "Personal Info", () {
                    Get.toNamed("/profile");
                  }),
                  buildTile(context, Icons.edit_document, "Documents", () {
                    Get.toNamed(AppRoutes.updateDocs);
                  }),
                  buildTile(context, Icons.swap_horiz, "Change AIR", () {
                    Get.toNamed("/Change-rank");
                  }),
                  buildTile(
                    context,
                    Icons.notifications_outlined,
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
                    Icons.card_membership_outlined,
                    "Plans",
                    () {
                      Get.toNamed(AppRoutes.subscription);
                    },
                  ),
                  buildTile(
                    context,
                    Icons.card_membership_outlined,
                    "My Packages",
                    () {
                      Get.toNamed(AppRoutes.myPackage);
                    },
                  ),

                  buildTile(context, Icons.card_giftcard, "Langauge", () {
                    Get.toNamed(AppRoutes.settings);
                  }),
                  buildTile(
                    context,
                    Icons.volunteer_activism_outlined,
                    "Refer & Earn",
                    () {
                      Get.toNamed("/refer-earn");
                    },
                  ),
                ]),

                /// 🔹 SECTION 3
                _sectionTitle("Support"),
                buildSection(context, isDark, [
                  buildTile(context, Icons.info_outline, "About", () {
                    Get.toNamed("/about");
                  }),
                  buildTile(
                    context,
                    Icons.support_agent_outlined,
                    "Support",
                    () {
                      Get.toNamed("/support");
                    },
                  ),
                  buildTile(
                    context,
                    Icons.feedback_outlined,
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
                    Icons.storage_outlined,
                    "Data & Storage",
                    () {
                      Get.toNamed("/data-storage");
                    },
                  ),
                ]),

                /// 🔹 LOGOUT
                const SizedBox(height: 10),
                buildSection(context, isDark, [
                  buildTile(context, Icons.logout, "Logout", () {
                    // Get.offAllNamed("/login");
                    showLogoutConfirmationDialog();
                  }, isLogout: true),
                ]),

                const SizedBox(height: 20),

                Text(
                  "App Version 1.0.0",
                  style: TextStyle(
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 30),
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
      padding: const EdgeInsets.only(left: 25, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      // decoration: BoxDecoration(
      //   color: isDark ? const Color(0xFF1E293B) : Colors.white,
      //   borderRadius: BorderRadius.circular(18),
      //   boxShadow: isDark
      //       ? []
      //       : [
      //           BoxShadow(
      //             color: Colors.black.withOpacity(0.04),
      //             blurRadius: 10,
      //             offset: const Offset(0, 5),
      //           )
      //         ],
      // ),
      child: Column(children: children),
    );
  }

  /// 🔹 TILE
  Widget buildTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: isLogout
            ? Colors.red
            : (isDark ? Colors.blueAccent : Colors.blueAccent),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isLogout ? Colors.red : theme.textTheme.bodyLarge!.color,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDark ? Colors.grey[400] : Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
