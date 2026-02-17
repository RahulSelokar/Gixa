class SubscriptionPurchaseResponse {
  final bool status;
  final String message;
  final SubscriptionPurchaseData data;

  SubscriptionPurchaseResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SubscriptionPurchaseResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionPurchaseResponse(
      status: json['status'],
      message: json['message'],
      data: SubscriptionPurchaseData.fromJson(json['data']),
    );
  }
}

class SubscriptionPurchaseData {
  final int planId;
  final String planName;
  final String baseAmount;
  final String planDiscount;
  final String couponDiscount;
  final String finalPayableAmount;
  final int durationDays;
  final int extraDays;
  final String? couponApplied;

  SubscriptionPurchaseData({
    required this.planId,
    required this.planName,
    required this.baseAmount,
    required this.planDiscount,
    required this.couponDiscount,
    required this.finalPayableAmount,
    required this.durationDays,
    required this.extraDays,
    this.couponApplied,
  });

  factory SubscriptionPurchaseData.fromJson(Map<String, dynamic> json) {
    return SubscriptionPurchaseData(
      planId: json['plan_id'],
      planName: json['plan_name'],
      baseAmount: json['base_amount'],
      planDiscount: json['plan_discount'],
      couponDiscount: json['coupon_discount'],
      finalPayableAmount: json['final_payable_amount'],
      durationDays: json['duration_days'],
      extraDays: json['extra_days'],
      couponApplied: json['coupon_applied'],
    );
  }
}
