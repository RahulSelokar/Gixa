// import 'package:get/get.dart';
// import 'package:Gixa/services/subscription_plan_services.dart';
// import 'package:Gixa/Modules/subscription/model/subscription_plan.dart';
// import 'package:Gixa/Modules/subscription/model/subscription_purchase_model.dart';

// class SubscriptionController extends GetxController {
//   /// 📦 Subscription plans list
//   final RxList<SubscriptionPlan> plans = <SubscriptionPlan>[].obs;

//   /// ⏳ Plans loading
//   final RxBool isLoading = false.obs;

//   /// ⏳ Purchase / coupon loading
//   final RxBool isPurchasing = false.obs;

//   /// ❌ Plan fetch error ONLY
//   final RxString error = ''.obs;

//   /// ❌ Coupon / purchase error (INLINE UI)
//   final RxString couponError = ''.obs;

//   /// ✅ Purchase result
//   final Rxn<SubscriptionPurchaseData> purchaseData =
//       Rxn<SubscriptionPurchaseData>();

//   @override
//   void onInit() {
//     super.onInit();
//     fetchPlans();
//   }

//   /// 🔹 Fetch subscription plans
//   Future<void> fetchPlans() async {
//     try {
//       isLoading.value = true;
//       error.value = '';

//       final result = await SubscriptionApi.getPlans();
//       plans.assignAll(result);
//     } catch (e, stack) {
//       print('❌ Subscription error: $e');
//       print(stack);
//       error.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// 🔹 Apply coupon / purchase plan
//   Future<void> purchasePlan({
//     required int planId,
//     String? couponCode,
//   }) async {
//     try {
//       isPurchasing.value = true;

//       // reset coupon-specific state
//       couponError.value = '';
//       purchaseData.value = null;

//       final response = await SubscriptionApi.purchaseSubscription(
//         planId: planId,
//         couponCode: couponCode,
//       );

//       if (response.status) {
//         purchaseData.value = response.data;
//       } else {
//         // 👇 coupon not applicable / invalid / expired
//         couponError.value = response.message;
//       }
//     } catch (e) {
//       couponError.value = e.toString();
//     } finally {
//       isPurchasing.value = false;
//     }
//   }

//   /// 🔹 Clear coupon (optional helper)
//   void clearCoupon() {
//     couponError.value = '';
//     purchaseData.value = null;
//   }
// }


import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../model/subscription_plan.dart';
import '../model/subscription_purchase_model.dart';
import '../model/create_order_model.dart';
import '../../../services/subscription_plan_services.dart';

// ✅ ADD THIS IMPORT
import 'package:Gixa/Modules/payment/controller/payment_controller.dart';

class SubscriptionController extends GetxController {
  /// 📦 Subscription plans
  final plans = <SubscriptionPlan>[].obs;

  /// ⏳ Loading
  final isLoading = false.obs;

  /// 💸 Coupon preview per plan
  final previewMap = <int, SubscriptionPurchaseData>{}.obs;

  /// ❌ Coupon error per plan
  final couponErrorMap = <int, String>{}.obs;

  /// 💳 Razorpay
  late Razorpay _razorpay;
  CreateOrderData? _currentOrder;

  /// 🔑 Payment controller (Razorpay key)
  late final PaymentController _paymentController;

  // ─────────────────────────────────────────────
  // LIFE CYCLE
  // ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();

    // ✅ Get existing PaymentController
    // _paymentController = Get.find<PaymentController>();
    _paymentController = Get.put(PaymentController());

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);

    fetchPlans();
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  // ─────────────────────────────────────────────
  // API CALLS
  // ─────────────────────────────────────────────

  /// 📦 Fetch subscription plans
  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;
      plans.assignAll(await SubscriptionApi.getPlans());
    } catch (e) {
      Get.snackbar('Error', 'Failed to load subscription plans');
    } finally {
      isLoading.value = false;
    }
  }

  /// 🎟 Apply coupon (price preview only)
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

  /// ❌ Remove applied coupon
  void clearCoupon(int planId) {
    previewMap.remove(planId);
    couponErrorMap.remove(planId);
  }

  // ─────────────────────────────────────────────
  // PAYMENT FLOW
  // ─────────────────────────────────────────────

  /// 💳 Create order & open Razorpay
  Future<void> createOrderAndPay(int planId) async {
    try {
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

      _openRazorpay(finalAmount);
    } catch (e) {
      Get.snackbar('Payment Error', 'This plan is already purchased');
    }
  }

  /// 🚀 Open Razorpay (FIXED)
  void _openRazorpay(int finalAmount) {
    final key = _paymentController.razorpayKey;

    if (key.isEmpty) {
      Get.snackbar('Payment Error', 'Payment service not ready');
      return;
    }

    _razorpay.open({
      'key': key, // ✅ REQUIRED — FIXES YOUR ERROR
      'order_id': _currentOrder!.razorpayOrderId,
      'amount': finalAmount * 100, // paise
      'name': 'Gixa',
      'description': 'Subscription Purchase',
    });
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
    Get.snackbar(
      'Payment Failed',
      res.message ?? 'Something went wrong',
    );
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────

  /// 🔧 Safe amount parser
  int _parseAmount(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.parse(cleaned).round();
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
