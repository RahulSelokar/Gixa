import 'dart:async';

import 'package:Gixa/Modules/Auth/model/Auth/send_otp_request.dart';
import 'package:Gixa/Modules/Auth/model/Auth/verify_otp_request.dart';
import 'package:Gixa/Modules/Auth/model/Auth/verify_otp_response.dart';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
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
import 'package:Gixa/common/widgets/app_snackbar.dart';
import 'package:Gixa/Modules/Auth/Veiw/login_bottom_sheet.dart';

class OtpController extends GetxController {
  static const int _otpExpirySeconds = 60;
  var isLoggedIn = false.obs;

  /// Call this on logout to clear state.
  void reset() {
    isLoggedIn.value = false;
    mobileNumber.value = '';
    otp.value = '';
    secondsRemaining.value = _otpExpirySeconds;
    canResendOtp.value = false;
    isLoading.value = false;
    isSendingOtp.value = false;
    isVerifyingOtp.value = false;
    isResendingOtp.value = false;
    otpFromBackend.value = '';
    otpInputResetTrigger.value++;
    otpRequestStartTime.value = null;
    otpResponseTime.value = null;
    _timer?.cancel();
    print('OtpController state reset');
  }

  final mobileNumber = ''.obs;
  final otp = ''.obs;
  final secondsRemaining = _otpExpirySeconds.obs;
  final canResendOtp = false.obs;
  Timer? _timer;
  final isLoading = false.obs;
  final otpFromBackend = ''.obs;
  final otpInputResetTrigger = 0.obs;
  final otpRequestStartTime = Rxn<DateTime>();
  final otpResponseTime = Rxn<DateTime>();

  final isSendingOtp = false.obs;
  final isVerifyingOtp = false.obs;
  final isResendingOtp = false.obs;

