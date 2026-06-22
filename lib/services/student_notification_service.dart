import 'package:Gixa/Modules/notification/model/student_notification_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';
import 'package:Gixa/network/app_exception.dart';

class StudentNotificationService {
  StudentNotificationService._();

  static Future<StudentNotificationResponse> fetchNotifications({
    bool forceRefresh = false,
  }) async {
    final response = await ApiClient.get(
      ApiEndpoints.studentNotifications,
      requestPolicy: RequestPolicy(
        ttl: const Duration(seconds: 15),
        forceRefresh: forceRefresh,
      ),
    );

    if (response is! Map<String, dynamic>) {
      throw AppException(
        message: 'Invalid notifications response',
        debugMessage: response.toString(),
      );
    }

    return StudentNotificationResponse.fromJson(response);
  }
}
