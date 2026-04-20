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
        title: Text('notification_settings'.tr),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.settings.value;

        if (data == null) {
          return Center(child: Text('no_notification_settings_found'.tr));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchSettings,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              /// EMAIL SECTION
              _sectionHeader(
                icon: Icons.email_outlined,
                title: 'email_notifications'.tr,
              ),

              const SizedBox(height: 16),

              ...data.email.entries.map((entry) {
                final type = entry.key;
                final value = entry.value;

                final isLocked = _isPremiumType(type) && !isPremium;

                return buildCard(
                  context,
                  isDark,
                  icon: _getIcon(type),
                  title: _formatTitle(type),
                  subtitle: 'receive_via_email'.trParams({
                    'type': _formatTitle(type),
                  }),
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

              /// PUSH SECTION
              _sectionHeader(
                icon: Icons.notifications_active_outlined,
                title: 'push_notifications'.tr,
              ),

              const SizedBox(height: 16),

              ...data.push.entries.map((entry) {
                final type = entry.key;
                final value = entry.value;

                final isLocked = _isPremiumType(type) && !isPremium;

                return buildCard(
                  context,
                  isDark,
                  icon: _getIcon(type),
                  title: _formatTitle(type),
                  subtitle: 'receive_via_push'.trParams({
                    'type': _formatTitle(type),
                  }),
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
          ),
        );
      }),
    );
  }

  /// SECTION HEADER
  Widget _sectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// NOTIFICATION CARD
  Widget buildCard(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required bool isLocked,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blueAccent, size: 20),
          ),

          const SizedBox(width: 14),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLocked)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Premium",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber,
                      ),
                    ),
                  ),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          /// SWITCH
          Switch(
            value: value,
            onChanged: isLocked ? null : onChanged,
            activeColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  /// PREMIUM TYPES
  bool _isPremiumType(String type) {
    return type == "ANNOUNCEMENT" ||
        type == "PREDICTION_UPDATE" ||
        type == "CHAT_MESSAGE";
  }

  /// FORMAT TITLE
  String _formatTitle(String type) {
    return type
        .replaceAll("_", " ")
        .toLowerCase()
        .split(" ")
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join(" ");
  }

  /// ICON MAPPING
  IconData _getIcon(String type) {
    switch (type) {
      case "CHAT_MESSAGE":
        return Icons.chat_bubble_outline;
      case "ADMISSION_UPDATE":
        return Icons.school_outlined;
      case "PAYMENT_ALERT":
        return Icons.payments_outlined;
      case "ANNOUNCEMENT":
        return Icons.campaign_outlined;
      case "PREDICTION_UPDATE":
        return Icons.analytics_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  /// PREMIUM DIALOG
  void showPremiumDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Premium Feature"),
        content: const Text(
          "Upgrade to Premium to unlock this notification setting.",
        ),
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
