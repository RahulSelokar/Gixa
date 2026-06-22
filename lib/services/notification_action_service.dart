import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class NotificationActionService {
  NotificationActionService._();

  static Future<void> markAsRead(int id) async {
    await ApiClient.post(
      ApiEndpoints.markNotificationRead(id),
      {},
    );
  }

  static Future<void> markAllAsRead() async {
    await ApiClient.post(
      ApiEndpoints.markAllNotificationsRead,
      {},
    );
  }

  static Future<void> deleteNotification(int id) async {
    await ApiClient.delete(
      ApiEndpoints.deleteNotification(id),
      {},
    );
  }

  static Future<void> deleteAllNotifications() async {
    await ApiClient.delete(
      ApiEndpoints.deleteAllNotifications,
      {},
    );
  }

  static Future<void> deleteReadNotifications() async {
    await ApiClient.delete(
      ApiEndpoints.deleteReadNotifications,
      {},
    );
  }
}
