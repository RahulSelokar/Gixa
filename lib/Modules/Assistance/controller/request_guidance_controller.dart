import 'package:Gixa/network/app_exception.dart';
import 'package:get/get.dart';
import '../model/request_guidance_model.dart';
import 'package:Gixa/services/request_guidance_service.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';

class RequestGuidanceController extends GetxController {
  final RxBool isSubmitting = false.obs;

  Future<String?> submit(RequestGuidanceRequest request) async {
    if (!_validate(request)) return null;

    try {
      isSubmitting.value = true;

      final response = await RequestGuidanceService.requestGuidance(
        counselorId: request.counselorId,
        subscriptionPlanId: request.subscriptionPlanId,
        subscriptionPlanName: request.subscriptionPlanName,
        subscriptionPlanCode: request.subscriptionPlanCode,
        firstName: request.firstName.trim(),
        lastName: request.lastName.trim(),
        mobileNumber: request.mobileNumber.trim(),
        message: request.message.trim(),
        email: request.email?.trim() ?? '',
      );

      if (!response.success) {
        String errorMessage = response.message;

        print("RESPONSE ERRORS: ${response.errors}");

        if (response.errors != null && response.errors!.isNotEmpty) {
          final firstKey = response.errors!.keys.first;

          final firstValue = response.errors![firstKey];

          if (firstValue is List && firstValue.isNotEmpty) {
            errorMessage = firstValue.first.toString();
          } else {
            errorMessage = firstValue.toString();
          }
        }

        AppSnackbar.show(
          "Submission Failed",
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );

        return null;
      }

      return response.message.isNotEmpty
          ? response.message
          : "Your guidance request has been submitted successfully.";
    } on AppException catch (e) {
      String errorMessage = e.message;

      if (e.errors != null && e.errors!.isNotEmpty) {
        final firstKey = e.errors!.keys.first;

        final firstValue = e.errors![firstKey];

        if (firstValue is List && firstValue.isNotEmpty) {
          errorMessage = firstValue.first.toString();
        } else {
          errorMessage = firstValue.toString();
        }
      }

      AppSnackbar.show(
        "Submission Failed",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );

      return null;
    } catch (e) {
      AppSnackbar.show(
        "Submission Failed",
        "Unable to send guidance request. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );

      return null;
    } finally {
      isSubmitting.value = false;
    }
  }

  bool _validate(RequestGuidanceRequest request) {
    if (request.subscriptionPlanName.trim().isEmpty) {
      AppSnackbar.show(
        "Select a Plan",
        "Please choose a subscription plan before submitting your request.",
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }

    if (request.firstName.trim().isEmpty ||
        request.lastName.trim().isEmpty ||
        (request.email?.trim().isEmpty ?? true) ||
        request.message.trim().isEmpty) {
      AppSnackbar.show(
        "Incomplete Form",
        "Please fill in all required fields.",
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }

    if (!GetUtils.isEmail(request.email?.trim() ?? '')) {
      AppSnackbar.show(
        "Invalid Email",
        "Please enter a valid email address.",
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(request.mobileNumber.trim())) {
      AppSnackbar.show(
        "Invalid Mobile Number",
        "Please enter a valid 10-digit mobile number.",
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }

    if (request.message.trim().length < 10) {
      AppSnackbar.show(
        "Invalid Message",
        "Message should be at least 10 characters long.",
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }

    return true;
  }
}
