import 'dart:async';

import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/routes/startup_diagnostics.dart';
import 'package:Gixa/services/auth_guard.dart';
import 'package:Gixa/services/notification_launch_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppStartController extends GetxController {
  final _box = GetStorage();

  static const _onboardingKey = 'onboarding_done';
  static const _phoneVerifiedKey = 'phone_verified';
  static const _registrationKey = 'registration_completed';
  static const Duration _sessionCheckTimeout = Duration(seconds: 8);
  static const Duration _warmUpTimeout = Duration(seconds: 8);

  bool _hasNavigatedFromSplash = false;
  bool _isRouteDecisionInProgress = false;

  bool get isOnboardingDone => _box.read(_onboardingKey) == true;
  bool get isPhoneVerified => _box.read(_phoneVerifiedKey) == true;
  bool get isRegistrationCompleted => _box.read(_registrationKey) == true;

  Future<void> decideNextRoute({StartupDiagnostics? diagnostics}) async {
    if (_isRouteDecisionInProgress) {
      return;
    }

    _isRouteDecisionInProgress = true;
    _hasNavigatedFromSplash = false;

    final startupDiagnostics = diagnostics ?? StartupDiagnostics();
    startupDiagnostics.mark(StartupPhase.routeDecisionStarted);

    final onboardingDone = _box.read(_onboardingKey) ?? false;
    const fallbackRoute = AppRoutes.mainNav;

    try {
      if (!onboardingDone) {
        startupDiagnostics.mark(StartupPhase.onboardingIncomplete);
        await _box.write(_onboardingKey, true);
      }

      final hasValidSession = await _validateAuthenticatedStartup(
        startupDiagnostics,
      );

      if (!hasValidSession) {
        _navigateOnce(AppRoutes.mainNav, diagnostics: startupDiagnostics);
        return;
      }

      _navigateOnce(AppRoutes.mainNav, diagnostics: startupDiagnostics);
      unawaited(_warmUpAuthenticatedUser(startupDiagnostics));
    } catch (error, stackTrace) {
      startupDiagnostics.mark(
        StartupPhase.routeDecisionFailed,
        error: error,
        stackTrace: stackTrace,
      );
      _navigateOnce(fallbackRoute, diagnostics: startupDiagnostics);
    } finally {
      _isRouteDecisionInProgress = false;
    }
  }

  Future<bool> _validateAuthenticatedStartup(
    StartupDiagnostics diagnostics,
  ) async {
    diagnostics.mark(StartupPhase.sessionCheckStarted);

    try {
      final result = await AuthGuard.validateSession().timeout(
        _sessionCheckTimeout,
        onTimeout: () => const SessionValidationResult.timedOut(),
      );

      if (!result.hasValidSession) {
        final phase = result.state == SessionValidationState.timedOut
            ? StartupPhase.sessionCheckTimedOut
            : StartupPhase.sessionCheckFailed;
        diagnostics.mark(phase, details: result.summary);
        return false;
      }

      diagnostics.mark(
        StartupPhase.sessionCheckFinished,
        details: result.summary,
      );

      await _box.write(_phoneVerifiedKey, true);
      return true;
    } catch (error, stackTrace) {
      diagnostics.mark(
        StartupPhase.sessionCheckFailed,
        details: 'unexpected_session_check_error',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<void> _warmUpAuthenticatedUser(StartupDiagnostics diagnostics) async {
    diagnostics.mark(StartupPhase.authenticatedWarmupStarted);

    try {
      final profileController = Get.find<ProfileController>();
      final subscriptionController = Get.find<SubscriptionController>();

      await Future.wait<void>([
        profileController.ensureLoaded(),
        subscriptionController.ensureActivePlanReady(forceRefresh: true),
      ]).timeout(_warmUpTimeout);

      diagnostics.mark(StartupPhase.authenticatedWarmupCompleted);
    } on TimeoutException {
      diagnostics.mark(StartupPhase.authenticatedWarmupTimedOut);
    } catch (error, stackTrace) {
      diagnostics.mark(
        StartupPhase.authenticatedWarmupFailed,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> completeOnboarding() async {
    await _box.write(_onboardingKey, true);
  }

  Future<void> phoneVerified() async {
    await _box.write(_phoneVerifiedKey, true);
  }

  Future<void> registrationCompleted() async {
    await _box.write(_registrationKey, true);
  }

  Future<void> logout() async {
    await _box.remove(_phoneVerifiedKey);
    await _box.remove(_registrationKey);
    Get.offAllNamed(AppRoutes.mainNav);
  }

  Future<void> clearAllData() async {
    await _box.erase();
  }

  void _navigateOnce(String route, {required StartupDiagnostics diagnostics}) {
    if (_hasNavigatedFromSplash) {
      return;
    }

    _hasNavigatedFromSplash = true;

    final phase = route == AppRoutes.onboarding
        ? StartupPhase.navigatedToOnboarding
        : route == AppRoutes.loginWithOtp
            ? StartupPhase.navigatedToLogin
            : StartupPhase.navigatedToMainNav;

    diagnostics.mark(phase, details: 'route=$route');
    Get.offAllNamed(route);

    // ── Deep-link from cold-start notification tap ──────────────────────
    // If the user tapped a notification while the app was fully closed,
    // NotificationLaunchService.setPendingRoute() was called in main() before
    // the navigator was ready. Now that we have navigated to mainNav we can
    // push the real destination on top of it.
    final pendingRoute = NotificationLaunchService.consumePendingRoute();
    if (pendingRoute != null) {
      // Small delay so mainNav can finish building its widget tree first.
      Future.delayed(const Duration(milliseconds: 300), () {
        try {
          Get.toNamed(pendingRoute);
        } catch (_) {}
      });
    }
  }
}
