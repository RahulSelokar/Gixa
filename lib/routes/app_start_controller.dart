// import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/services/auth_guard.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Gixa/routes/app_routes.dart';

// import 'package:Gixa/services/token_services.dart';

class AppStartController extends GetxController {
  final _box = GetStorage();

  static const _onboardingKey = 'onboarding_done';
  static const _phoneVerifiedKey = 'phone_verified';
  static const _registrationKey = 'registration_completed';

  bool get isOnboardingDone => _box.read(_onboardingKey) == true;
  bool get isPhoneVerified => _box.read(_phoneVerifiedKey) == true;
  bool get isRegistrationCompleted => _box.read(_registrationKey) == true;

  // Future<void> decideNextRoute() async {
  //   final onboardingDone = _box.read(_onboardingKey) ?? false;
  //   final registrationCompleted = _box.read(_registrationKey) ?? false;

  //   // 🔥 ALWAYS reset phone verification on fresh app start
  //   _box.remove(_phoneVerifiedKey);

  //   if (!onboardingDone) {
  //     Get.offAllNamed(AppRoutes.onboarding);
  //     return;
  //   }

  //   if (!registrationCompleted) {
  //     Get.offAllNamed(AppRoutes.loginWithOtp);
  //     return;
  //   }

  //   // 🔐 FIX: validate + refresh token
  //   final hasSession = await AuthGuard.hasValidSession();

  //   if (!hasSession) {
  //     Get.offAllNamed(AppRoutes.loginWithOtp);
  //     return;
  //   }

  //   Get.offAllNamed(AppRoutes.mainNav);
  // }
  Future<void> decideNextRoute() async {
    final onboardingDone = _box.read(_onboardingKey) ?? false;

    if (!onboardingDone) {
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    // Try auto login using token
    final hasSession = await AuthGuard.hasValidSession();

    if (hasSession) {
      await _box.write(_phoneVerifiedKey, true);

      /// 🔥 LOAD ACTIVE PLAN HERE
      final rawUserId = _box.read("user_id");
      final int? userId = rawUserId is int
          ? rawUserId
          : int.tryParse(rawUserId?.toString() ?? '');
      print("USER ID FROM STORAGE: $rawUserId -> parsed: $userId");

      if (userId != null) {
        await Get.find<SubscriptionController>().loadActivePlanFromHistory(
          userId,
        );
      } else {
        print("USER ID IS NULL");
      }
    }

    // Always open Home (Guest or Logged In)
    Get.offAllNamed(AppRoutes.mainNav);
  }

  Future<void> completeOnboarding() async {
    await _box.write(_onboardingKey, true);
  }

  Future<void> phoneVerified() async {
    await _box.write(_phoneVerifiedKey, true);
  }

  /// ✅ ONLY set flag — NO navigation here
  Future<void> registrationCompleted() async {
    await _box.write(_registrationKey, true);
  }

  /// 🚪 Logout = clear auth state
  Future<void> logout() async {
    await _box.remove(_phoneVerifiedKey);
    await _box.remove(_registrationKey);

    // ⚠️ Token clearing handled elsewhere
    Get.offAllNamed(AppRoutes.loginWithOtp);
  }

  /// 🗑️ For testing
  Future<void> clearAllData() async {
    await _box.erase();
  }
}
