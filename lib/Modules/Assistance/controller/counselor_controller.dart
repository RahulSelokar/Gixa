import 'package:Gixa/Modules/Assistance/model/counselor_model.dart';
import 'package:Gixa/services/counselor_services.dart';
import 'package:get/get.dart';

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
      // 🧾 DEBUG LOGS (COUNSELOR LIST)
      // ===============================
      print("══════════════════════════════════════");
      print("👨‍🏫 COUNSELOR LIST LOADED");
      print("📌 REQUEST ID: $requestId");
      print("📌 TOTAL COUNSELORS: ${data.length}");

      for (final counselor in data) {
        print(
          "🧑 ID: ${counselor.id} | "
          "Name: ${counselor.name} | "
          "Experience: ${counselor.experienceYears} yrs | "
          "Rating: ${counselor.rating}",
        );
      }

      print("══════════════════════════════════════");
    } catch (e) {
      print("❌ COUNSELOR FETCH ERROR: $e");
      Get.snackbar("Error", "Failed to load counselors");
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

      print("✅ COUNSELOR SELECTED: $counselorId");

      Get.snackbar("Success", "Counselor selected successfully");
      Get.back(); // move to next step (chat / payment)
    } catch (e) {
      print("❌ COUNSELOR SELECT ERROR: $e");
      Get.snackbar("Error", "Unable to select counselor");
    }
  }
}
