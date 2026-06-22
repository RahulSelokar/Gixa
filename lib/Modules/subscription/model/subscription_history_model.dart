class SubscriptionHistoryResponse {
  final String status;
  final List<SubscriptionHistory> data;

  SubscriptionHistoryResponse({required this.status, required this.data});

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
  final String baseAmount;
  final String totalDiscountAmount;

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
    required this.baseAmount,
    required this.totalDiscountAmount,
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
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      baseAmount: json['base_amount'] ?? "0",
      totalDiscountAmount: json['total_discount_amount'] ?? "0",
    );
  }

  bool get isExpired {
    final normalizedStatus = status.trim().toUpperCase();
    if (normalizedStatus == 'EXPIRED') {
      return true;
    }

    if (paymentStatus.trim().toUpperCase() != 'SUCCESS') {
      return false;
    }

    final expiryDate = endDate;
    return !isActive &&
        expiryDate != null &&
        expiryDate.isBefore(DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan': {
        'id': plan.id,
        'plan_name': plan.planName,
        'plan_code': plan.planCode,
        'plan_type': plan.planType,
        'amount': plan.amount,
        'duration_days': plan.durationDays,
        'description': plan.description,
        'is_recommended': plan.isRecommended,
        'is_addon': plan.isAddon,
        'features': plan.features
            .map(
              (feature) => {
                'id': feature.id,
                'feature_code': feature.featureCode,
                'feature_title': feature.featureTitle,
                'feature_description': feature.featureDescription,
                'is_enabled': feature.isEnabled,
              },
            )
            .toList(),
      },
      'payment_status': paymentStatus,
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': razorpayPaymentId,
      'final_amount': finalAmount,
      'status': status,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'base_amount': baseAmount,
      'total_discount_amount': totalDiscountAmount,
    };
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
  final bool isAddon;
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
    this.isAddon = false,
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
      isAddon: json['is_addon'] == true || json['is_addon'] == 1 || json['is_addon'] == '1',
      features: (json['features'] as List)
          .map((e) => Feature.fromJson(e))
          .toList(),
    );
  }
}

class Feature {
  final int id;
  final String featureCode;
  final String featureTitle;
  final String featureDescription;
  final bool isEnabled;

  Feature({
    required this.id,
    required this.featureCode,
    required this.featureTitle,
    required this.featureDescription,
    required this.isEnabled,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: json['id'],
      featureCode: json['feature_code'] ?? '',
      featureTitle: json['feature_title'] ?? '',
      featureDescription: json['feature_description'] ?? '',
      isEnabled: json['is_enabled'] ?? false,
    );
  }
}
