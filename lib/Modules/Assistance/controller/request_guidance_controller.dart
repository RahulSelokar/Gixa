import 'package:get/get.dart';
import '../model/request_guidance_model.dart';
import 'package:Gixa/services/request_guidance_service.dart';

class RequestGuidanceController extends GetxController {

  final RxBool isSubmitting = false.obs;

  // ─────────────────────────────────────────────
  // 🚀 SUBMIT REQUEST
  // ─────────────────────────────────────────────
  Future<void> submit(RequestGuidanceRequest request) async {

    if (!_validate(request)) return;

    try {
      isSubmitting.value = true;

      final response = await RequestGuidanceService.requestGuidance(
        counselorId: request.counselorId,
        firstName: request.firstName.trim(),
        lastName: request.lastName.trim(),
        mobileNumber: request.mobileNumber.trim(),
        message: request.message.trim(),
      );

      Get.back();

      Get.snackbar(
        "Request Sent",
        response['message'] ?? "Your guidance request has been submitted successfully.",
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {

      Get.snackbar(
        "Submission Failed",
        "Unable to send guidance request. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );

    } finally {
      isSubmitting.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // ✅ VALIDATION
  // ─────────────────────────────────────────────
  bool _validate(RequestGuidanceRequest request) {

    if (request.firstName.trim().isEmpty ||
        request.lastName.trim().isEmpty ||
        request.message.trim().isEmpty) {

      Get.snackbar(
        "Incomplete Form",
        "Please fill in all required fields.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (!RegExp(r'^[0-9]{10}$')
        .hasMatch(request.mobileNumber.trim())) {

      Get.snackbar(
        "Invalid Mobile Number",
        "Please enter a valid 10-digit mobile number.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }
}
