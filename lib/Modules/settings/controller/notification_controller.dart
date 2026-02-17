import 'package:Gixa/Modules/settings/model/notifications_model.dart';
import 'package:Gixa/services/appnotification_services.dart';
import 'package:get/get.dart';
import 'package:Gixa/network/app_exception.dart';

class NotificationController extends GetxController {

  /// ───────── STATE ─────────
  final RxBool isLoading = false.obs;
  final Rxn<NotificationSettingsModel> settings =
      Rxn<NotificationSettingsModel>();

  final NotificationApiService _service =
      NotificationApiService();

  /// ───────── INIT ─────────
  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  // ─────────────────────────────────────────────
  // 🔔 FETCH NOTIFICATION SETTINGS (GET)
  // ─────────────────────────────────────────────
  Future<void> fetchSettings() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final result =
          await _service.fetchNotificationSettings();

      settings.value = result;

    } on AppException catch (e) {
      Get.snackbar(
        "Notification Error",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    isLoading.value = false;
  }

  // ─────────────────────────────────────────────
  // 🔄 UPDATE SINGLE FIELD (PUT)
  // ─────────────────────────────────────────────
  Future<void> updateField(String key, bool value) async {
    if (settings.value == null) return;

    final oldValue = _getFieldValue(key);

    /// 🔹 Optimistic Update (UI instantly updates)
    _setFieldValue(key, value);

    try {
      await _service.updateNotificationSettings(
        data: {key: value},   // ✅ matches your ApiClient(body:)
      );

      print("✅ $key updated successfully");

    } on AppException catch (e) {

      /// 🔹 Rollback if failed
      _setFieldValue(key, oldValue);

      Get.snackbar(
        "Update Failed",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {

      /// 🔹 Rollback if failed
      _setFieldValue(key, oldValue);

      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ─────────────────────────────────────────────
  // 🧠 INTERNAL FIELD GETTER
  // ─────────────────────────────────────────────
  bool _getFieldValue(String key) {
    final data = settings.value!;

    switch (key) {
      case "push_notifications":
        return data.pushNotifications;
      case "email_notifications":
        return data.emailNotifications;
      case "sms_notifications":
        return data.smsNotifications;
      case "prediction_updates":
        return data.predictionUpdates;
      case "chat_messages":
        return data.chatMessages;
      case "payment_alerts":
        return data.paymentAlerts;
      case "announcements":
        return data.announcements;
      default:
        return false;
    }
  }

  // ─────────────────────────────────────────────
  // 🧠 INTERNAL FIELD SETTER
  // ─────────────────────────────────────────────
  void _setFieldValue(String key, bool value) {
    settings.update((data) {
      if (data == null) return;

      switch (key) {
        case "push_notifications":
          data.pushNotifications = value;
          break;
        case "email_notifications":
          data.emailNotifications = value;
          break;
        case "sms_notifications":
          data.smsNotifications = value;
          break;
        case "prediction_updates":
          data.predictionUpdates = value;
          break;
        case "chat_messages":
          data.chatMessages = value;
          break;
        case "payment_alerts":
          data.paymentAlerts = value;
          break;
        case "announcements":
          data.announcements = value;
          break;
      }
    });
  }
}
