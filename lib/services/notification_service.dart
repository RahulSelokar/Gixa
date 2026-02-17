import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// 🔹 INIT (call in main.dart)
  static Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidInit,
    );

    await _plugin.initialize(initSettings);

    // Create channel once (sound comes from backend mapping)
    await _createPlanExpiryChannel();
  }

  static FlutterLocalNotificationsPlugin get plugin => _plugin;

  /// 🔔 ANDROID 13+ PERMISSION
  static Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// 🔔 CREATE CHANNEL (MUST MATCH BACKEND SOUND)
  static Future<void> _createPlanExpiryChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'plan_expiry_reminder',
      'Plan Expiry Reminder',
      description: 'Reminder before subscription expiry',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound(
        'plan_expiry_sound', // ✅ BACKEND SOUND
      ),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// 🔊 INSTANT TEST NOTIFICATION
  static Future<void> showTestNotification() async {
    try {
      await _plugin.show(
        999,
        '🔔 Test Notification',
        'If you hear sound, it works 🎉',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'plan_expiry_reminder',
            'Plan Expiry Reminder',
            importance: Importance.high,
            priority: Priority.high,
            // ❌ DO NOT SET SOUND HERE
          ),
        ),
      );
    } catch (e, s) {
      debugPrint('NOTIFICATION ERROR: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  /// ⏰ SCHEDULE PLAN EXPIRY NOTIFICATION
  static Future<void> schedulePlanExpiryNotification({
    required String endDate,
    int daysBefore = 3,
  }) async {
    final expiryDate = DateTime.parse(endDate);
    final reminderDate =
        expiryDate.subtract(Duration(days: daysBefore));

    final scheduledTime =
        tz.TZDateTime.from(reminderDate, tz.local);

    if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await _plugin.zonedSchedule(
      1001,
      'Plan Expiry Alert ⏳',
      'Your subscription expires soon. Renew now!',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'plan_expiry_reminder',
          'Plan Expiry Reminder',
          importance: Importance.high,
          priority: Priority.high,
          // ❌ DO NOT SET SOUND HERE
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// ❌ CANCEL
  static Future<void> cancelPlanExpiryNotification() async {
    await _plugin.cancel(1001);
  }
}
