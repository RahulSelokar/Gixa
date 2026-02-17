import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Profile/controllers/profile_controller.dart';
import '../controller/notification_controller.dart';

class NotificationSettingsScreen extends StatelessWidget {
  NotificationSettingsScreen({super.key});

  final ProfileController profileController =
      Get.find<ProfileController>();

  final NotificationController controller =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPremium = profileController.isVerified;

    final Color bgColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FD);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Notification Settings"),
      ),
      body: Obx(() {

        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator());
        }

        final data = controller.settings.value;
        if (data == null) {
          return const Center(child: Text("No Data"));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [

            /// 🔒 ANNOUNCEMENTS (PREMIUM)
            buildPremiumCard(
              context,
              isDark,
              isPremium,
              title: "Announcements",
              subtitle: "Notify me of new announcements",
              value: data.announcements,
              onChanged: (val) {
                if (isPremium) {
                  controller.updateField(
                      "announcements", val);
                } else {
                  showPremiumDialog();
                }
              },
            ),

            const SizedBox(height: 16),

            /// 🔒 PREDICTION UPDATES (PREMIUM)
            buildPremiumCard(
              context,
              isDark,
              isPremium,
              title: "Prediction Updates",
              subtitle:
                  "Notify me of important allotment updates, ranks, videos",
              value: data.predictionUpdates,
              onChanged: (val) {
                if (isPremium) {
                  controller.updateField(
                      "prediction_updates", val);
                } else {
                  showPremiumDialog();
                }
              },
            ),

            const SizedBox(height: 16),

            /// 🔒 CHAT MESSAGES (PREMIUM)
            buildPremiumCard(
              context,
              isDark,
              isPremium,
              title: "Chat Messages",
              subtitle:
                  "Get notified when counselor replies",
              value: data.chatMessages,
              onChanged: (val) {
                if (isPremium) {
                  controller.updateField(
                      "chat_messages", val);
                } else {
                  showPremiumDialog();
                }
              },
            ),

            const SizedBox(height: 30),

            /// 🔓 PUSH NOTIFICATIONS (NORMAL)
            buildNormalCard(
              context,
              isDark,
              title: "Push Notifications",
              subtitle:
                  "Enable or disable push notifications",
              value: data.pushNotifications,
              onChanged: (val) {
                controller.updateField(
                    "push_notifications", val);
              },
            ),

            const SizedBox(height: 16),

            /// 🔓 EMAIL NOTIFICATIONS
            buildNormalCard(
              context,
              isDark,
              title: "Email Notifications",
              subtitle:
                  "Receive updates via email",
              value: data.emailNotifications,
              onChanged: (val) {
                controller.updateField(
                    "email_notifications", val);
              },
            ),

            const SizedBox(height: 16),

            /// 🔓 SMS NOTIFICATIONS
            buildNormalCard(
              context,
              isDark,
              title: "SMS Notifications",
              subtitle:
                  "Receive alerts via SMS",
              value: data.smsNotifications,
              onChanged: (val) {
                controller.updateField(
                    "sms_notifications", val);
              },
            ),
          ],
        );
      }),
    );
  }

  // 🔒 PREMIUM CARD
  Widget buildPremiumCard(
    BuildContext context,
    bool isDark,
    bool isPremium, {
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Stack(
      children: [
        Opacity(
          opacity: isPremium ? 1 : 0.5,
          child: _buildCard(
            context,
            isDark,
            title,
            subtitle,
            value,
            onChanged,
            isPremium: true,
          ),
        ),
        if (!isPremium)
          Positioned.fill(
            child: GestureDetector(
              onTap: showPremiumDialog,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(18),
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // 🔓 NORMAL CARD
  Widget buildNormalCard(
    BuildContext context,
    bool isDark, {
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return _buildCard(
        context, isDark, title, subtitle, value, onChanged);
  }

  Widget _buildCard(
    BuildContext context,
    bool isDark,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged, {
    bool isPremium = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                if (isPremium)
                  Row(
                    children: const [
                      Icon(Icons.workspace_premium,
                          size: 16,
                          color: Colors.amber),
                      SizedBox(width: 6),
                      Text("Premium",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w600,
                              color: Colors.amber)),
                    ],
                  ),
                if (isPremium)
                  const SizedBox(height: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600])),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  void showPremiumDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Premium Feature"),
        content: const Text(
            "Upgrade to Premium to unlock this notification."),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                Get.back();
                Get.toNamed("/premium");
              },
              child: const Text("Upgrade")),
        ],
      ),
    );
  }
}