  Future<bool> sendOtp(String number) async {
    // Prevent multiple simultaneous requests
    if (isSendingOtp.value) {
      AppSnackbar.show(
        'Please Wait',
        'OTP request already in progress',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    // Validate mobile number
    if (!RegExp(r'^[0-9]{10}$').hasMatch(number.trim())) {
      AppSnackbar.show(
        'Invalid',
        'Please enter a valid 10-digit mobile number',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    // Prevent resend before timer ends
    final isFirstRequest = otpRequestStartTime.value == null;

    if (!isFirstRequest && !canResendOtp.value && !isResendingOtp.value) {
      AppSnackbar.show(
        'Please Wait',
        'You can request OTP again after timer ends',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    try {
      isSendingOtp.value = true;

      final cleanNumber = number.trim();

      mobileNumber.value = cleanNumber;

      otp.value = '';
      otpInputResetTrigger.value++;

      otpRequestStartTime.value = DateTime.now();

      final response = await AuthServices.sendOtp(
        SendOtpRequest(mobileNumber: cleanNumber),
      );

      otpResponseTime.value = DateTime.now();

      if (response.data?.otp != null) {
        otpFromBackend.value = response.data!.otp;
      }
      _startTimer();

      AppSnackbar.show(
        'Success',
        'OTP sent successfully',
        snackPosition: SnackPosition.TOP,
      );

      return true;
    } catch (e) {
      AppSnackbar.show('Error', e.toString(), snackPosition: SnackPosition.TOP);

      return false;
    } finally {
      isSendingOtp.value = false;
    }
  }

  void _startTimer() {
    secondsRemaining.value = _otpExpirySeconds;
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

  Future<void> resendOtp() async {
    // Prevent multiple simultaneous requestsc
    if (isResendingOtp.value) {
      AppSnackbar.show(
        'Please Wait',
        'OTP request already in progress',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Check mobile number exists
    if (mobileNumber.value.isEmpty) {
      AppSnackbar.show(
        'Error',
        'Mobile number not found',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Prevent resend before timer ends
    if (!canResendOtp.value) {
      AppSnackbar.show('Please Wait', 'You can resend OTP after timer ends');
      return;
    }

    try {
      isResendingOtp.value = true;

      // Clear old entered OTP
      _clearEnteredOtp(clearBackendOtp: true);

      // Save resend request time
      otpRequestStartTime.value = DateTime.now();

      // API Call
      final response = await AuthServices.sendOtp(
        SendOtpRequest(mobileNumber: mobileNumber.value.trim()),
      );

      // Save response time
      otpResponseTime.value = DateTime.now();

      // OPTIONAL:
      // Remove this in production for security reasons
      if (response.data?.otp != null) {
        otpFromBackend.value = response.data!.otp;
      }

      // Restart timer
      _startTimer();

      AppSnackbar.show(
        'Success',
        'OTP resent successfully',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      AppSnackbar.show('Error', e.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isResendingOtp.value = false;
    }
  }

  void _clearEnteredOtp({bool clearBackendOtp = false}) {
    otp.value = '';
    otpInputResetTrigger.value++;
    if (clearBackendOtp) {
      otpFromBackend.value = '';
    }
  }

  void _enableOtpResendNow() {
    _timer?.cancel();
    secondsRemaining.value = 0;
    canResendOtp.value = true;
  }

  Future<void> verifyOtp() async {
    await _verifyOtpInternal();
  }

  Future<void> verifyOtpForBottomSheet({
    VoidCallback? onRegisteredSuccess,
  }) async {
    await _verifyOtpInternal(
      useBottomSheetFlow: true,
      onRegisteredSuccess: onRegisteredSuccess,
    );
  }

  Future<void> _verifyOtpInternal({
    bool useBottomSheetFlow = false,
    VoidCallback? onRegisteredSuccess,
  }) async {
    if (isVerifyingOtp.value) {
      print('verifyOtp prevented (already loading)');
      return;
    }

    final cleanOtp = otp.value.trim();
    final cleanMobile = mobileNumber.value.trim();

    if (!RegExp(r'^[0-9]{6}$').hasMatch(cleanOtp)) {
      AppSnackbar.show(
        'Invalid OTP',
        'Enter a valid 6-digit OTP',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    await _performOtpVerification(
      cleanMobile: cleanMobile,
      cleanOtp: cleanOtp,
      useBottomSheetFlow: useBottomSheetFlow,
      onRegisteredSuccess: onRegisteredSuccess,
    );
  }

  Future<void> _performOtpVerification({
    required String cleanMobile,
    required String cleanOtp,
    bool allowForceLogoutPrompt = true,
    bool useBottomSheetFlow = false,
    VoidCallback? onRegisteredSuccess,
  }) async {
    isVerifyingOtp.value = true;
    try {
      final response = await AuthServices.verifyOtp(
        VerifyOtpRequest(
          mobileNumber: cleanMobile,
          otp: cleanOtp,
          deviceId: await DeviceUtils.getDeviceId(),
          fcmToken: await FcmUtils.getFcmToken(),
        ),
      );

      print('--- VERIFY OTP RESPONSE ---');
      print('Success: ${response.success}');
      print('Message: ${response.message}');
      print('Data is null: ${response.data == null}');
      if (response.data != null) {
        print('ErrorCode: ${response.data!.errorCode}');
        print(
          'IsAlreadyLoggedIn: ${response.data!.isAlreadyLoggedInOtherDevice}',
        );
      }
      print('---------------------------');

      if (response.data == null) {
        AppSnackbar.show(
          'OTP Failed',
          response.message,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final data = response.data!;

      if (data.isAlreadyLoggedInOtherDevice) {
        if (allowForceLogoutPrompt) {
          _showAlreadyLoggedInDialog(
            message: data.message,
            mobile: cleanMobile,
          );
        } else {
          AppSnackbar.show(
            'Login Failed',
            data.message.isNotEmpty
                ? data.message
                : 'Unable to verify OTP after force logout.',
            snackPosition: SnackPosition.TOP,
          );
        }
        return;
      }

      await _handleVerifiedOtpSuccess(
        data: data,
        mobileNumber: cleanMobile,
        useBottomSheetFlow: useBottomSheetFlow,
        onRegisteredSuccess: onRegisteredSuccess,
      );
    } catch (e) {
      AppSnackbar.show('Error', e.toString(), snackPosition: SnackPosition.TOP);
      rethrow;
    } finally {
      isVerifyingOtp.value = false;
    }
  }

  Future<void> _handleVerifiedOtpSuccess({
    required VerifyOtpResponse data,
    required String mobileNumber,
    bool useBottomSheetFlow = false,
    VoidCallback? onRegisteredSuccess,
  }) async {
    final appStart = Get.find<AppStartController>();
    await appStart.phoneVerified();

    if (data.isRegistered) {
      isLoggedIn.value = true;
      if (data.accessToken == null || data.refreshToken == null) {
        AppSnackbar.show(
          'Login Error',
          'Invalid login session',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      await TokenService.saveTokens(
        accessToken: data.accessToken!,
        refreshToken: data.refreshToken!,
      );

      final box = GetStorage();
      try {
        final decodedToken = JwtDecoder.decode(data.accessToken!);
        final userId = decodedToken['user_id'];
        if (userId != null) {
          print('Saving USER ID: $userId');
          box.write('user_id', int.parse(userId.toString()));
        }
      } catch (e) {
        print('Bypass token or missing user_id. Error: $e');
      }
      // Always set registration_completed after successful OTP for registered user
      box.write('registration_completed', true);

      final navController = Get.isRegistered<MainNavController>()
          ? Get.find<MainNavController>()
          : Get.put(MainNavController(), permanent: true);
      navController.requestSubscriptionPopup();

      await appStart.registrationCompleted();

      if (useBottomSheetFlow) {
        await _warmUpSessionData();
        await _closeAuthBottomSheetIfOpen();
        AppSnackbar.show(
          'Success',
          data.message.isNotEmpty ? data.message : 'OTP Verified Successfully',
          snackPosition: SnackPosition.TOP,
        );
        Future.delayed(const Duration(milliseconds: 300), () {
          if (Get.isRegistered<OtpController>()) {
            Get.delete<OtpController>();
          }
        });
        Get.offAllNamed(AppRoutes.mainNav);
        return;
      }

      _showOtpSuccessDialog(
        message: data.message.isNotEmpty
            ? data.message
            : 'OTP Verified Successfully',
        navigateTo: AppRoutes.mainNav,
      );
      return;
    }

    if (useBottomSheetFlow) {
      await _closeAuthBottomSheetIfOpen();
      AppSnackbar.show(
        'Success',
        'OTP Verified Successfully',
        snackPosition: SnackPosition.TOP,
      );
      Get.toNamed(
        AppRoutes.register,
        arguments: {'mobileNumber': mobileNumber},
      );
      return;
    }

    _showOtpSuccessDialog(
      message: 'OTP Verified Successfully',
      navigateTo: AppRoutes.register,
      arguments: {'mobileNumber': mobileNumber},
    );
  }

  Future<void> _warmUpSessionData() async {
    try {
      final profileController = Get.find<ProfileController>();
      await profileController.fetchProfile();
    } catch (_) {}

    try {
      final subscriptionController = Get.find<SubscriptionController>();
      await subscriptionController.ensureActivePlanReady(forceRefresh: true);
    } catch (_) {}
  }

  Future<void> _closeAuthBottomSheetIfOpen() async {
    closeAuthBottomSheet();
    await Future<void>.delayed(const Duration(milliseconds: 250));
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
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Already Logged In'),
        content: Text(
          message.isNotEmpty
              ? message
              : 'This account is already active on another device.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _forceLogoutOtherDeviceAndPrepareResend(mobile: mobile);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Logout Other Device'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _forceLogoutOtherDeviceAndPrepareResend({
    required String mobile,
  }) async {
    try {
      isVerifyingOtp.value = true;

      print('Logging out other device...');

      await AuthServices.logoutOtherDevice(
        mobileNumber: mobile,
        deviceId: await DeviceUtils.getDeviceId(),
      );

      print('Other device logged out successfully');

      /// RESET OLD OTP STATE
      _timer?.cancel();

      otp.value = '';

      otpFromBackend.value = '';

      otpInputResetTrigger.value++;

      secondsRemaining.value = _otpExpirySeconds;

      canResendOtp.value = false;

      mobileNumber.value = mobile.trim();

      otpRequestStartTime.value = null;

      /// SEND FRESH OTP IMMEDIATELY
      final success = await sendOtp(mobileNumber.value);

      if (!success) {
        canResendOtp.value = true;

        AppSnackbar.show(
          'Error',
          'Failed to send OTP. Please try again.',
          snackPosition: SnackPosition.TOP,
        );

        return;
      }

      AppSnackbar.show(
        'Success',
        'Previous device logged out. New OTP sent successfully.',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print('Force logout error: $e');

      AppSnackbar.show('Error', e.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isVerifyingOtp.value = false;
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
          Text(
            'OTP Verified Successfully',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  final profileController = Get.find<ProfileController>();
                  await profileController.fetchProfile();
                } catch (_) {}

                try {
                  final subscriptionController =
                      Get.find<SubscriptionController>();
                  await subscriptionController.ensureActivePlanReady(
                    forceRefresh: true,
                  );
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
                'Continue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
