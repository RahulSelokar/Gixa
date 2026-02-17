class RequestGuidanceRequest {
  final int counselorId;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String message;

  RequestGuidanceRequest({
    required this.counselorId,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      "counselor_id": counselorId,
      "first_name": firstName,
      "last_name": lastName,
      "mobile_number": mobileNumber,
      "message": message,
    };
  }
}

class RequestGuidanceResponse {
  final bool success;
  final String message;

  RequestGuidanceResponse({
    required this.success,
    required this.message,
  });

  factory RequestGuidanceResponse.fromJson(Map<String, dynamic> json) {
    return RequestGuidanceResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
