import 'package:get/get.dart';
import '../model/request_guidance_model.dart';
import 'package:Gixa/services/request_guidance_service.dart';

class RequestGuidanceController extends GetxController {
  final RxBool isSubmitting = false.obs;

  // 🔹 Rx fields
  final RxString firstName = ''.obs;
  final RxString lastName = ''.obs;
  final RxString mobileNumber = ''.obs;
  final RxString message = ''.obs;

  Future<void> submit(RequestGuidanceRequest request) async {
    if (!_validate()) return;

    try {
      isSubmitting.value = true;

      final response = await RequestGuidanceService.requestGuidance(
        counselorId: request.counselorId,
        firstName: firstName.value,        // ✅ FIX
        lastName: lastName.value,          // ✅ FIX
        mobileNumber: mobileNumber.value,  // ✅ FIX
        message: message.value,            // ✅ FIX
      );

      Get.back();
      Get.snackbar("Success", response['message'] ?? "Request sent");
    } catch (e) {
      Get.snackbar("Error", "Failed to send guidance request");
    } finally {
      isSubmitting.value = false;
    }
  }

  bool _validate() {
    if (firstName.value.isEmpty ||
        lastName.value.isEmpty ||
        message.value.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return false;
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(mobileNumber.value)) {
      Get.snackbar("Error", "Enter valid 10-digit mobile number");
      return false;
    }

    return true;
  }
}
