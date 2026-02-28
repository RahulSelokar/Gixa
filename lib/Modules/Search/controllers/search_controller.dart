import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Gixa/Modules/Collage/model/collage_model.dart';
import 'package:Gixa/services/college_api_service.dart';

class CollegeSearchController extends GetxController {
 
  late final TextEditingController searchController;
  final isLoading = false.obs;
  final colleges = <College>[].obs;
  final searchText = ''.obs;
  final selectedInstituteType = RxnString();
  final selectedState = ''.obs;
  final selectedYear = ''.obs;
  final selectedQuota = ''.obs;
  final selectedRound = ''.obs;
  final minSeats = RxnInt();
  final maxSeats = RxnInt();
  Timer? _debounce;
  @override
  void onInit() {
    super.onInit();

    searchController = TextEditingController();

    /// Listen to search input
    searchController.addListener(_onSearchTextChanged);

    /// Initial load
    fetchColleges();
  }

  // ==========================================================
  // SEARCH LISTENER
  // ==========================================================
  void _onSearchTextChanged() {
    searchText.value = searchController.text;

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      fetchColleges();
    });
  }

  // ==========================================================
  // CLEAN STRING HELPER
  // ==========================================================
  String? _clean(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  
  Future<void> fetchColleges() async {
    try {
      isLoading.value = true;

      final result = await CollegeApiService.searchColleges(
        search: _clean(searchText.value),
        instituteType: _clean(selectedInstituteType.value),
        state: _clean(selectedState.value),
        year: _clean(selectedYear.value),
        quota: _clean(selectedQuota.value),
        round: _clean(selectedRound.value),
        minSeats: minSeats.value,
        maxSeats: maxSeats.value,
      );

      colleges.assignAll(result);
    } catch (e) {
      debugPrint("College fetch error: $e");
      colleges.clear();

      Get.snackbar(
        "Error",
        "Unable to fetch colleges. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  
  void clearFilters() {
    searchController.clear();

    selectedInstituteType.value = null;
    selectedState.value = '';
    selectedYear.value = '';
    selectedQuota.value = '';
    selectedRound.value = '';
    minSeats.value = null;
    maxSeats.value = null;

    fetchColleges();

    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================
  @override
  void onClose() {
    _debounce?.cancel();
    searchController.removeListener(_onSearchTextChanged);
    searchController.dispose();
    super.onClose();
  }
}