class PaymentVerificationModel {
  final String? paymentGateway;

  PaymentVerificationModel({
    this.paymentGateway,
  });

  factory PaymentVerificationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaymentVerificationModel(
      paymentGateway: json['payment_gateway']
          ?.toString()
          .trim()
          .toLowerCase(),
    );
  }

  bool get isQrCode =>
      paymentGateway == 'qr_code';

  bool get isRazorpay =>
      paymentGateway == 'razorpay';
}