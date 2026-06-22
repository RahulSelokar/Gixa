import 'package:Gixa/services/payment_services.dart';
import 'package:Gixa/services/token_services.dart';
import 'package:get/get.dart';

import '../model/payment_creandential_model.dart';

class PaymentController extends GetxController {
  PaymentCredentialModel? razorpay;

  final isLoading = false.obs;
  final error = ''.obs;

  void clearCredentials() {
    razorpay = null;
    error.value = '';
  }

  Future<void> loadCredentials({bool forceRefresh = false}) async {
    final hasToken = await TokenService.hasValidToken();
    if (!hasToken) {
      print('No token yet, skipping payment credentials fetch');
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final list = await PaymentApiService.getPaymentCredentials(
        forceRefresh: forceRefresh,
      );

      razorpay = list.firstWhere(
        (e) => e.gatewayName == 'RAZORPAY' && e.isActive,
      );
    } catch (e) {
      error.value = e.toString();
      print('Payment credential error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String get razorpayKey => razorpay?.keyId ?? '';
}
