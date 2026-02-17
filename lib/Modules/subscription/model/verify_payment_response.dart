class VerifyPaymentResponse {
  final bool status;
  final String message;
  final VerifyPaymentData data;

  VerifyPaymentResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VerifyPaymentResponse.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentResponse(
      status: json['status'],
      message: json['message'],
      data: VerifyPaymentData.fromJson(json['data']),
    );
  }
}

class VerifyPaymentData {
  final String plan;
  final DateTime startDate;
  final DateTime endDate;

  VerifyPaymentData({
    required this.plan,
    required this.startDate,
    required this.endDate,
  });

  factory VerifyPaymentData.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentData(
      plan: json['plan'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }
}
