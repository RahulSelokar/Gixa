import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:Gixa/services/auth_services.dart';
import 'package:Gixa/services/token_services.dart';

class AuthGuard {
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
}
