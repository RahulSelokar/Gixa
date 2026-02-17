class PaymentCredentialModel {
  final String gatewayName;
  final String keyId;
  final bool isLive;
  final bool isActive;

  PaymentCredentialModel({
    required this.gatewayName,
    required this.keyId,
    required this.isLive,
    required this.isActive,
  });

  factory PaymentCredentialModel.fromJson(Map<String, dynamic> json) {
    return PaymentCredentialModel(
      gatewayName: json['gateway_name'],
      keyId: json['key_id'],
      isLive: json['is_live'],
      isActive: json['is_active'],
    );
  }
}
