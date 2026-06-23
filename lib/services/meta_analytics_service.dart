import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';

class MetaAnalyticsService {
  static final FacebookAppEvents _facebookAppEvents = FacebookAppEvents();

  /// Initialize Meta SDK and configure basic settings
  static Future<void> initialize() async {
    try {
      // Setting auto log app events to true
      await _facebookAppEvents.setAutoLogAppEventsEnabled(true);
      
      // Also setting advertiser tracking enabled (mostly for iOS)
      await _facebookAppEvents.setAdvertiserTracking(enabled: true);

      debugPrint('Meta (Facebook) App Events initialized successfully.');
    } catch (e) {
      debugPrint('Error initializing Meta App Events: $e');
    }
  }

  /// Log an app open event
  Future<void> logAppOpen() async {
    try {
      await _facebookAppEvents.logEvent(name: 'app_opened');
      debugPrint('Meta Event Logged: App Open');
    } catch (e) {
      debugPrint('Failed to log App Open event: $e');
    }
  }

  /// Log a CompleteRegistration event
  Future<void> logRegistration({String? method}) async {
    try {
      await _facebookAppEvents.logCompletedRegistration(
        registrationMethod: method ?? 'email',
      );
      debugPrint('Meta Event Logged: CompleteRegistration');
    } catch (e) {
      debugPrint('Failed to log Registration event: $e');
    }
  }

  /// Log a Purchase event
  Future<void> logPurchase({
    required double amount,
    required String currency,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _facebookAppEvents.logPurchase(
        amount: amount,
        currency: currency,
        parameters: parameters,
      );
      debugPrint('Meta Event Logged: Purchase ($amount $currency)');
    } catch (e) {
      debugPrint('Failed to log Purchase event: $e');
    }
  }

  /// Log a Subscription event
  Future<void> logSubscription({
    required double amount,
    required String currency,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      // Subscription started is typically a custom event or tracked as purchase
      await _facebookAppEvents.logEvent(
        name: 'Subscribe',
        parameters: {
          'currency': currency,
          'value': amount,
          if (parameters != null) ...parameters,
        },
        valueToSum: amount,
      );
      debugPrint('Meta Event Logged: Subscription Started');
    } catch (e) {
      debugPrint('Failed to log Subscription event: $e');
    }
  }

  /// Log a custom event
  Future<void> logCustomEvent(String eventName, Map<String, dynamic> params) async {
    try {
      await _facebookAppEvents.logEvent(
        name: eventName,
        parameters: params,
      );
      debugPrint('Meta Event Logged: $eventName');
    } catch (e) {
      debugPrint('Failed to log custom event ($eventName): $e');
    }
  }
}
