import 'package:get/get.dart';
import 'package:Gixa/Modules/Collage/model/collage_model.dart';
import 'package:Gixa/services/college_api_service.dart';
import 'package:Gixa/network/app_exception.dart';

class CollegeListController extends GetxController {
  final CollegeApiService _service = CollegeApiService();

  /// UI STATES
  final isLoading = false.obs;
  final colleges = <College>[].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchColleges();
  }

  // ─────────────────────────────────────────────
  // 📚 FETCH COLLEGES
  // ─────────────────────────────────────────────
  Future<void> fetchColleges() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _service.fetchColleges();

      /// ✅ CONTROLLER-LEVEL SUMMARY LOG
      print("══════════════════════════════════════");
      print("📚 COLLEGE LIST LOADED SUCCESSFULLY");
      print("📚 TOTAL COLLEGES: ${result.length}");

      for (final college in result) {
        print("🏫 ${college.id} | ${college.name} | ${college.state.name}");
      }

      print("══════════════════════════════════════");

      /// ✅ UPDATE UI STATE
      colleges.assignAll(result);
    } catch (e) {
      if (e is AppException) {
        errorMessage.value = e.message;
        print("❌ COLLEGE LIST ERROR: ${e.debugMessage ?? e.message}");
        Get.snackbar('Error', e.message);
      } else {
        errorMessage.value = 'Something went wrong';
        print("❌ UNKNOWN ERROR: $e");
        Get.snackbar('Error', errorMessage.value);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // 🔄 PULL TO REFRESH
  // ─────────────────────────────────────────────
  Future<void> refreshList() async {
    await fetchColleges();
  }
}
