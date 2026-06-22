import 'package:flutter/foundation.dart';

enum StartupPhase {
  splashDelayDone,
  splashVideoInitialized,
  splashVideoInitializationFailed,
  routeDecisionStarted,
  onboardingIncomplete,
  sessionCheckStarted,
  sessionCheckFinished,
  sessionCheckFailed,
  sessionCheckTimedOut,
  authenticatedWarmupStarted,
  authenticatedWarmupCompleted,
  authenticatedWarmupTimedOut,
  authenticatedWarmupFailed,
  navigatedToOnboarding,
  navigatedToLogin,
  navigatedToMainNav,
  routeDecisionFailed,
}

class StartupDiagnostics {
  StartupDiagnostics()
    : _flowId = DateTime.now().millisecondsSinceEpoch.toString(),
      _stopwatch = Stopwatch()..start();

  final String _flowId;
  final Stopwatch _stopwatch;

  void mark(
    StartupPhase phase, {
    String? details,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final message = StringBuffer(
      '[Startup][$_flowId][${_stopwatch.elapsedMilliseconds}ms] ${phase.name}',
    );

    if (details != null && details.isNotEmpty) {
      message.write(' - $details');
    }

    if (error != null) {
      message.write(' - error: $error');
    }

    debugPrint(message.toString());

    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
