import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  // Keep legacy secure-storage support so existing logged-in users are migrated
  // into SharedPreferences automatically on their next app launch.
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  static String? accessTokenSync;

  static Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    accessTokenSync = accessToken;

    await _writeToken(_accessTokenKey, accessToken);
    await _writeToken(_refreshTokenKey, refreshToken);

    if (kDebugMode) {
      print('ACCESS TOKEN SAVED: ${await getAccessToken()}');
      print('REFRESH TOKEN SAVED: ${await getRefreshToken()}');
    }
  }

  static Future<String?> getAccessToken() async {
    final token = await _readToken(_accessTokenKey);

    if (kDebugMode) {
      print('GET ACCESS TOKEN: $token');
    }

    return token;
  }

  static Future<String?> getRefreshToken() async {
    final token = await _readToken(_refreshTokenKey);

    if (kDebugMode) {
      print('GET REFRESH TOKEN: $token');
    }

    return token;
  }

  static Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<Map<String, String>> authHeader() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) return {};

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  static Future<void> updateAccessToken(String newAccessToken) async {
    await _writeToken(_accessTokenKey, newAccessToken);

    if (kDebugMode) {
      print('ACCESS TOKEN UPDATED: $newAccessToken');
    }
  }

  static Future<void> updateRefreshToken(String newRefreshToken) async {
    await _writeToken(_refreshTokenKey, newRefreshToken);

    if (kDebugMode) {
      print('REFRESH TOKEN UPDATED: $newRefreshToken');
    }
  }

  static Future<void> printTokens() async {
    if (!kDebugMode) return;

    print('STORED ACCESS TOKEN: ${await getAccessToken()}');
    print('STORED REFRESH TOKEN: ${await getRefreshToken()}');
  }

  static Future<void> clearTokens() async {
    accessTokenSync = null;

    final prefs = await _prefs;

    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);

    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);

    if (kDebugMode) {
      print('TOKENS CLEARED');
    }
  }

  static Future<void> _writeToken(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
    await _storage.write(key: key, value: value);
  }

  static Future<String?> _readToken(String key) async {
    final prefs = await _prefs;
    final prefsValue = prefs.getString(key);

    if (prefsValue != null && prefsValue.isNotEmpty) {
      return prefsValue;
    }

    final secureValue = await _storage.read(key: key);
    if (secureValue != null && secureValue.isNotEmpty) {
      await prefs.setString(key, secureValue);
      return secureValue;
    }

    return null;
  }
}
