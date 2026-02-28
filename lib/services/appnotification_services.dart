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

      if (response is! Map<String, dynamic>) {
        throw AppException(
          message: "Invalid notification settings response",
          debugMessage: response.toString(),
        );
      }

      return NotificationSettingsModel.fromJson(response);

    } catch (e) {
      if (e is AppException) rethrow;

      throw AppException(
        message: "Unable to load notification settings",
        debugMessage: e.toString(),
      );
    }
  }

  // ─────────────────────────────────────────────
  // 🔄 UPDATE SINGLE NOTIFICATION SETTING
  // ─────────────────────────────────────────────
  Future<void> updateNotificationSettings({
    required String type,
    required String channel,
    required bool isEnabled,
  }) async {
    try {
      final payload = {
        "type": type,
        "channel": channel,
        "is_enabled": isEnabled,
      };

      final response = await ApiClient.put(
        ApiEndpoints.notificationSettings,
        body: payload,
      );

      if (response is! Map<String, dynamic>) {
        throw AppException(
          message: "Invalid update response",
          debugMessage: response.toString(),
        );
      }

    } catch (e) {
      if (e is AppException) rethrow;

      throw AppException(
        message: "Unable to update notification setting",
        debugMessage: e.toString(),
      );
    }
  }
}
