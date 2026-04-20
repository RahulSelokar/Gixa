import 'dart:async';
import 'package:Gixa/Modules/subscription/controller/subsciption_history_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../model/subscription_plan.dart';
import '../model/subscription_purchase_model.dart';
import '../model/create_order_model.dart';
import '../../../services/subscription_plan_services.dart';
import 'package:Gixa/Modules/payment/controller/payment_controller.dart';

class SubscriptionController extends GetxController {
  /// Call this on logout or when token is cleared
  void clearUserSubscriptionData() {
    final userId = _readUserIdFromStorage();
    if (userId != null) {
      _box.remove(_userFeaturesKey(userId));
    }
    _box.remove(_userIdKey);
    activePlan.value = null;
    plans.clear();
    previewMap.clear();
    couponErrorMap.clear();
    print('🔴 Cleared user subscription data from storage and memory');
  }

  final plans = <SubscriptionPlan>[].obs;
  late final SubscriptionHistoryController _historyController;
  final GetStorage _box = GetStorage();

  // Helper: Get user-specific key
  String _userFeaturesKey(int userId) => 'user_features_[${userId}]';
  String get _userIdKey => 'user_id';
  bool _isRestoringActivePlan = false;

  /// 🧾 Active user plan
  final Rxn<SubscriptionPlan> activePlan = Rxn<SubscriptionPlan>();
  final isLoading = false.obs;

  final previewMap = <int, SubscriptionPurchaseData>{}.obs;

  /// ❌ Coupon error per plan
  final couponErrorMap = <int, String>{}.obs;

  /// 💳 Razorpay
  late Razorpay _razorpay;
  CreateOrderData? _currentOrder;

  /// 🔑 Payment controller (Razorpay key)
  late final PaymentController _paymentController;
  // late final PaymentController _paymentController;

  bool get isSubscribed => activePlan.value != null;

  String get activePlanName => activePlan.value?.planName ?? "Free Plan";
  // ─────────────────────────────────────────────
  // LIFE CYCLE
  // ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();

    _paymentController = Get.isRegistered<PaymentController>()
        ? Get.find<PaymentController>()
        : Get.put(PaymentController());

