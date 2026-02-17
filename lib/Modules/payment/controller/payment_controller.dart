import 'package:get/get.dart';
import 'package:Gixa/services/payment_services.dart';
import 'package:Gixa/services/token_services.dart';
import '../model/payment_creandential_model.dart';

class PaymentController extends GetxController {
  /// Active Razorpay credential
  PaymentCredentialModel? razorpay;

  /// Loading state (optional but useful)
  final isLoading = false.obs;

  /// Error state (optional)
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _safeLoadCredentials();
  }

  /// ✅ Wait for token before calling API
  Future<void> _safeLoadCredentials() async {
    final hasToken = await TokenService.hasValidToken();

    if (!hasToken) {
      print('⚠️ No token yet, skipping payment credentials fetch');
      return;
    }

    await loadCredentials();
  }

  /// 🔑 Fetch payment credentials from backend
  Future<void> loadCredentials() async {
    try {
      isLoading.value = true;
      error.value = '';

      print('📥 HIT PAYMENT CREDENTIAL API');

      final list = await PaymentApiService.getPaymentCredentials();

      razorpay = list.firstWhere(
        (e) => e.gatewayName == 'RAZORPAY' && e.isActive,
      );

      print('🔑 Loaded Razorpay Key: ${razorpay?.keyId}');
    } catch (e) {
      error.value = e.toString();
      print('❌ Payment credential error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Safe getter used by RazorpayService
  String get razorpayKey => razorpay?.keyId ?? '';
}
