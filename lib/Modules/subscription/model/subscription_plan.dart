class SubscriptionPlanResponse {
  final bool status;
  final String message;
  final List<SubscriptionPlan> data;

  SubscriptionPlanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SubscriptionPlanResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanResponse(
      status: json['status'],
      message: json['message'],
      data: List<SubscriptionPlan>.from(
        json['data'].map((x) => SubscriptionPlan.fromJson(x)),
      ),
    );
  }
}

class SubscriptionPlan {
  final int id;
  final String planName;
  final String planCode;
  final String planType;
  final String amount;
  final int durationDays;
  final String description;
  final bool isRecommended;
  final List<Feature> features;

  SubscriptionPlan({
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

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'],
      planName: json['plan_name'],
      planCode: json['plan_code'],
      planType: json['plan_type'],
      amount: json['amount'],
      durationDays: json['duration_days'],
      description: json['description'],
      isRecommended: json['is_recommended'],
      features: List<Feature>.from(
        json['features'].map((x) => Feature.fromJson(x)),
      ),
    );
  }
   bool get bestValue => isRecommended;
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