    _historyController = Get.isRegistered<SubscriptionHistoryController>()
        ? Get.find<SubscriptionHistoryController>()
        : Get.put(SubscriptionHistoryController());

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    fetchPlans();
    unawaited(_restoreActivePlanFromStorage());
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;
      plans.clear();
      final fetchedPlans = await SubscriptionApi.getPlans();
      print(
        '[SubscriptionController] Plans fetched: count = \\${fetchedPlans.length}',
      );
      if (fetchedPlans.isEmpty) {
        print('[SubscriptionController] No plans returned from API!');
      }
      plans.assignAll(fetchedPlans);
    } catch (e) {
      print('[SubscriptionController] Error fetching plans: $e');
      Get.snackbar('Error', 'Failed to load subscription plans');
    } finally {
      isLoading.value = false;
    }
  }

  bool setActivePlanByCode(String planCode) {
    final normalizedInput = _normalizeText(planCode);

    for (final plan in plans) {
      final code = _normalizeText(plan.planCode);
      final name = _normalizeText(plan.planName);

      if (code == normalizedInput || name == normalizedInput) {
        activePlan.value = plan;
        return true;
      }
    }

    print("Plan not found for code/name: $planCode");
    return false;
  }

  Future<void> applyCoupon({
    required int planId,
    required String couponCode,
  }) async {
    try {
      couponErrorMap[planId] = '';
      previewMap.remove(planId);

      final res = await SubscriptionApi.purchaseSubscription(
        planId: planId,
        couponCode: couponCode,
      );

      if (res.status) {
        previewMap[planId] = res.data;
      } else {
        couponErrorMap[planId] = res.message;
      }
    } catch (e) {
      couponErrorMap[planId] = 'Invalid coupon';
    }
  }

  void clearCoupon(int planId) {
    previewMap.remove(planId);
    couponErrorMap.remove(planId);
  }

  Future<void> createOrderAndPay(int planId) async {
    try {
      if (_historyController.isPlanActive(planId)) {
        Get.snackbar(
          'Subscription Active',
          'You already have an active subscription for this plan.',
        );
        return;
      }

      final plan = plans.firstWhere((p) => p.id == planId);
      final preview = previewMap[planId];

      final int baseAmount = _parseAmount(plan.amount);
      final int finalAmount = preview != null
          ? _parseAmount(preview.finalPayableAmount)
          : baseAmount;

      final orderRes = await SubscriptionApi.createOrder(
        planId: planId,
        baseAmount: baseAmount,
        finalAmount: finalAmount,
        couponCode: preview?.couponApplied,
        extraDays: preview?.extraDays ?? 0,
      );

      _currentOrder = orderRes.data;

      await _openRazorpay(finalAmount);
    } catch (e) {
      Get.snackbar('Error', 'Unable to create order. Please try again.');
    }
  }

  Future<void> _openRazorpay(int finalAmount) async {
    var key = _paymentController.razorpayKey;

    // If key is empty, try to load credentials
    if (key.isEmpty) {
      await _paymentController.loadCredentials();
      key = _paymentController.razorpayKey;
    }

    if (key.isEmpty) {
      Get.snackbar(
        'Payment Error',
        'Payment service not available. Please try later.',
      );
      return;
    }

    _razorpay.open({
      'key': key,
      'order_id': _currentOrder!.razorpayOrderId,
      'amount': finalAmount * 100,
      'name': 'Gixa',
      'description': 'Subscription Purchase',
    });
  }

  bool hasFeature(String featureName) {
    if (activePlan.value == null) {
      unawaited(_restoreActivePlanFromStorage());

      if (_isRestoringActivePlan) {
        print("⏳ Restoring Active Plan...");
      } else {
        print("❌ No Active Plan");
      }

      return false;
    }

    print("🔍 Checking Feature: $featureName");

    for (var f in activePlan.value!.features) {
      print("User Feature: ${f.featureTitle}");
    }

    final normalizedRequired = _normalizeFeatureText(featureName);

    final has = activePlan.value!.features.any((feature) {
      final normalizedAvailable = _normalizeFeatureText(feature.featureTitle);
      return normalizedAvailable == normalizedRequired ||
          normalizedAvailable.contains(normalizedRequired) ||
          normalizedRequired.contains(normalizedAvailable);
    });

    print(has ? "✅ Feature Allowed" : "❌ Feature Locked");

    return has;
  }

  Future<void> loadActivePlanFromHistory(int userId) async {
    try {
      final history = await SubscriptionApi.getSubscriptionHistory(
        userId: userId,
      );

      final active = history.firstWhere((h) => h.isActive == true);

      activePlan.value = SubscriptionPlan(
        id: active.plan.id,
        planName: active.plan.planName,
        planCode: active.plan.planCode,
        planType: active.plan.planType,
        amount: active.plan.amount,
        durationDays: active.plan.durationDays,
        description: active.plan.description,
        isRecommended: active.plan.isRecommended,
        features: active.plan.features
            .map(
              (f) => Feature(
                id: f.id,
                featureTitle: f.featureTitle,
                featureDescription: f.featureDescription,
              ),
            )
            .toList(),
      );

      for (var f in activePlan.value?.features ?? []) {
        print("Feature: ${f.featureTitle}");
      }
    } catch (e) {
      print("Failed to load active plan from history");
    }
  }

  /// ✅ Payment success → verify with backend
  Future<void> _onPaymentSuccess(PaymentSuccessResponse res) async {
    try {
      final verifyRes = await SubscriptionApi.verifyPayment(
        razorpayOrderId: res.orderId!,
        razorpayPaymentId: res.paymentId!,
        razorpaySignature: res.signature!,
      );

      if (verifyRes.status) {
        await _refreshActivePlanAfterPayment(verifyRes.data.plan);

        print("Active Plan: ${activePlan.value?.planName}");
        print("Features:");
        for (var f in activePlan.value?.features ?? []) {
          print(f.featureTitle);
        }

        Get.snackbar(
          'Success',
          'Subscription Activated (${verifyRes.data.plan}) 🎉',
        );
      } else {
        Get.snackbar('Error', verifyRes.message);
      }
    } catch (e) {
      Get.snackbar(
        'Verification Failed',
        'Payment received but verification failed',
      );
    }
  }

  /// ❌ Payment failed
  void _onPaymentError(PaymentFailureResponse res) {
    Get.snackbar('Payment Failed', res.message ?? 'Something went wrong');
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────

  /// 🔧 Safe amount parser
  int _parseAmount(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.parse(cleaned).round();
  }

  String _normalizeText(String value) {
    return value.trim().toLowerCase();
  }

  String _normalizeFeatureText(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();
  }

  Future<void> _refreshActivePlanAfterPayment(String verifiedPlanCode) async {
    await fetchPlans();

    final userId = _readUserIdFromStorage();
    if (userId != null) {
      await loadActivePlanFromHistory(userId);
      if (activePlan.value != null) {
        // Save unlocked features to user-specific storage
        final unlockedFeatures = activePlan.value!.features
            .map((f) => f.featureTitle)
            .toList();
        _box.write(_userFeaturesKey(userId), unlockedFeatures);
        print('💾 Saved user_features for user $userId: $unlockedFeatures');
        // Extra debug: read back immediately
        final verifyFeatures = _box.read(_userFeaturesKey(userId));
        print('🟢 Immediately read user_features after write: $verifyFeatures');
        return;
      }
    }

    // Prefer history as source of truth after payment verification.
    await _historyController.fetchSubscriptionHistory();

    final activeHistory = _historyController.historyList
        .where((history) => history.isActive)
        .toList();

    if (activeHistory.isNotEmpty) {
      final latestActive = activeHistory.first;
      final didSet = setActivePlanByCode(latestActive.plan.planCode);
      if (didSet) {
        final userId = _readUserIdFromStorage();
        if (userId != null) {
          final unlockedFeatures = activePlan.value!.features
              .map((f) => f.featureTitle)
              .toList();
          _box.write(_userFeaturesKey(userId), unlockedFeatures);
          print('💾 Saved user_features for user $userId: $unlockedFeatures');
          final verifyFeatures = _box.read(_userFeaturesKey(userId));
          print(
            '🟢 Immediately read user_features after write: $verifyFeatures',
          );
        }
        return;
      }
    }

    // Fallback to verify-payment response when history is delayed.
    setActivePlanByCode(verifiedPlanCode);
    if (activePlan.value != null) {
      final userId = _readUserIdFromStorage();
      if (userId != null) {
        final unlockedFeatures = activePlan.value!.features
            .map((f) => f.featureTitle)
            .toList();
        _box.write(_userFeaturesKey(userId), unlockedFeatures);
        print('💾 Saved user_features for user $userId: $unlockedFeatures');
        final verifyFeatures = _box.read(_userFeaturesKey(userId));
        print('🟢 Immediately read user_features after write: $verifyFeatures');
      }
    }
  }

  Future<void> _restoreActivePlanFromStorage() async {
    if (_isRestoringActivePlan || activePlan.value != null) return;

    final userId = _readUserIdFromStorage();
    if (userId == null) return;

    _isRestoringActivePlan = true;
    try {
      if (plans.isEmpty) {
        await fetchPlans();
      }
      await loadActivePlanFromHistory(userId);
    } finally {
      _isRestoringActivePlan = false;
    }
  }

  int? _readUserIdFromStorage() {
    final raw = _box.read(_userIdKey);
    if (raw is int) return raw;
    if (raw is String) return int.tryParse(raw);
    return null;
  }

  /// 🔹 Get coupon error for UI
  String couponErrorFor(int planId) {
    return couponErrorMap[planId] ?? '';
  }

  /// 🔹 Get preview for UI
  SubscriptionPurchaseData? previewFor(int planId) {
    return previewMap[planId];
  }
}
