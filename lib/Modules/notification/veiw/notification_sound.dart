import 'package:Gixa/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> testNotificationSound() async {
  await NotificationService.plugin.show(
    999, // test id
    '🔔 Test Notification',
    'If you hear the sound, it works 🎉',
    NotificationDetails(
      android: AndroidNotificationDetails(
        'plan_expiry_reminder',
        'Plan Expiry Reminder',
        importance: Importance.high,
        priority: Priority.high,
        sound: const RawResourceAndroidNotificationSound(
          'plan_expiry_soft_chime',
        ),
      ),
    ),
  );
}
