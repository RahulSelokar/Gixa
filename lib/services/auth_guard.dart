import 'dart:ui';

import 'package:Gixa/Modules/Auth/Veiw/login_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:Gixa/services/auth_services.dart';
import 'package:Gixa/services/token_services.dart';
import 'package:Gixa/routes/app_routes.dart';

class AuthGuard {
  static final _box = GetStorage();

  /// Used on Splash for auto login
  static Future<bool> hasValidSession() async {
    final accessToken = await TokenService.getAccessToken();
    final refreshToken = await TokenService.getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      return false;
    }

    if (JwtDecoder.isExpired(accessToken)) {
      return await _refreshAccessToken(refreshToken);
    }

    return true;
  }

  /// Refresh token
  static Future<bool> _refreshAccessToken(String refreshToken) async {
    try {
      final res = await AuthServices.refreshToken(refreshToken);
      final newAccessToken = res.data?.accessToken;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        return false;
      }

      await TokenService.updateAccessToken(newAccessToken);
      return true;
    } catch (_) {
      await TokenService.clearTokens();
      return false;
    }
  }

  /// 🔐 Use this when user opens locked feature
  static Future<void> checkAccess({
  required VoidCallback onAllowed,
}) async {
  final hasSession = await hasValidSession();

  if (!hasSession) {
    Get.bottomSheet(const LoginBottomSheet(), isScrollControlled: true);
    return;
  }

  final isRegistered = _box.read('registration_completed') == true;

  if (!isRegistered) {
    Get.toNamed(AppRoutes.register);
    return;
  }

  onAllowed();
}
}
