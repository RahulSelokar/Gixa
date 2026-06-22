import 'package:Gixa/Modules/Auth/controllers/otp_controller.dart';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/payment/controller/payment_controller.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/services/auth_services.dart';
import 'package:Gixa/services/token_services.dart';
import 'package:Gixa/Modules/Chatbot/controller/chatbot_controller.dart';
import 'package:Gixa/Modules/choice_filling/controller/predication_sheet_controller.dart';
import 'package:Gixa/Modules/subscription/controller/subsciption_history_controller.dart';
import 'package:Gixa/Modules/addon_contact/controller/addon_contact_controller.dart';
import 'package:Gixa/Modules/counselling_roadmap/controller/counselling_roadmap_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';

class SessionService {
  static Future<void> logout() async {
    try {
      await AuthServices.logout();
    } catch (_) {
      // Ignore logout errors.
    } finally {
      await _clearAndRedirect();
    }
  }

  static Future<void> forceLogout([String? message]) async {
    if (message != null &&
        message.trim().isNotEmpty &&
        message.toLowerCase() != 'unauthorized') {
      AppSnackbar.show(
        'Session Expired',
        message,
        snackPosition: SnackPosition.TOP,
      );
    }
    await _clearAndRedirect();
  }

  static Future<void> _clearAndRedirect() async {
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    ApiClient.clearGetCache();
    await ApiClient.clearCookies();
    await TokenService.clearTokens();

    final box = GetStorage();
    await box.remove('phone_verified');
    await box.remove('registration_completed');
    await box.remove('user_id');

    if (Get.isRegistered<OtpController>()) {
      Get.find<OtpController>().reset();
      Get.delete<OtpController>(force: true);
    }

    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().clearProfile();
    }

    if (Get.isRegistered<SubscriptionController>()) {
      Get.find<SubscriptionController>().clearUserSubscriptionData();
    }

    if (Get.isRegistered<PaymentController>()) {
      Get.find<PaymentController>().clearCredentials();
    }

    if (Get.isRegistered<ChatController>()) {
      Get.find<ChatController>().clearLocalChatState();
    }
    
    if (Get.isRegistered<ChatController>(tag: 'admission-chat')) {
      Get.find<ChatController>(tag: 'admission-chat').clearLocalChatState();
    }

    if (Get.isRegistered<PredictionSheetController>()) {
      Get.delete<PredictionSheetController>(force: true);
    }
    if (Get.isRegistered<SubscriptionHistoryController>()) {
      Get.delete<SubscriptionHistoryController>(force: true);
    }
    if (Get.isRegistered<AddonContactController>()) {
      Get.delete<AddonContactController>(force: true);
    }
    if (Get.isRegistered<CounsellingRoadmapController>()) {
      Get.delete<CounsellingRoadmapController>(force: true);
    }

    Get.offAllNamed(AppRoutes.mainNav);
  }
}
