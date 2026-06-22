import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Gixa/Modules/Collage/model/collage_model.dart' hide StateModel;
import 'package:Gixa/commonmodels/course_model.dart';
import 'package:Gixa/commonmodels/state_model.dart' as master_models;
import 'package:Gixa/commonmodels/quata_model.dart';
import 'package:Gixa/services/college_api_service.dart';
import 'package:Gixa/services/register_master_api.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';

class CollegeSearchController extends GetxController {
  late final TextEditingController searchController;

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final colleges = <College>[].obs;
  final currentPage = 1.obs;
  final errorMessage = ''.obs;
  final backendCount = 0.obs;

  final searchText = ''.obs;
  final mccStatewiseCities = <String, List<String>>{}.obs;
  final selectedMccState = RxnString();

  final selectedCity = RxnString();
  final selectedCourseLevel = RxnString();
  final selectedCourse = RxnString();
  final selectedInstituteTypes = <String>[].obs;
  final selectedState = RxnString();
  final selectedYear = RxnString();
  final selectedQuota = RxnString();
  final selectedRound = RxnString();

  final minSeats = RxnInt();
  final maxSeats = RxnInt();

  final states = <master_models.StateModel>[].obs;
  final statewiseCities = <String, List<String>>{}.obs;
  final quotas = <QuotaModel>[].obs;
  final ugCourseOptions = <String>[].obs;
  final pgCourseOptions = <String>[].obs;

  final cityCtrl = TextEditingController();
  final minSeatsCtrl = TextEditingController();
  final maxSeatsCtrl = TextEditingController();

  //   RxList<StateModel> states = <StateModel>[].obs;
  // RxList<CourseModel> courses = <CourseModel>[].obs;

  // Rxn<StateModel> selectedFilterState = Rxn<StateModel>();
  // Rxn<CourseModel> selectedFilterCourse = Rxn<CourseModel>();

  Timer? _debounce;
  bool _hasQueuedReload = false;
  bool _queuedForceRefresh = false;

  int get activeFilterCount {
    int count = 0;
    if (selectedCity.value != null) count++;
    if (selectedCourseLevel.value != null) count++;
    if (selectedCourse.value != null) count++;
    if (selectedState.value != null) count++;
    if (selectedMccState.value != null) count++;
    if (selectedInstituteTypes.isNotEmpty) count++;
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
    loadMasters();
  }

  Future<void> loadMasters() async {
    try {
      final data = await RegisterMasterApi().fetchMasters();
      final stateList =
          data['states'] as List<master_models.StateModel>? ?? const [];
      states.assignAll(stateList);
      statewiseCities.assignAll(
        (data['statewise_cities'] as Map<String, List<String>>?) ??
            const <String, List<String>>{},
      );
      final mccSummary =
          data['mcc_statewise_city_summary'] as Map<String, dynamic>?;

      if (mccSummary != null) {
        final mccData = mccSummary['data'] as List<dynamic>? ?? [];

        final mapped = <String, List<String>>{};

        for (final item in mccData) {
          final state = item['state']?.toString().trim();

          final cities = (item['cities'] as List<dynamic>? ?? [])
              .map((e) => e.toString().trim())
              .where((e) => e.isNotEmpty)
              .toList();

          if (state != null && state.isNotEmpty) {
            mapped[state] = cities;
          }
        }

        mccStatewiseCities.assignAll(mapped);
      }
      final ugCourses =
          data['courses_for_ug'] as List<CourseModel>? ?? const [];
      ugCourseOptions.assignAll(
        _sortedUnique(ugCourses.map((course) => course.name)),
      );

      final coursesRaw = data['courses'] as Map<String, dynamic>? ?? {};
      final pgBuckets = (coursesRaw['PG'] as Map<String, dynamic>? ?? const {})
          .values
          .whereType<List<CourseModel>>();
      pgCourseOptions.assignAll(
        _sortedUnique(
          pgBuckets.expand((bucket) => bucket).map((course) => course.name),
        ),
      );
    } catch (e) {
      states.clear();
      statewiseCities.clear();
      ugCourseOptions.clear();
      pgCourseOptions.clear();
      debugPrint("Master API error: $e");
    }
  }

