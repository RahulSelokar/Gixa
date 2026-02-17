import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CompleteProfileController extends GetxController {
  final TextEditingController phoneController = TextEditingController();

  final phone = ''.obs;

  final role = 'Student'.obs;
  final course = 'UG'.obs;
  final exam = 'NEET'.obs;

  final name = ''.obs;
  final email = ''.obs;

  final neetScore = ''.obs;
  final airRank = ''.obs;

  final isSubmitting = false.obs;

  /// Set verified phone from OTP flow
  void setPhone(String value) {
    phone.value = value;
  }

  bool validateNeetDetails() {
    if (neetScore.value.isEmpty || airRank.value.isEmpty) {
      Get.snackbar('Error', 'Please fill NEET score and AIR rank carefully');
      return false;
    }
    return true;
  }
}
