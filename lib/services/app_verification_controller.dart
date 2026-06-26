import 'package:get/get.dart';
import 'package:Gixa/services/payment_services.dart';

class AppVerificationController extends GetxController {
  static AppVerificationController get to => Get.find();

  final isQrCode = false.obs;
  final isLoading = true.obs;

  bool get hideSubscriptionUi {
    if (GetPlatform.isIOS) {
      return isQrCode.value;
    }
    return false;
  }

  @override
  void onInit() {
    super.onInit();
    verifyApp();
  }

  Future<void> verifyApp() async {
    isLoading.value = true;
    try {
      final verification = await PaymentApiService.checkPaymentVerification();
      isQrCode.value = verification.isQrCode;
    } catch (_) {
      isQrCode.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
