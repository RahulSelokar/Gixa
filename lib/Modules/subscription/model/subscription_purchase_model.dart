class SubscriptionPurchaseResponse {
  final bool status;
  final String message;
  final SubscriptionPurchaseData? data;

  SubscriptionPurchaseResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SubscriptionPurchaseResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    return SubscriptionPurchaseResponse(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      data: rawData is Map<String, dynamic>
          ? SubscriptionPurchaseData.fromJson(rawData)
          : null,
    );
  }
}

class SubscriptionPurchaseData {
  final int planId;
  final String planName;
  final String baseAmount;
  final String planDiscount;
  final String couponDiscount;
  final String planPayableAmount;
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
    required this.planPayableAmount,
    required this.finalPayableAmount,
    required this.durationDays,
    required this.extraDays,
    this.couponApplied,
  });

  factory SubscriptionPurchaseData.fromJson(Map<String, dynamic> json) {
    return SubscriptionPurchaseData(
      planId: _toInt(json['plan_id']),
      planName: json['plan_name']?.toString() ?? '',
      baseAmount: json['base_amount']?.toString() ?? '0',
      planDiscount: json['plan_discount']?.toString() ?? '0',
      couponDiscount: json['coupon_discount']?.toString() ?? '0',
      planPayableAmount: json['plan_payable_amount']?.toString() ?? json['final_payable_amount']?.toString() ?? '0',
      finalPayableAmount: json['final_payable_amount']?.toString() ?? '0',
      durationDays: _toInt(json['duration_days']),
      extraDays: _toInt(json['extra_days']),
      couponApplied: json['coupon_applied']?.toString(),
    );
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
