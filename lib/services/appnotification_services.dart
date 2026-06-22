import 'package:flutter/foundation.dart';

import 'package:Gixa/Modules/notification/model/student_notification_model.dart';
import 'package:Gixa/Modules/settings/model/notifications_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';
import 'package:Gixa/network/app_exception.dart';

class NotificationApiService {
  // ─────────────────────────────────────────────
  // 🔔 GET ALERT / NEWS NOTIFICATIONS
  // ─────────────────────────────────────────────
  Future<StudentNotificationResponse> fetchNotifications({int page = 1}) async {
    try {
      final response = await ApiClient.get('${ApiEndpoints.alerts}?page=$page');

      debugPrint('🔔 ALERT API RAW RESPONSE => $response');

      if (response is! Map<String, dynamic>) {
        throw AppException(
          message: "Invalid notifications response",
          debugMessage: response.toString(),
        );
      }

      final parsedResponse = StudentNotificationResponse.fromJson(response);

      debugPrint(
        '✅ ALERT API PARSED COUNT => ${parsedResponse.results.length}',
      );

      for (final item in parsedResponse.results.take(10)) {
        debugPrint(
          '📢 ALERT ITEM => id=${item.id}, source=${item.source}, title=${item.title}, link=${item.link}',
        );
      }

      return parsedResponse;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw AppException(
        message: "Unable to load notifications",
        debugMessage: e.toString(),
      );
    }
  }

  // ─────────────────────────────────────────────
  // 🔔 GET NOTIFICATION SETTINGS
  // ─────────────────────────────────────────────
  Future<NotificationSettingsModel> fetchNotificationSettings() async {
    try {
      final response = await ApiClient.get(ApiEndpoints.notificationSettings);

      if (response is! Map<String, dynamic>) {
        throw AppException(
          message: "Invalid notification settings response",
          debugMessage: response.toString(),
        );
      }

      return NotificationSettingsModel.fromJson(response);
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw AppException(
        message: "Unable to load notification settings",
        debugMessage: e.toString(),
      );
    }
  }

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
        ApiEndpoints.putNotifcationSettings,
        body: payload,
      );

      if (response is! Map<String, dynamic>) {
        throw AppException(
          message: "Invalid update response",
          debugMessage: response.toString(),
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw AppException(
        message: "Unable to update notification setting",
        debugMessage: e.toString(),
      );
    }
  }
}