  /// Called by UI to update search text and trigger fetch with debounce
  void updateSearch(String value) {
    searchController.text = value;
    searchText.value = value;
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 400), () {
      fetchColleges();
    });
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

  String _normalize(String value) => value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  List<String> _sortedUnique(Iterable<String> values) {
    final unique = <String>{};
    for (final value in values) {
      final cleaned = value.trim();
      if (cleaned.isNotEmpty) {
        unique.add(cleaned);
      }
    }

    final result = unique.toList()..sort();
    return result;
  }

  String? _resolveCityStateKey(String? stateName) {
    final cleanedState = _clean(stateName);
    if (cleanedState == null) return null;

    for (final key in statewiseCities.keys) {
      if (_normalize(key) == _normalize(cleanedState)) {
        return key;
      }
    }

    return null;
  }

  List<String> get availableCityOptions {
    final isMcc = _normalize(selectedState.value ?? '') == 'mcc';

    if (isMcc) {
      return mccCities;
    }

    final stateKey = _resolveCityStateKey(selectedState.value);

    if (stateKey != null) {
      return List<String>.from(statewiseCities[stateKey] ?? const []);
    }

    return _sortedUnique(statewiseCities.values.expand((cities) => cities));
  }

  List<String> get mccStates {
    final list = mccStatewiseCities.keys.toList()..sort();
    return list;
  }

  List<String> get mccCities {
    final state = selectedMccState.value;

    if (state == null) return [];

    return mccStatewiseCities[state] ?? [];
  }

  void updateSelectedState(String? value) {
    selectedState.value = _clean(value);

    if (_normalize(value ?? '') != 'mcc') {
      selectedMccState.value = null;
    }

    final selectedCityValue = _clean(selectedCity.value);

    if (selectedCityValue != null &&
        !availableCityOptions.contains(selectedCityValue)) {
      selectedCity.value = null;
    }

    final draftCityValue = _clean(cityCtrl.text);

    if (draftCityValue != null &&
        !availableCityOptions.contains(draftCityValue)) {
      cityCtrl.clear();
    }
  }

  String? _buildSearchQuery() {
    return _clean(searchText.value);
  }

  Map<String, dynamic> _currentFilterSnapshot() {
    final filters = <String, dynamic>{};

    final searchQuery = _buildSearchQuery();
    if (searchQuery != null) filters['search'] = searchQuery;
    if (_clean(selectedState.value) != null) {
      filters['state'] = _clean(selectedState.value);
    }
    if (_clean(selectedMccState.value) != null) {
      filters['mcc_state'] = _clean(selectedMccState.value);
    }
    if (_clean(selectedCity.value) != null) {
      filters['city'] = _clean(selectedCity.value);
    }
    if (_clean(selectedCourseLevel.value) != null) {
      filters['course_level'] = _clean(selectedCourseLevel.value);
    }
    if (_clean(selectedCourse.value) != null) {
      filters['course'] = _clean(selectedCourse.value);
    }
    if (instituteTypeQuery != null) {
      filters['institute_types'] = instituteTypeQuery;
    }
    if (_clean(selectedYear.value) != null) {
      filters['year'] = _clean(selectedYear.value);
    }
    if (_clean(selectedQuota.value) != null) {
      filters['quota'] = _clean(selectedQuota.value);
    }
    if (_clean(selectedRound.value) != null) {
      filters['round'] = _clean(selectedRound.value);
    }
    if (minSeats.value != null) filters['min_seats'] = minSeats.value;
    if (maxSeats.value != null) filters['max_seats'] = maxSeats.value;

    return filters;
  }

  void _printFilterSnapshot(String context) {
    final filters = _currentFilterSnapshot();
    print('========== SEARCH FILTER DEBUG [$context] ==========');
    print('Active filter count: ${filters.length}');
    if (filters.isEmpty) {
      print('No filters are currently applied.');
    } else {
      filters.forEach((key, value) => print('$key: $value'));
    }
    print('===================================================');
  }

  void _printCollegeResults(
    String context,
    List<College> filteredColleges, {
    required int backendCount,
    required bool hasNextPage,
    required String pageLabel,
  }) {
    print('========== SEARCH RESULT DEBUG [$context] ==========');
    print('Page fetched: $pageLabel');
    print('Backend colleges count: $backendCount');
    print('Visible colleges after local filters: ${filteredColleges.length}');
    print('Has next page: $hasNextPage');

    if (filteredColleges.isEmpty) {
      print('No colleges matched the current filters.');
    } else {
      for (int i = 0; i < filteredColleges.length; i++) {
        final college = filteredColleges[i];
        print(
          '${i + 1}. ${college.name} | ${college.state.name} | ${college.instituteType.name} | code: ${college.collegeCode}',
        );
      }
    }

    print('===================================================');
  }

  // Always use paginated loading, never fetch all pages at once
  bool get _shouldForceRefreshActiveQuery =>
      _currentFilterSnapshot().isNotEmpty;

  void _queueLatestFetch({bool forceRefresh = false}) {
    _hasQueuedReload = true;
    _queuedForceRefresh =
        _queuedForceRefresh || forceRefresh || _shouldForceRefreshActiveQuery;
  }

  Future<void> _runQueuedFetchIfNeeded() async {
    if (isLoading.value || isLoadingMore.value || !_hasQueuedReload) {
      return;
    }

    final forceRefresh = _queuedForceRefresh;
    _hasQueuedReload = false;
    _queuedForceRefresh = false;
    await fetchColleges(forceRefresh: forceRefresh);
  }

  Future<List<College>> _fetchAllFilteredCollegePages({
    bool forceRefresh = false,
  }) async {
    final allColleges = <College>[];
    final seenIds = <int>{};
    var page = 1;

    while (true) {
      final result = await CollegeApiService.searchCollegesPaginated(
        search: _buildSearchQuery(),
        city: _clean(selectedCity.value),
        courseLevel: _clean(selectedCourseLevel.value),
        courseName: _clean(selectedCourse.value),
        instituteType: instituteTypeQuery,
        state: _clean(selectedState.value),
        mccState: _clean(selectedMccState.value),
        year: _clean(selectedYear.value),
        quota: _clean(selectedQuota.value),
        round: _clean(selectedRound.value),
        minSeats: minSeats.value,
        maxSeats: maxSeats.value,
        page: page,
        forceRefresh: forceRefresh,
      );

      for (final college in result.colleges) {
        if (seenIds.add(college.id)) {
          allColleges.add(college);
        }
      }

      if (!result.hasNextPage || result.colleges.isEmpty) {
        break;
      }

      page++;
    }

    return allColleges;
  }

  List<String> get availableCourseOptions {
    final level = selectedCourseLevel.value;
    if (level == 'UG') return ugCourseOptions;
    if (level == 'PG') return pgCourseOptions;
    return _sortedUnique([...ugCourseOptions, ...pgCourseOptions]);
  }

  void setCourseLevel(String? value) {
    selectedCourseLevel.value = value == 'UG' || value == 'PG' ? value : null;

    if (selectedCourse.value != null &&
        !availableCourseOptions.contains(selectedCourse.value)) {
      selectedCourse.value = null;
    }
  }

  void toggleInstituteType(String value) {
    final normalizedValue = _normalize(value);
    final existingIndex = selectedInstituteTypes.indexWhere(
      (item) => _normalize(item) == normalizedValue,
    );

    if (existingIndex >= 0) {
      selectedInstituteTypes.removeAt(existingIndex);
      return;
    }

    selectedInstituteTypes.add(value);
  }

  void removeInstituteType(String value) {
    selectedInstituteTypes.removeWhere(
      (item) => _normalize(item) == _normalize(value),
    );
  }

  String? get instituteTypeQuery {
    if (selectedInstituteTypes.isEmpty) return null;

    final values = selectedInstituteTypes
        .map(_mapInstituteTypeToApiValue)
        .whereType<String>()
        .toSet()
        .toList();

    if (values.isEmpty) return null;
    return values.join(',');
  }

  String? _mapInstituteTypeToApiValue(String? value) {
    final normalizedValue = _normalize(value ?? '');
    switch (normalizedValue) {
      case 'government':
        return 'government';
      case 'private':
        return 'private';
      case 'deemed':
        return 'deemed';
      default:
        return normalizedValue.isEmpty ? null : normalizedValue;
    }
  }

  bool _matchesSelectedCourse(College college) {
    final selected = _clean(selectedCourse.value);
    if (selected == null) return true;

    final normalizedSelected = _normalize(selected);
    final level = selectedCourseLevel.value;

    bool hasUgMatch() => college.courses.ug.any(
      (course) => _normalize(course.name).contains(normalizedSelected),
    );

    bool hasPgMatch() => college.courses.pg.any(
      (course) =>
          _normalize(course.courseName).contains(normalizedSelected) ||
          _normalize(course.specialtyName).contains(normalizedSelected),
    );

    if (level == 'UG') return hasUgMatch();
    if (level == 'PG') return hasPgMatch();
    return hasUgMatch() || hasPgMatch();
  }

  bool _matchesSelectedInstituteTypes(College college) {
    if (selectedInstituteTypes.isEmpty) return true;

    final normalizedType = _normalize(college.instituteType.name);
    if (normalizedType.isEmpty) return false;

    bool matchesGovernment() =>
        normalizedType.contains('government') ||
        normalizedType.contains('govt') ||
        normalizedType.contains('public');

    bool matchesDeemed() =>
        normalizedType.contains('deemed') || normalizedType.contains('deem');

    bool matchesPrivate() =>
        normalizedType.contains('private') ||
        normalizedType.contains('pvt') ||
        normalizedType.contains('self finance') ||
        normalizedType.contains('self financed') ||
        normalizedType.contains('self financing') ||
        normalizedType.contains('unaided') ||
        normalizedType.contains('minority') ||
        normalizedType.contains('trust') ||
        normalizedType.contains('society') ||
        (!matchesGovernment() && !matchesDeemed());

    for (final selectedType in selectedInstituteTypes.map(_normalize)) {
      switch (selectedType) {
        case 'government':
          if (matchesGovernment()) return true;
          break;
        case 'private':
          if (matchesPrivate()) return true;
          break;
        case 'deemed':
          if (matchesDeemed()) return true;
          break;
        default:
          if (normalizedType.contains(selectedType)) return true;
      }
    }

    return false;
  }

  void applyFilters({
    String? cityValue,
    String? stateValue,
    String? courseLevelValue,
    String? courseNameValue,
    List<String>? instituteTypeValues,
    int? minSeatsValue,
    int? maxSeatsValue,
  }) {
    selectedCity.value = _clean(cityValue);
    updateSelectedState(stateValue);
    cityCtrl.text = selectedCity.value ?? '';
    setCourseLevel(courseLevelValue);
    selectedCourse.value = _clean(courseNameValue);
    selectedInstituteTypes.assignAll(
      (instituteTypeValues ?? const <String>[])
          .map(_clean)
          .whereType<String>()
          .toSet(),
    );
    minSeats.value = minSeatsValue;
    maxSeats.value = maxSeatsValue;
    _printFilterSnapshot('applyFilters');
    fetchColleges();
  }

  // FETCH COLLEGES
  Future<void> fetchColleges({
    bool forceRefresh = false,
    bool loadMore = false,
  }) async {
    final requestForceRefresh =
        forceRefresh || (!loadMore && _shouldForceRefreshActiveQuery);

    // Always use paginated loading, never fetch all pages at once

    if (loadMore) {
      if (isLoading.value || isLoadingMore.value || !hasMore.value) return;
    } else {
      if (isLoading.value || isLoadingMore.value) {
        _queueLatestFetch(forceRefresh: requestForceRefresh);
        return;
      }
    }

    try {
      if (loadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        errorMessage.value = '';
        currentPage.value = 1;
        hasMore.value = true;
      }

      final pageToFetch = loadMore ? currentPage.value + 1 : 1;
      _printFilterSnapshot(
        loadMore ? 'fetchColleges.loadMore' : 'fetchColleges',
      );

      final result = await CollegeApiService.searchCollegesPaginated(
        search: _buildSearchQuery(),
        city: _clean(selectedCity.value),
        courseLevel: _clean(selectedCourseLevel.value),
        courseName: _clean(selectedCourse.value),
        instituteType: instituteTypeQuery,
        state: _clean(selectedState.value),
        mccState: _clean(selectedMccState.value),
        year: _clean(selectedYear.value),
        quota: _clean(selectedQuota.value),
        round: _clean(selectedRound.value),
        minSeats: minSeats.value,
        maxSeats: maxSeats.value,
        page: pageToFetch,
        forceRefresh: requestForceRefresh,
      );

      final filteredColleges = result.colleges
          .where(_matchesSelectedCourse)
          .where(_matchesSelectedInstituteTypes)
          .toList();

      // Update backend count (use server-provided `count` when available,
      // otherwise approximate from received page data and previous state).
      final previousTotal = colleges.length;
      final computedBackendCount =
          result.count ??
          (loadMore
              ? previousTotal + result.colleges.length
              : result.colleges.length);
      backendCount.value = computedBackendCount;

      _printCollegeResults(
        loadMore ? 'fetchColleges.loadMore' : 'fetchColleges',
        filteredColleges,
        backendCount: result.count ?? result.colleges.length,
        hasNextPage: result.hasNextPage,
        pageLabel: pageToFetch.toString(),
      );

      if (loadMore) {
        colleges.addAll(filteredColleges);
      } else {
        colleges.assignAll(filteredColleges);
      }

      currentPage.value = pageToFetch;
      hasMore.value = result.hasNextPage;
    } catch (e) {
      debugPrint("College fetch error: $e");
      if (!loadMore) {
        colleges.clear();
      }
      errorMessage.value = "Unable to fetch colleges";

      AppSnackbar.show(
        "Error",
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (loadMore) {
        isLoadingMore.value = false;
      } else {
        isLoading.value = false;
      }

      await _runQueuedFetchIfNeeded();
    }
  }

  Future<void> loadNextPage() async {
    await fetchColleges(loadMore: true);
  }

  Future<void> refreshList() async {
    await fetchColleges(forceRefresh: true);
  }

  // CLEAR FILTERS
  void clearFilters() {
    searchController.clear();
    cityCtrl.clear();

    selectedCity.value = null;
    selectedCourseLevel.value = null;
    selectedCourse.value = null;
    selectedInstituteTypes.clear();
    selectedState.value = null;
    selectedMccState.value = null;
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
    cityCtrl.dispose();
    minSeatsCtrl.dispose();
    maxSeatsCtrl.dispose();
    super.onClose();
  }
}
