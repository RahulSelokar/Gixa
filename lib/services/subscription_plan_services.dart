import 'package:Gixa/Modules/subscription/model/create_order_model.dart';
import 'package:Gixa/Modules/subscription/model/subscription_history_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';
import 'package:Gixa/Modules/subscription/model/subscription_plan.dart';
import 'package:Gixa/Modules/subscription/model/subscription_purchase_model.dart';
import 'package:Gixa/Modules/subscription/model/verify_payment_response.dart';

class SubscriptionApi {
  /// 🔹 GET SUBSCRIPTION PLANS
  static Future<List<SubscriptionPlan>> getPlans() async {
    final response = await ApiClient.get(ApiEndpoints.subscriptionPlans);
    final parsed = SubscriptionPlanResponse.fromJson(response);
    return parsed.data;
  }

  /// 🔹 APPLY COUPON / PRICE PREVIEW
  static Future<SubscriptionPurchaseResponse> purchaseSubscription({
    required int planId,
    String? couponCode,
  }) async {
    final response = await ApiClient.post(ApiEndpoints.subscriptionPurchase, {
      "plan_id": planId,
      if (couponCode != null && couponCode.isNotEmpty)
        "coupon_code": couponCode,
    });
    return SubscriptionPurchaseResponse.fromJson(response);
  }

  /// 🔥 CREATE ORDER (REAL PAYMENT)
  static Future<CreateOrderResponse> createOrder({
    required int planId,
    required int baseAmount,
    required int finalAmount,
    String? couponCode,
    int extraDays = 0,
  }) async {
    final response =
        await ApiClient.post(ApiEndpoints.subscriptionCreateOrder, {
          "plan_id": planId,
          "base_amount": baseAmount.toString(),
          "final_amount": finalAmount.toString(),
          "coupon_code": couponCode ?? "",
          "extra_days": extraDays,
        });
    return CreateOrderResponse.fromJson(response);
  }

  /// ✅ VERIFY PAYMENT
  static Future<VerifyPaymentResponse> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    final response =
        await ApiClient.post(ApiEndpoints.subscriptionVerifyPayment, {
          "razorpay_order_id": razorpayOrderId,
          "razorpay_payment_id": razorpayPaymentId,
          "razorpay_signature": razorpaySignature,
        });
    return VerifyPaymentResponse.fromJson(response);
  }

  /// 🧾 GET SUBSCRIPTION HISTORY
  static Future<List<SubscriptionHistory>> getSubscriptionHistory({
    required int userId,
  }) async {
    final response = await ApiClient.get(
      ApiEndpoints.subscriptionHistory(userId),
    );

    print("══════════════════════════════════════");
    print("📥 SUBSCRIPTION RAW RESPONSE: $response");

    if (response is! Map<String, dynamic>) {
      throw Exception("Invalid response format");
    }

    final data = response['data'];

    if (data is! List) {
      throw Exception("Invalid subscription list");
    }

    return data
        .map((e) => SubscriptionHistory.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
