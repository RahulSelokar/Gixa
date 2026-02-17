import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:Gixa/Modules/payment/controller/payment_controller.dart';

class RazorpayService {
  late Razorpay _razorpay;

  RazorpayService() {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onWallet);
  }

  void startPayment({
    required int amount,
    required String description,
    required String email,
    required String contact,
  }) {
    final key = Get.find<PaymentController>().razorpayKey;

    print('🔑 Razorpay Key: $key');
    print('💰 Amount: $amount');

    if (key.isEmpty) {
      Get.snackbar('Payment Error', 'Razorpay key not loaded');
      return;
    }

    if (amount <= 0) {
      Get.snackbar('Payment Error', 'Invalid payment amount');
      return;
    }

    final options = {
      'key': key,
      'amount': amount * 100, // paise
      'name': 'Gixa',
      'description': description,
      'prefill': {
        'email': email,
        'contact': contact,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('❌ Razorpay open error: $e');
    }
  }

  void _onSuccess(PaymentSuccessResponse response) {
    print('✅ Payment Success: ${response.paymentId}');
    Get.snackbar('Success', 'Payment Successful');
  }

  void _onError(PaymentFailureResponse response) {
    print('❌ Payment Failed: ${response.message}');
    Get.snackbar('Failed', response.message ?? 'Payment failed');
  }

  void _onWallet(ExternalWalletResponse response) {
    print('👛 Wallet: ${response.walletName}');
  }

  void dispose() {
    _razorpay.clear();
  }
}
