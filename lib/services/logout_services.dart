import 'package:Gixa/services/auth_services.dart';
import 'package:Gixa/services/token_services.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:get/get.dart';

class SessionService {
  /// Normal logout (manual / button click)
  static Future<void> logout() async {
    try {
      await AuthServices.logout();
    } catch (_) {
      // ignore logout errors
    } finally {
      _clearAndRedirect();
    }
  }

  /// 🔥 FORCE logout (when backend logs user out from another device)
  static Future<void> forceLogout() async {
    _clearAndRedirect();
  }

  static Future<void> _clearAndRedirect() async {
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    // 1️⃣ Clear tokens
    await TokenService.clearTokens();

    // 2️⃣ Remove all previous routes
    Get.offAllNamed(AppRoutes.loginWithOtp);

    // 3️⃣ Optional but recommended:
    // Reset all GetX controllers (clears in-memory state)
    Future.microtask(() {
      Get.reset();
    });
  }
}
