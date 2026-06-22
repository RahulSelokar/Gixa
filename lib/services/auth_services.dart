import 'package:Gixa/Modules/Auth/model/Auth/send_otp_request.dart';
import 'package:Gixa/Modules/Auth/model/Auth/send_otp_response.dart';
import 'package:Gixa/Modules/Auth/model/Auth/verify_otp_request.dart';
import 'package:Gixa/Modules/Auth/model/Auth/verify_otp_response.dart';
import 'package:Gixa/Modules/Auth/model/api_response.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class AuthServices {
  AuthServices._();

  /// 📲 SEND OTP
  static Future<ApiResponse<SendOtpResponse>> sendOtp(
    SendOtpRequest request,
  ) async {
    final Map<String, dynamic> json = await ApiClient.post(
      ApiEndpoints.sendOtp,
      request.toJson(),
    );

    return ApiResponse<SendOtpResponse>.fromJson(
      json,
      (data) => SendOtpResponse.fromJson(data),
    );
  }

  /// 🔐 VERIFY OTP
  static Future<ApiResponse<VerifyOtpResponse>> verifyOtp(
    VerifyOtpRequest request,
  ) async {
    final json = await ApiClient.postAllow409(
      ApiEndpoints.verifyOtp,
      request.toJson(),
    );

    return ApiResponse<VerifyOtpResponse>.fromJson(
      json,
      (data) => VerifyOtpResponse.fromJson(data),
    );
  }

  static Future<void> logout() async {
    try {
      await ApiClient.post(ApiEndpoints.logout, {});
    } catch (e) {
      // ⚠️ Ignore token_not_valid errors
      // Backend already considers user logged out
    }
  }

  static Future<void> logoutOtherDevice({
    required String mobileNumber,
    required String deviceId,
  }) async {
    await ApiClient.post(ApiEndpoints.logoutOtherDevice, {
      'mobile_number': mobileNumber,
      'device_id': deviceId,
    });
  }

  static Future<ApiResponse<VerifyOtpResponse>> refreshToken(
    String refreshToken,
  ) async {
    final json = await ApiClient.post(ApiEndpoints.refreshToken, {
      'refresh_token': refreshToken,
    });

    return ApiResponse<VerifyOtpResponse>.fromJson(
      json,
      (data) => VerifyOtpResponse.fromJson(data),
    );
  }
}
