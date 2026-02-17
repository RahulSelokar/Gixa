import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FcmUtils {
  static Future<String> getFcmToken() async {
    try {
      final messaging = FirebaseMessaging.instance;

      /// Ensure permission (safe even if already granted)
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final token = await messaging.getToken();

      /// 🧪 DEBUG: print raw token
      debugPrint('🔥 FCM TOKEN FROM FIREBASE: $token');

      return token ?? '';
    } catch (e) {
      debugPrint('❌ FCM TOKEN ERROR: $e');
      return '';
    }
  }
}
