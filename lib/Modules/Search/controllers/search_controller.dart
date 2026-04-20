import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Gixa/Modules/Collage/model/collage_model.dart';
import 'package:Gixa/commonmodels/state_model.dart' hide StateModel;
import 'package:Gixa/commonmodels/quata_model.dart';
import 'package:Gixa/services/college_api_service.dart';
import 'package:Gixa/services/register_master_api.dart';

class CollegeSearchController extends GetxController {
  late final TextEditingController searchController;

  final isLoading = false.obs;
  final colleges = <College>[].obs;

  final searchText = ''.obs;

  final selectedInstituteType = RxnString();
  final selectedState = RxnString();
  final selectedYear = RxnString();
  final selectedQuota = RxnString();
  final selectedRound = RxnString();

  final minSeats = RxnInt();
  final maxSeats = RxnInt();

  final states = <StateModel>[].obs;
  final quotas = <QuotaModel>[].obs;

  final minSeatsCtrl = TextEditingController();
  final maxSeatsCtrl = TextEditingController();

  Timer? _debounce;

  int get activeFilterCount {
    int count = 0;
    if (selectedState.value != null) count++;
    if (selectedInstituteType.value != null) count++;
    if (selectedYear.value != null) count++;
    if (selectedQuota.value != null) count++;
    if (selectedRound.value != null) count++;
    if (minSeats.value != null) count++;
    if (maxSeats.value != null) count++;
    return count;
  }

  @override
  void onInit() {
    super.onInit();

    searchController = TextEditingController();
    searchController.addListener(_onSearchTextChanged);

    fetchColleges();
    _loadMasters();
  }

  Future<void> _loadMasters() async {
    try {
      final data = await RegisterMasterApi().fetchMasters();
      states.assignAll(data['states'] as List<StateModel>);
      quotas.assignAll(data['quotas'] as List<QuotaModel>);
    } catch (_) {}
  }

  // SEARCH LISTENER
  void _onSearchTextChanged() {
    searchText.value = searchController.text;

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      fetchColleges();
    });
  }

  // CLEAN HELPER
  String? _clean(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  // FETCH COLLEGES
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
        "Unable to fetch colleges",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // CLEAR FILTERS
  void clearFilters() {
    searchController.clear();

    selectedInstituteType.value = null;
    selectedState.value = null;
    selectedYear.value = null;
    selectedQuota.value = null;
    selectedRound.value = null;

    minSeats.value = null;
    maxSeats.value = null;
    minSeatsCtrl.clear();
    maxSeatsCtrl.clear();

    fetchColleges();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
