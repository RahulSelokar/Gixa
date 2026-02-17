import 'package:Gixa/Modules/settings/model/notifications_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';
import 'package:Gixa/network/app_exception.dart';

class NotificationApiService {

  // ─────────────────────────────────────────────
  // 🔔 GET NOTIFICATION SETTINGS
  // ─────────────────────────────────────────────
  Future<NotificationSettingsModel> fetchNotificationSettings() async {
    try {
      final response = await ApiClient.get(
        ApiEndpoints.notificationSettings,
      );

      print("══════════════════════════════════════");
      print("📥 NOTIFICATION SETTINGS RAW TYPE: ${response.runtimeType}");
      print("📥 NOTIFICATION SETTINGS RAW DATA: $response");

      if (response is! Map<String, dynamic>) {
        throw AppException(
          message: "Invalid notification settings response",
          debugMessage: response.toString(),
        );
      }

      final settings =
          NotificationSettingsModel.fromJson(response);

      print("🔔 PARSED NOTIFICATION SETTINGS:");
      print("Push: ${settings.pushNotifications}");
      print("Email: ${settings.emailNotifications}");
      print("SMS: ${settings.smsNotifications}");
      print("Prediction: ${settings.predictionUpdates}");
      print("Chat: ${settings.chatMessages}");
      print("Payment: ${settings.paymentAlerts}");
      print("Announcements: ${settings.announcements}");
      print("══════════════════════════════════════");

      return settings;

    } catch (e) {
      if (e is AppException) rethrow;

      throw AppException(
        message: "Unable to load notification settings",
        debugMessage: e.toString(),
      );
    }
  }

  // ─────────────────────────────────────────────
  // 🔄 UPDATE NOTIFICATION SETTINGS
  // ─────────────────────────────────────────────
  Future<void> updateNotificationSettings({
    required Map<String, dynamic> data,
  }) async {
    try {
      print("══════════════════════════════════════");
      print("📤 UPDATING NOTIFICATION SETTINGS:");
      print("📤 PAYLOAD: $data");

      final response = await ApiClient.put(
        ApiEndpoints.notificationSettings,
        body: data,
      );

      print("📥 UPDATE RESPONSE TYPE: ${response.runtimeType}");
      print("📥 UPDATE RESPONSE DATA: $response");
      print("══════════════════════════════════════");

    } catch (e) {
      if (e is AppException) rethrow;

      throw AppException(
        message: "Unable to update notification settings",
        debugMessage: e.toString(),
      );
    }
  }
}
