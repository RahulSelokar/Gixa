import 'dart:async';
import 'package:Gixa/Modules/Collage/model/collage_model.dart';
import 'package:Gixa/services/college_api_service.dart';
import 'package:get/get.dart';
// Replace these with your actual package paths

class CollegeSearchController extends GetxController {
  // Service Instance (Assuming you have a repository or static class)
  // If your searchColleges is a standalone function, just call it directly.
  
  // Observables for UI State
  var isLoading = false.obs;
  var colleges = <College>[].obs;

  // Filter Observables
  var searchText = ''.obs;
  var selectedInstituteType = RxnString(); // Nullable
  var selectedState = ''.obs;
  var selectedYear = ''.obs;
  var selectedQuota = ''.obs;
  var selectedRound = ''.obs;
  
  // Seat Range
  var minSeats = RxnInt();
  var maxSeats = RxnInt();

  // Debounce Timer
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    // Load initial data
    fetchColleges();
  }

  /// Triggered by Search Bar (with delay)
  void onSearchChanged(String val) {
    searchText.value = val;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchColleges();
    });
  }

  /// Main Fetch Function
  Future<void> fetchColleges() async {
    try {
      isLoading.value = true;
      
      // Clean up empty strings to null for the API
      String? clean(String? val) => (val == null || val.trim().isEmpty) ? null : val.trim();

      final result = await CollegeApiService.searchColleges(
        search: clean(searchText.value),
        instituteType: clean(selectedInstituteType.value),
        state: clean(selectedState.value),
        year: clean(selectedYear.value),
        quota: clean(selectedQuota.value),
        round: clean(selectedRound.value),
        minSeats: minSeats.value,
        maxSeats: maxSeats.value,
      );

      colleges.assignAll(result);
    } catch (e) {
      print("Error fetching colleges: $e");
      // Optionally show a snackbar here
      // Get.snackbar("Error", e.toString()); 
      colleges.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset all filters
  void clearFilters() {
    searchText.value = '';
    selectedInstituteType.value = null;
    selectedState.value = '';
    selectedYear.value = '';
    selectedQuota.value = '';
    selectedRound.value = '';
    minSeats.value = null;
    maxSeats.value = null;
    fetchColleges();
    Get.back(); // Close bottom sheet if open
  }
}