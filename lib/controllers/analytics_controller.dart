import 'package:get/get.dart';
import '../services/meta_analytics_service.dart';

class AnalyticsController extends GetxController {
  final MetaAnalyticsService _metaAnalyticsService = MetaAnalyticsService();

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await MetaAnalyticsService.initialize();
    // Log app open as soon as the controller is initialized
    await logAppOpen();
  }

  /// Log App Open Event
  Future<void> logAppOpen() async {
    await _metaAnalyticsService.logAppOpen();
  }

  /// Log User Registration Event
  Future<void> logRegistration({String? method}) async {
    await _metaAnalyticsService.logRegistration(method: method);
  }

  /// Log Purchase Event
  Future<void> logPurchase({
    required double amount,
    required String currency,
    Map<String, dynamic>? parameters,
  }) async {
    await _metaAnalyticsService.logPurchase(
      amount: amount,
      currency: currency,
      parameters: parameters,
    );
  }

  /// Log Subscription Event
  Future<void> logSubscription({
    required double amount,
    required String currency,
    Map<String, dynamic>? parameters,
  }) async {
    await _metaAnalyticsService.logSubscription(
      amount: amount,
      currency: currency,
      parameters: parameters,
    );
  }

  /// Log Custom Event
  Future<void> logCustomEvent(String eventName, Map<String, dynamic> params) async {
    await _metaAnalyticsService.logCustomEvent(eventName, params);
  }
}
