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

  /// FILTER VALUES
  String? search;
  String? state;
  String? instituteType;
  String? year;
  String? quota;
  String? round;
  int? minSeats;
  int? maxSeats;

  @override
  void onInit() {
    super.onInit();
    fetchColleges();
  }

  /// ─────────────────────────────────────────────
  /// 📚 FETCH COLLEGES (WITH FILTERS)
  /// ─────────────────────────────────────────────
  Future<void> fetchColleges() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await CollegeApiService.searchColleges(
        search: search,
        state: state,
        instituteType: instituteType,
        year: year,
        quota: quota,
        round: round,
        minSeats: minSeats,
        maxSeats: maxSeats,
      );

      print("══════════════════════════════════════");
      print("📚 COLLEGE LIST LOADED");
      print("📚 TOTAL COLLEGES: ${result.length}");
      print("🔍 FILTERS:");
      print("search: $search");
      print("state: $state");
      print("type: $instituteType");
      print("year: $year");
      print("quota: $quota");
      print("round: $round");
      print("minSeats: $minSeats");
      print("maxSeats: $maxSeats");
      print("══════════════════════════════════════");

      colleges.assignAll(result);
    } catch (e) {
      if (e is AppException) {
        errorMessage.value = e.message;
        Get.snackbar('Error', e.message);
      } else {
        errorMessage.value = 'Something went wrong';
        Get.snackbar('Error', errorMessage.value);
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// ─────────────────────────────────────────────
  /// 🔍 APPLY FILTERS
  /// ─────────────────────────────────────────────
  void applyFilters({
    String? searchValue,
    String? stateValue,
    String? instituteTypeValue,
    String? yearValue,
    String? quotaValue,
    String? roundValue,
    int? minSeatsValue,
    int? maxSeatsValue,
  }) {
    search = searchValue;
    state = stateValue;
    instituteType = instituteTypeValue;
    year = yearValue;
    quota = quotaValue;
    round = roundValue;
    minSeats = minSeatsValue;
    maxSeats = maxSeatsValue;

    fetchColleges();
  }

  /// ─────────────────────────────────────────────
  /// ❌ CLEAR FILTERS
  /// ─────────────────────────────────────────────
  void clearFilters() {
    search = null;
    state = null;
    instituteType = null;
    year = null;
    quota = null;
    round = null;
    minSeats = null;
    maxSeats = null;

    fetchColleges();
  }

  /// ─────────────────────────────────────────────
  /// 🔄 PULL TO REFRESH
  /// ─────────────────────────────────────────────
  Future<void> refreshList() async {
    await fetchColleges();
  }
}