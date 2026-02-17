class SendOtpResponse {
  final String message;
  final String otp;
  final String? sessionId;

  SendOtpResponse({
    required this.message,
    required this.otp,
    this.sessionId
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      message: json['message'] ?? '',
      otp: json['otp']?.toString() ?? '',
       sessionId: json['session_id'],
    );
  }
}
