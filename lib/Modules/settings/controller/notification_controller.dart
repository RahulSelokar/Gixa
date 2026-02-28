import 'package:get/get.dart';
import '../model/notifications_model.dart';
import 'package:Gixa/services/appnotification_services.dart';
import 'package:Gixa/network/app_exception.dart';

class NotificationController extends GetxController {
  final isLoading = false.obs;
  final Rxn<NotificationSettingsModel> settings =
      Rxn<NotificationSettingsModel>();

  final NotificationApiService _service =
      NotificationApiService();

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  // ───────────────────────────────
  // 🔔 FETCH SETTINGS
  // ───────────────────────────────
  Future<void> fetchSettings() async {
    try {
      isLoading.value = true;

      final result =
          await _service.fetchNotificationSettings();

      settings.value = result;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load notification settings",
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ───────────────────────────────
  // 🔄 UPDATE SINGLE TOGGLE
  // ───────────────────────────────
  Future<void> updateField({
    required String type,
    required String channel,
    required bool value,
  }) async {
    if (settings.value == null) return;

    final oldValue = channel == "EMAIL"
        ? settings.value!.email[type] ?? false
        : settings.value!.push[type] ?? false;

    /// 🔥 Optimistic Update
    settings.update((data) {
      if (data == null) return;

      if (channel == "EMAIL") {
        data.email[type] = value;
      } else {
        data.push[type] = value;
      }
    });

    try {
      await _service.updateNotificationSettings(
        type: type,
        channel: channel,
        isEnabled: value,
      );
    } catch (e) {
      /// 🔄 Rollback on failure
      settings.update((data) {
        if (data == null) return;

        if (channel == "EMAIL") {
          data.email[type] = oldValue;
        } else {
          data.push[type] = oldValue;
        }
      });

      Get.snackbar(
        "Update Failed",
        "Unable to update setting",
      );
    }
  }
}
