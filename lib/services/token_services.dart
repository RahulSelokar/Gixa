import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  /// 🔐 Secure storage instance
  /// (explicit options improve reliability on Android)
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  //  SAVE TOKENS (WITH VERIFICATION)
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);

    //  VERIFY IMMEDIATELY (IMPORTANT)
    final savedAccess = await _storage.read(key: _accessTokenKey);
    final savedRefresh = await _storage.read(key: _refreshTokenKey);

    if (kDebugMode) {
      print("🔐 ACCESS TOKEN SAVED: $savedAccess");
      print("🔐 REFRESH TOKEN SAVED: $savedRefresh");
    }
  }

  //  GET ACCESS TOKEN
  static Future<String?> getAccessToken() async {
    final token = await _storage.read(key: _accessTokenKey);

    if (kDebugMode) {
      print("📥 GET ACCESS TOKEN: $token");
    }

    return token;
  }

  // ─────────────────────────────────────────────
  //  GET REFRESH TOKEN
  // ─────────────────────────────────────────────
  static Future<String?> getRefreshToken() async {
    final token = await _storage.read(key: _refreshTokenKey);

    if (kDebugMode) {
      print("📥 GET REFRESH TOKEN: $token");
    }

    return token;
  }

  // ─────────────────────────────────────────────
  // 🧾 CHECK IF USER IS LOGGED IN
  // ─────────────────────────────────────────────
  static Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ─────────────────────────────────────────────
  // 📦 AUTH HEADER (FOR API CALLS)
  // ─────────────────────────────────────────────
  static Future<Map<String, String>> authHeader() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) return {};

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

  }
 
  // 🔄 UPDATE ONLY ACCESS TOKEN
  static Future<void> updateAccessToken(String newAccessToken) async {
    await _storage.write(key: _accessTokenKey, value: newAccessToken);

    if (kDebugMode) {
      print("♻️ ACCESS TOKEN UPDATED: $newAccessToken");
    }
  }

  //  PRINT TOKENS (DEBUG ONLY)
  static Future<void> printTokens() async {
    if (!kDebugMode) return;

    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();

    print("📦 STORED ACCESS TOKEN: $accessToken");
    print("📦 STORED REFRESH TOKEN: $refreshToken");
  }

  // CLEAR TOKENS (LOGOUT ONLY)
  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);

    if (kDebugMode) {
      print("🗑️ TOKENS CLEARED");
    }
  }
}
