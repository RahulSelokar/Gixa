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
  final String planType;

  Plan({
    required this.id,
    required this.planName,
    required this.planType,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      planName: json['plan_name'],
      planType: json['plan_type'],
    );
  }
}
