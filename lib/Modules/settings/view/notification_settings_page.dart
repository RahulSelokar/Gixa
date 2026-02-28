import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Profile/controllers/profile_controller.dart';
import '../controller/notification_controller.dart';

class NotificationSettingsScreen extends StatelessWidget {
  NotificationSettingsScreen({super.key});

  final ProfileController profileController = Get.find<ProfileController>();

  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPremium = profileController.isVerified;

    final Color bgColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF8F9FD);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Notification Settings"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.settings.value;
        if (data == null) {
          return const Center(child: Text("No Data"));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// ───────── EMAIL SECTION ─────────
            const Text(
              "Email Notifications",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ...data.email.entries.map((entry) {
              final type = entry.key;
              final value = entry.value;

              final isLocked = _isPremiumType(type) && !isPremium;

              return buildCard(
                context,
                isDark,
                title: _formatTitle(type),
                subtitle: "Receive $type via email",
                value: value,
                isLocked: isLocked,
                onChanged: (val) {
                  if (isLocked) {
                    showPremiumDialog();
                    return;
                  }

                  controller.updateField(
                    type: type,
                    channel: "EMAIL",
                    value: val,
                  );
                },
              );
            }),

            const SizedBox(height: 30),

            /// ───────── PUSH SECTION ─────────
            const Text(
              "Push Notifications",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ...data.push.entries.map((entry) {
              final type = entry.key;
              final value = entry.value;

              final isLocked = _isPremiumType(type) && !isPremium;

              return buildCard(
                context,
                isDark,
                title: _formatTitle(type),
                subtitle: "Receive $type via push notification",
                value: value,
                isLocked: isLocked,
                onChanged: (val) {
                  if (isLocked) {
                    showPremiumDialog();
                    return;
                  }

                  controller.updateField(
                    type: type,
                    channel: "PUSH",
                    value: val,
                  );
                },
              );
            }),
          ],
        );
      }),
    );
  }

  // ─────────────────────────────────────────────
  // 🔔 CARD BUILDER
  // ─────────────────────────────────────────────
  Widget buildCard(
    BuildContext context,
    bool isDark, {
    required String title,
    required String subtitle,
    required bool value,
    required bool isLocked,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLocked)
                  Row(
                    children: const [
                      Icon(
                        Icons.workspace_premium,
                        size: 16,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Premium",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                if (isLocked) const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: isLocked ? null : onChanged,
            activeColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // 🧠 HELPER FUNCTIONS
  // ─────────────────────────────────────────────

  /// Lock these types for premium users
  bool _isPremiumType(String type) {
    return type == "ANNOUNCEMENT" ||
        type == "PREDICTION_UPDATE" ||
        type == "CHAT_MESSAGE";
  }

  /// Convert BACKEND_TYPE → Nice Title
  String _formatTitle(String type) {
    return type
        .replaceAll("_", " ")
        .toLowerCase()
        .split(" ")
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join(" ");
  }

  void showPremiumDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Premium Feature"),
        content: const Text("Upgrade to Premium to unlock this notification."),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed("/premium");
            },
            child: const Text("Upgrade"),
          ),
        ],
      ),
    );
  }
}
