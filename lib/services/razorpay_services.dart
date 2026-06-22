import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:Gixa/Modules/payment/controller/payment_controller.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';

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

    print('ðŸ”‘ Razorpay Key: $key');
    print('ðŸ’° Amount: $amount');

    if (key.isEmpty) {
      AppSnackbar.show('Payment Error', 'Razorpay key not loaded');
      return;
    }

    if (amount <= 0) {
      AppSnackbar.show('Payment Error', 'Invalid payment amount');
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
      print('âŒ Razorpay open error: $e');
    }
  }

  void _onSuccess(PaymentSuccessResponse response) {
    print('âœ… Payment Success: ${response.paymentId}');
    AppSnackbar.show('Success', 'Payment Successful');
  }

  void _onError(PaymentFailureResponse response) {
    print('âŒ Payment Failed: ${response.message}');
    AppSnackbar.show('Failed', response.message ?? 'Payment failed');
  }

  void _onWallet(ExternalWalletResponse response) {
    print('ðŸ‘› Wallet: ${response.walletName}');
  }

  void dispose() {
    _razorpay.clear();
  }
}

