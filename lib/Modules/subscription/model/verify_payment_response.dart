class VerifyPaymentResponse {
  final bool status;
  final String message;
  final VerifyPaymentData data;
  final int? subscriptionId; // ✅ FIXED

  VerifyPaymentResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.subscriptionId,
  });

  factory VerifyPaymentResponse.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentResponse(
      status: json['status'],
      message: json['message'],
      data: VerifyPaymentData.fromJson(json['data']),

      /// ✅ SAFE PARSE
      subscriptionId: json['subscription_id'] == null
          ? null
          : json['subscription_id'] is int
          ? json['subscription_id']
          : int.tryParse(json['subscription_id'].toString()),
    );
  }
}

class VerifyPaymentData {
  final String plan;
  final DateTime startDate;
  final DateTime endDate;
  final int? subscriptionId; // ✅ FIXED

  VerifyPaymentData({
    required this.plan,
    required this.startDate,
    required this.endDate,
    required this.subscriptionId,
  });

  factory VerifyPaymentData.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentData(
      plan: json['plan'] ?? '',
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime.now(),

      /// ✅ SAFE PARSE
      subscriptionId: json['subscription_id'] == null
          ? null
          : json['subscription_id'] is int
          ? json['subscription_id']
          : int.tryParse(json['subscription_id'].toString()),
    );
  }
}
