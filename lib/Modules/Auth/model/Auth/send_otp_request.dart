class SendOtpRequest {
  final String mobileNumber;

  SendOtpRequest({required this.mobileNumber});

  Map<String, dynamic> toJson() {
    return {
      "mobile_number": mobileNumber,
    };
  }
}
