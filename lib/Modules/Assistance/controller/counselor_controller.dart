import 'package:Gixa/Modules/Assistance/model/counselor_model.dart';
import 'package:Gixa/services/counselor_services.dart';
import 'package:get/get.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';

class CounselorController extends GetxController {
  final RxList<Counselor> counselors = <Counselor>[].obs;
  final RxBool isLoading = false.obs;

  late String requestId;

  void init(String reqId) {
    requestId = reqId;
    fetchCounselors();
  }

  Future<void> fetchCounselors() async {
    try {
      isLoading.value = true;

      final data = await CounselorService.fetchCounselors(
        requestId: requestId,
      );

      counselors.assignAll(data);

      // ===============================
      // ðŸ§¾ DEBUG LOGS (COUNSELOR LIST)
      // ===============================
      print("â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•");
      print("ðŸ‘¨â€ðŸ« COUNSELOR LIST LOADED");
      print("ðŸ“Œ REQUEST ID: $requestId");
      print("ðŸ“Œ TOTAL COUNSELORS: ${data.length}");

      for (final counselor in data) {
        print(
          "ðŸ§‘ ID: ${counselor.id} | "
          "Name: ${counselor.name} | "
          "Experience: ${counselor.experienceYears} yrs | "
          "Rating: ${counselor.rating}",
        );
      }

      print("â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•");
    } catch (e) {
      print("âŒ COUNSELOR FETCH ERROR: $e");
      AppSnackbar.show("Error", "Failed to load counselors");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectCounselor(int counselorId) async {
    try {
      await CounselorService.selectCounselor(
        requestId: requestId,
        counselorId: counselorId,
      );

      print("âœ… COUNSELOR SELECTED: $counselorId");

      AppSnackbar.show("Success", "Counselor selected successfully");
      Get.back(); // move to next step (chat / payment)
    } catch (e) {
      print("âŒ COUNSELOR SELECT ERROR: $e");
      AppSnackbar.show("Error", "Unable to select counselor");
    }
  }
}

