import 'package:Gixa/Modules/Auth/controllers/otp_controller.dart';
import 'package:Gixa/Modules/Auth/Veiw/login_bottom_sheet.dart';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/services/auth_services.dart';
import 'package:Gixa/services/jwt_token_helper.dart';
import 'package:Gixa/services/token_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum SessionValidationState {
  noTokens,
  validAccessToken,
  refreshedAccessToken,
  expiredRefreshToken,
  malformedAccessToken,
  malformedRefreshToken,
  refreshFailed,
  tokenReadFailed,
  timedOut,
}

class SessionValidationResult {
  const SessionValidationResult({
    required this.state,
    required this.hasValidSession,
    this.error,
  });

  const SessionValidationResult.noTokens()
    : this(state: SessionValidationState.noTokens, hasValidSession: false);

  const SessionValidationResult.timedOut()
    : this(state: SessionValidationState.timedOut, hasValidSession: false);

  final SessionValidationState state;
  final bool hasValidSession;
  final Object? error;

  String get summary {
    if (error == null) {
      return state.name;
    }

    return '${state.name}: $error';
  }
}

class AuthGuard {
  static final _box = GetStorage();

  static Future<bool> hasValidSession() async {
    final result = await validateSession();
    return result.hasValidSession;
  }

  static Future<SessionValidationResult> validateSession() async {
    try {
      final accessToken = await TokenService.getAccessToken();
      final refreshToken = await TokenService.getRefreshToken();

      if ((accessToken == null || accessToken.trim().isEmpty) &&
          (refreshToken == null || refreshToken.trim().isEmpty)) {
        return const SessionValidationResult.noTokens();
      }

      if (accessToken == null ||
          accessToken.trim().isEmpty ||
          refreshToken == null ||
          refreshToken.trim().isEmpty) {
        await TokenService.clearTokens();
        return const SessionValidationResult(
          state: SessionValidationState.noTokens,
          hasValidSession: false,
        );
      }

      final accessInspection = JwtTokenHelper.inspect(
        accessToken,
        label: 'access_token',
      );

      if (accessInspection.isMalformed) {
        await TokenService.clearTokens();
        return SessionValidationResult(
          state: SessionValidationState.malformedAccessToken,
          hasValidSession: false,
          error: accessInspection.error,
        );
      }

      if (accessInspection.isValid) {
        return const SessionValidationResult(
          state: SessionValidationState.validAccessToken,
          hasValidSession: true,
        );
      }

      final refreshInspection = JwtTokenHelper.inspect(
        refreshToken,
        label: 'refresh_token',
      );

      if (refreshInspection.isMalformed) {
        await TokenService.clearTokens();
        return SessionValidationResult(
          state: SessionValidationState.malformedRefreshToken,
          hasValidSession: false,
          error: refreshInspection.error,
        );
      }

      if (refreshInspection.isExpired || !refreshInspection.hasToken) {
        await TokenService.clearTokens();
        return const SessionValidationResult(
          state: SessionValidationState.expiredRefreshToken,
          hasValidSession: false,
        );
      }

      return _refreshAccessToken(refreshToken);
    } catch (error, stackTrace) {
      Get.log('[AuthGuard] Session validation failed: $error\n$stackTrace');
      await TokenService.clearTokens();
      return SessionValidationResult(
        state: SessionValidationState.tokenReadFailed,
        hasValidSession: false,
        error: error,
      );
    }
  }

  static Future<SessionValidationResult> _refreshAccessToken(
    String refreshToken,
  ) async {
    try {
      final res = await AuthServices.refreshToken(refreshToken);
      final newAccessToken = res.data?.accessToken;
      final newRefreshToken = res.data?.refreshToken;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        await TokenService.clearTokens();
        return const SessionValidationResult(
          state: SessionValidationState.refreshFailed,
          hasValidSession: false,
        );
      }

      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await TokenService.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
      } else {
        await TokenService.updateAccessToken(newAccessToken);
      }

      return const SessionValidationResult(
        state: SessionValidationState.refreshedAccessToken,
        hasValidSession: true,
      );
    } catch (error) {
      await TokenService.clearTokens();
      return SessionValidationResult(
        state: SessionValidationState.refreshFailed,
        hasValidSession: false,
        error: error,
      );
    }
  }

  static Future<void> checkAccess({required VoidCallback onAllowed}) async {
    final otpController = Get.isRegistered<OtpController>()
        ? Get.find<OtpController>()
        : Get.put(OtpController());

    // 🔥 FIRST CHECK (instant local login state)
    if (otpController.isLoggedIn.value == true) {
      // Always force home tab after login
      final navController = Get.isRegistered<MainNavController>()
          ? Get.find<MainNavController>()
          : null;
      if (navController != null) {
        navController.currentIndex.value = 0;
        navController.isBottomBarVisible.value = true;
      }
      onAllowed();
      return;
    }

    // 🔥 SECOND CHECK (token/session)
    final result = await validateSession();
    final hasSession = result.hasValidSession;

    if (!hasSession) {
      otpController.reset();

      if (Get.isBottomSheetOpen == true) {
        return;
      }

      showAuthBottomSheet(
        LoginBottomSheet(
          onAuthenticated: () {
            // Always force home tab after login
            final navController = Get.isRegistered<MainNavController>()
                ? Get.find<MainNavController>()
                : null;
            if (navController != null) {
              navController.currentIndex.value = 0;
              navController.isBottomBarVisible.value = true;
            }
            onAllowed();
          },
        ),
      );
      return;
    }

    final isRegistered = _box.read('registration_completed') == true;

    if (!isRegistered) {
      Get.toNamed(AppRoutes.register);
      return;
    }

    // 🔥 MARK LOGIN TRUE (important sync)
    otpController.isLoggedIn.value = true;

    onAllowed();
  }
}
