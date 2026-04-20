import 'dart:async';

import 'package:Gixa/Modules/Auth/model/Auth/send_otp_request.dart';
import 'package:Gixa/Modules/Auth/model/Auth/verify_otp_request.dart';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/routes/app_start_controller.dart';
import 'package:Gixa/services/auth_services.dart';
import 'package:Gixa/services/token_services.dart';
import 'package:Gixa/utils/device_utils.dart';
import 'package:Gixa/utils/fcm_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class OtpController extends GetxController {
  /// Call this on logout to clear state
  void reset() {
    mobileNumber.value = '';
    otp.value = '';
    secondsRemaining.value = 30;
    canResendOtp.value = false;
    isLoading.value = false;
    otpFromBackend.value = '';
    otpRequestStartTime.value = null;
    otpResponseTime.value = null;
    _timer?.cancel();
    print('🔴 OtpController state reset');
  }

  final mobileNumber = ''.obs;
  final otp = ''.obs;
  final secondsRemaining = 30.obs;
  final canResendOtp = false.obs;
  Timer? _timer;
  final isLoading = false.obs;
  final otpFromBackend = ''.obs;
  final otpRequestStartTime = Rxn<DateTime>();
  final otpResponseTime = Rxn<DateTime>();

  Future<void> sendOtp(String number) async {
    if (!RegExp(r'^[0-9]{10}$').hasMatch(number)) {
      Get.snackbar('Invalid', 'Please enter a valid 10-digit mobile number');
      return;
    }

    try {
      isLoading.value = true;
      mobileNumber.value = number;
      otp.value = '';

      otpRequestStartTime.value = DateTime.now();

      final response = await AuthServices.sendOtp(
        SendOtpRequest(mobileNumber: number),
      );

      otpResponseTime.value = DateTime.now();

      if (response.data?.otp != null) {
        otpFromBackend.value = response.data!.otp;
        _showOtpSnackBar(otpFromBackend.value);
      }

      _startTimer();

      Get.toNamed(AppRoutes.verifyOtp, arguments: {'mobileNumber': number});
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ───────────────────────── TIMER ─────────────────────────

  void _startTimer() {
    secondsRemaining.value = 30;
    canResendOtp.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value <= 0) {
        canResendOtp.value = true;
        timer.cancel();
      } else {
        secondsRemaining.value--;
      }
    });
  }

  // ───────────────────────── RESEND OTP ─────────────────────────

  Future<void> resendOtp() async {
    if (mobileNumber.value.isEmpty) return;

    try {
      isLoading.value = true;
      otp.value = '';

      final response = await AuthServices.sendOtp(
        SendOtpRequest(mobileNumber: mobileNumber.value),
      );

      if (response.data?.otp != null) {
        otpFromBackend.value = response.data!.otp;
        _showOtpSnackBar(otpFromBackend.value);
      }

      _startTimer();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ───────────────────────── VERIFY OTP ─────────────────────────

  Future<void> verifyOtp() async {
    if (isLoading.value) {
      print("⛔ verifyOtp prevented (already loading)");
      return;
    }
    isLoading.value = true;
    final cleanOtp = otp.value.trim();
    final cleanMobile = mobileNumber.value.trim();
    final deviceId = await DeviceUtils.getDeviceId();
    final fcmToken = await FcmUtils.getFcmToken();

    if (!RegExp(r'^[0-9]{6}$').hasMatch(cleanOtp)) {
      Get.snackbar('Invalid OTP', 'Enter a valid 6-digit OTP');
      isLoading.value = false;
      return;
    }

    if (otpFromBackend.isNotEmpty && cleanOtp != otpFromBackend.value) {
      Get.snackbar(
        'Incorrect OTP',
        'Please enter the correct OTP',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
      return;
    }

    try {
      // isLoading.value = true;

      final response = await AuthServices.verifyOtp(
        VerifyOtpRequest(
          mobileNumber: cleanMobile,
          otp: cleanOtp,
          deviceId: deviceId,
          fcmToken: fcmToken,
        ),
      );

      if (response.data == null) {
        Get.snackbar('OTP Failed', response.message);
        return;
      }

      final data = response.data!;

      /// 🚫 SINGLE DEVICE LOGIN CHECK
      if (data.errorCode == 'ALREADY_LOGGED_IN_OTHER_DEVICE') {
        _showAlreadyLoggedInDialog(
          message: data.message,
          mobile: cleanMobile,
          otp: cleanOtp,
        );
        return;
      }

      /// 🔐 App Start Flow
      final appStart = Get.find<AppStartController>();
      await appStart.phoneVerified();

      /// Existing user
      if (data.isRegistered == true) {
        if (data.accessToken == null || data.refreshToken == null) {
          Get.snackbar('Login Error', 'Invalid login session');
          return;
        }

        await TokenService.saveTokens(
          accessToken: data.accessToken!,
          refreshToken: data.refreshToken!,
        );
        final box = GetStorage();
        Map<String, dynamic> decodedToken = JwtDecoder.decode(
          data.accessToken!,
        );

        final userId = decodedToken['user_id'];

        print("Saving USER ID: $userId");

        box.write("user_id", int.parse(userId.toString()));

        await appStart.registrationCompleted();
        _showOtpSuccessDialog(
          message: data.message ?? "OTP Verified Successfully",
          navigateTo: AppRoutes.mainNav,
        );
      }
      /// New user
      else {
        _showOtpSuccessDialog(
          message: "OTP Verified Successfully",
          navigateTo: AppRoutes.register,
          arguments: {'mobileNumber': cleanMobile},
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _showOtpSuccessDialog({
    required String message,
    required String navigateTo,
    Map<String, dynamic>? arguments,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: _ModernOtpSuccessDialog(
          message: message,
          navigateTo: navigateTo,
          arguments: arguments,
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showAlreadyLoggedInDialog({
    required String message,
    required String mobile,
    required String otp,
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Already Logged In"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              // Call logout-other-device API
              try {
                isLoading.value = true;
                await AuthServices.logoutOtherDevice(
                  deviceId: await DeviceUtils.getDeviceId(),
                );
                Get.snackbar(
                  "Success",
                  "Logged out from other device successfully",
                );
                // Retry OTP verification for current device
                await verifyOtp();
              } catch (e) {
                Get.snackbar('Error', e.toString());
              } finally {
                isLoading.value = false;
              }
            },
            child: const Text("Logout Other Device"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // ───────────────────────── SNACKBARS ─────────────────────────

  /// 🧪 DEV ONLY – REMOVE BEFORE PROD
  void _showOtpSnackBar(String otp) {
    Get.snackbar(
      'OTP (DEV MODE)',
      'Your OTP is $otp',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF4F46E5),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      icon: const Icon(Icons.lock_open, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void _showWelcomeSnackBar(String message) {
    Get.snackbar(
      "Welcome to Gixa 👋",
      message,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      borderRadius: 16,
      backgroundColor: const Color(0xFF4F46E5),
      colorText: Colors.white,
      icon: const Icon(
        Icons.celebration_rounded,
        color: Colors.white,
        size: 28,
      ),
      duration: const Duration(seconds: 3),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeIn,
    );
  }

  // Future<void> _forceLogoutOtherDeviceAndRetry({
  //   required String mobile,
  //   required String otp,
  // }) async {
  //   try {
  //     isLoading.value = true;

  //     // 🔑 logout other device (backend decides which one)
  //     await AuthServices.logoutOtherDevice(
  //       deviceId: await DeviceUtils.getDeviceId(),
  //     );

  //     // 🔁 retry verify otp after force logout
  //     final retryResponse = await AuthServices.verifyOtp(
  //       VerifyOtpRequest(
  //         mobileNumber: mobile,
  //         otp: otp,
  //         deviceId: await DeviceUtils.getDeviceId(),
  //         fcmToken: await FcmUtils.getFcmToken(),
  //       ),
  //     );

  //     final data = retryResponse.data;
  //     if (data == null) {
  //       Get.snackbar('Login Failed', retryResponse.message);
  //       return;
  //     }

  //     _showWelcomeSnackBar(data.message);

  //     final appStart = Get.find<AppStartController>();
  //     await appStart.phoneVerified();

  //     if (data.isRegistered == true) {
  //       await TokenService.saveTokens(
  //         accessToken: data.accessToken!,
  //         refreshToken: data.refreshToken!,
  //       );

  //       await appStart.registrationCompleted();
  //       Get.offAllNamed(AppRoutes.mainNav);
  //     } else {
  //       Get.offAllNamed(
  //         AppRoutes.register,
  //         arguments: {'mobileNumber': mobile},
  //       );
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // ───────────────────────── CLEANUP ─────────────────────────

  Future<void> _forceLogoutOtherDeviceAndRetry({required String mobile}) async {
    try {
      isLoading.value = true;

      print("🔐 Logging out other device...");

      await AuthServices.logoutOtherDevice(
        deviceId: await DeviceUtils.getDeviceId(),
      );

      print("✅ Other device logged out successfully");

      await sendOtp(mobile);

      Get.snackbar(
        "Logged out from other device",
        "A new OTP has been sent. Please verify again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print("❌ Force logout error: $e");

      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

class _ModernOtpSuccessDialog extends StatelessWidget {
  final String message;
  final String navigateTo;
  final Map<String, dynamic>? arguments;

  const _ModernOtpSuccessDialog({
    required this.message,
    required this.navigateTo,
    this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Success Circle
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 60,
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            "OTP Verified Successfully",
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // Message
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 28),

          // Continue Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  final profileController = Get.find<ProfileController>();
                  await profileController.fetchProfile();
                } catch (_) {}
                Get.offAllNamed(navigateTo, arguments: arguments);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
