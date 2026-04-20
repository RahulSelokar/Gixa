class SubscriptionHistoryResponse {
  final String status;
  final List<SubscriptionHistory> data;

  SubscriptionHistoryResponse({
    required this.status,
    required this.data,
  });

  factory SubscriptionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionHistoryResponse(
      status: json['status'],
      data: (json['data'] as List)
          .map((e) => SubscriptionHistory.fromJson(e))
          .toList(),
    );
  }
}

class SubscriptionHistory {
  final int id;
  final Plan plan;
  final String paymentStatus;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final String finalAmount;
  final String status;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? startDate;
  final DateTime? endDate;

  SubscriptionHistory({
    required this.id,
    required this.plan,
    required this.paymentStatus,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    required this.finalAmount,
    required this.status,
    required this.isActive,
    required this.createdAt,
    this.startDate,
    this.endDate,
  });

  factory SubscriptionHistory.fromJson(Map<String, dynamic> json) {
    return SubscriptionHistory(
      id: json['id'],
      plan: Plan.fromJson(json['plan']),
      paymentStatus: json['payment_status'],
      razorpayOrderId: json['razorpay_order_id'],
      razorpayPaymentId: json['razorpay_payment_id'],
      finalAmount: json['final_amount'],
      status: json['status'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      startDate:
          json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
    );
  }
}

class Plan {
  final int id;
  final String planName;
  final String planCode;
  final String planType;
  final String amount;
  final int durationDays;
  final String description;
  final bool isRecommended;
  final List<Feature> features;

  Plan({
    required this.id,
    required this.planName,
    required this.planCode,
    required this.planType,
    required this.amount,
    required this.durationDays,
    required this.description,
    required this.isRecommended,
    required this.features,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      planName: json['plan_name'],
      planCode: json['plan_code'],
      planType: json['plan_type'],
      amount: json['amount'],
      durationDays: json['duration_days'],
      description: json['description'],
      isRecommended: json['is_recommended'],
      features: (json['features'] as List)
          .map((e) => Feature.fromJson(e))
          .toList(),
    );
  }
}
class Feature {
  final int id;
  final String featureTitle;
  final String featureDescription;

  Feature({
    required this.id,
    required this.featureTitle,
    required this.featureDescription,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: json['id'],
      featureTitle: json['feature_title'],
      featureDescription: json['feature_description'],
    );
  }
}
