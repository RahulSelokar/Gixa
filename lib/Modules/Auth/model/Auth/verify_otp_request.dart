class VerifyOtpRequest {
  final String mobileNumber;
  final String otp;
  final String deviceId;
  final String? fcmToken;

  VerifyOtpRequest({
    required this.mobileNumber,
    required this.otp,
    required this.deviceId,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    final data = {
      "mobile_number": mobileNumber,
      "otp": otp,
      "device_id": deviceId,
    };

    if (fcmToken != null && fcmToken!.isNotEmpty) {
      data["fcm_token"] = fcmToken!; 
    }

    return data;
  }
}
