class SupportContactModel {
  final String phoneNumber;
  final String email;

  SupportContactModel({
    required this.phoneNumber,
    required this.email,
  });

  factory SupportContactModel.fromJson(Map<String, dynamic> json) {
    return SupportContactModel(
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
