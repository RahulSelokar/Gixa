import 'package:get/get.dart';
import 'package:Gixa/Modules/Collage/model/collage_model.dart';
import 'package:Gixa/commonmodels/course_model.dart';
import 'package:Gixa/commonmodels/state_model.dart' as master_models;
import 'package:Gixa/services/college_api_service.dart';
import 'package:Gixa/services/register_master_api.dart';
import 'package:Gixa/network/app_exception.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';

class CollegeListController extends GetxController {
  final RegisterMasterApi _masterApi = RegisterMasterApi();

  /// UI STATES
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final colleges = <College>[].obs;
  final backendCount = 0.obs;
  final availableStates = <master_models.StateModel>[].obs;
  final statewiseCities = <String, List<String>>{}.obs;
  final mccStatewiseCities = <String, List<String>>{}.obs;

  final selectedMccState = RxnString();
  final errorMessage = ''.obs;
  final currentPage = 1.obs;

  /// FILTER VALUES
  String? search;
  String? city;
  String? state;
  String? courseLevel;
  String? courseName;
  String? customCourseName;
  final List<String> instituteTypes = [];
  String? year;
  String? quota;
  String? round;
  int? minSeats;
  int? maxSeats;
  final ugCourseOptions = <String>[].obs;
  final pgCourseOptions = <String>[].obs;
  bool _hasQueuedReload = false;
  bool _queuedForceRefresh = false;

  @override
  void onInit() {
    super.onInit();
    loadFilterStates();
    fetchColleges();
  }

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

  void resetFilters() {
    search = null;

    city = null;
    selectedMccState.value = null;

    state = null;

    courseLevel = null;

    courseName = null;

    customCourseName = null;

    instituteTypes.clear();

    year = null;

    quota = null;

    round = null;

    minSeats = null;

    maxSeats = null;

    colleges.clear();

    currentPage.value = 1;

    hasMore.value = true;

    errorMessage.value = '';

    fetchColleges(forceRefresh: true);
  }

  List<String> cityOptionsForState(String? stateValue) {
    final isMcc = _normalize(stateValue ?? '') == 'mcc';

    if (isMcc) {
      return mccCities;
    }

    final stateKey = _resolveCityStateKey(stateValue);

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

  void updateState(String? value) {
    state = _clean(value);

    if (_normalize(value ?? '') != 'mcc') {
      selectedMccState.value = null;
    }

    final selectedCity = _clean(city);

    if (selectedCity != null &&
        !cityOptionsForState(state).contains(selectedCity)) {
      city = null;
    }
  }

  List<String> get availableCourseOptions {
    if (courseLevel == 'UG') return ugCourseOptions;
    if (courseLevel == 'PG') return pgCourseOptions;
    return _sortedUnique([...ugCourseOptions, ...pgCourseOptions]);
  }

  String? get effectiveCourseName {
    if (courseName == 'Other') {
      return _clean(customCourseName);
    }
    return _clean(courseName);
  }

  List<String> get selectedInstituteTypes => List.unmodifiable(instituteTypes);

  String? get instituteTypeQuery {
    if (instituteTypes.isEmpty) return null;

    final values = instituteTypes
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

  String? _buildSearchQuery() {
    return _clean(search);
  }

  Map<String, dynamic> _currentFilterSnapshot() {
    final filters = <String, dynamic>{};

    final searchQuery = _buildSearchQuery();
    if (searchQuery != null) filters['search'] = searchQuery;
    if (_clean(state) != null) filters['state'] = _clean(state);
    if (_clean(selectedMccState.value) != null) {
      filters['mcc_state'] = _clean(selectedMccState.value);
    }
    if (_clean(city) != null) filters['city'] = _clean(city);
    if (_clean(courseLevel) != null) {
      filters['course_level'] = _clean(courseLevel);
    }
    if (effectiveCourseName != null) filters['course'] = effectiveCourseName;
    if (instituteTypeQuery != null) {
      filters['institute_types'] = instituteTypeQuery;
    }
    if (_clean(year) != null) filters['year'] = _clean(year);
    if (_clean(quota) != null) filters['quota'] = _clean(quota);
    if (_clean(round) != null) filters['round'] = _clean(round);
    if (minSeats != null) filters['min_seats'] = minSeats;
    if (maxSeats != null) filters['max_seats'] = maxSeats;

    return filters;
  }

  void _printFilterSnapshot(String context) {
    final filters = _currentFilterSnapshot();
    print('========== COLLEGE LIST FILTER DEBUG [$context] ==========');
    print('Active filter count: ${filters.length}');
    if (filters.isEmpty) {
      print('No filters are currently applied.');
    } else {
      filters.forEach((key, value) => print('$key: $value'));
    }
    print('=========================================================');
  }

  void _printCollegeResults(
    String context,
    List<College> filteredColleges, {
    required int backendCount,
    required bool hasNextPage,
    required String pageLabel,
  }) {
    print('========== COLLEGE LIST RESULT DEBUG [$context] ==========');
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

    print('=========================================================');
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
        city: city,
        state: state,
        mccState: selectedMccState.value,
        courseLevel: courseLevel,
        courseName: effectiveCourseName,
        instituteType: instituteTypeQuery,
        year: year,
        quota: quota,
        round: round,
        minSeats: minSeats,
        maxSeats: maxSeats,
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

  bool _matchesSelectedCourse(College college) {
    final selectedCourse = effectiveCourseName;
    if (selectedCourse == null) return true;

    final query = _normalize(selectedCourse);

    bool ugMatches() => college.courses.ug.any(
      (course) => _normalize(course.name).contains(query),
    );

    bool pgMatches() => college.courses.pg.any(
      (course) =>
          _normalize(course.courseName).contains(query) ||
          _normalize(course.specialtyName).contains(query),
    );

    if (courseLevel == 'UG') return ugMatches();
    if (courseLevel == 'PG') return pgMatches();
    return ugMatches() || pgMatches();
  }

  bool _matchesSelectedInstituteTypes(College college) {
    if (instituteTypes.isEmpty) return true;

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

    for (final selectedType in instituteTypes.map(_normalize)) {
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

  /// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  /// ðŸ“š FETCH COLLEGES (WITH FILTERS)
  /// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
        city: city,
        state: state,
        mccState: selectedMccState.value,
        courseLevel: courseLevel,
        courseName: effectiveCourseName,
        instituteType: instituteTypeQuery,
        year: year,
        quota: quota,
        round: round,
        minSeats: minSeats,
        maxSeats: maxSeats,
        page: pageToFetch,
        forceRefresh: requestForceRefresh,
      );

      final filteredColleges = result.colleges
          .where(_matchesSelectedCourse)
          .where(_matchesSelectedInstituteTypes)
          .toList();

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
      if (e is AppException) {
        errorMessage.value = e.message;
        AppSnackbar.show('Error', e.message);
      } else {
        errorMessage.value = 'Something went wrong';
        AppSnackbar.show('Error', errorMessage.value);
      }
    } finally {
      if (loadMore) {
        isLoadingMore.value = false;
      } else {
        isLoading.value = false;
      }

      await _runQueuedFetchIfNeeded();
    }
  }

  /// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  /// ðŸ” APPLY FILTERS
  /// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void applyFilters({
    String? searchValue,
    String? cityValue,
    String? stateValue,
    String? courseLevelValue,
    String? courseNameValue,
    String? customCourseNameValue,
    List<String>? instituteTypeValues,
    String? yearValue,
    String? quotaValue,
    String? roundValue,
    int? minSeatsValue,
    int? maxSeatsValue,
  }) {
    search = searchValue ?? search;
    city = _clean(cityValue);
    updateState(stateValue);
    courseLevel = courseLevelValue == 'UG' ? 'UG' : null;
    courseName = _clean(courseNameValue);
    customCourseName = _clean(customCourseNameValue);
    instituteTypes
      ..clear()
      ..addAll(
        (instituteTypeValues ?? const <String>[])
            .map(_clean)
            .whereType<String>()
            .toSet(),
      );
    year = yearValue;
    quota = quotaValue;
    round = roundValue;
    minSeats = minSeatsValue;
    maxSeats = maxSeatsValue;

    _printFilterSnapshot('applyFilters');
    colleges.clear();
    fetchColleges(forceRefresh: true);
  }

  void updateSearch(String value) {
    search = _clean(value);
    fetchColleges();
  }

  Future<void> loadNextPage() async {
    await fetchColleges(loadMore: true);
  }

  void clearFilters() {
    city = null;
    state = null;
    courseLevel = null;
    courseName = null;
    customCourseName = null;
    instituteTypes.clear();
    year = null;
    quota = null;
    round = null;
    minSeats = null;
    maxSeats = null;
    selectedMccState.value = null;

    fetchColleges();
  }

  Future<void> refreshList() async {
    resetFilters();

    await fetchColleges(forceRefresh: true);
  }

  Future<void> loadFilterStates({bool forceRefresh = false}) async {
    try {
      final data = await _masterApi.fetchMasters(
        showGlobalNetworkError: false,
        forceRefresh: forceRefresh,
      );
      availableStates.assignAll(
        (data['states'] as List<master_models.StateModel>? ?? const []),
      );
      statewiseCities.assignAll(
        (data['statewise_cities'] as Map<String, List<String>>?) ??
            const <String, List<String>>{},
      );
      final rawMccSummary = data['mcc_statewise_city_summary'];

      final mapped = <String, List<String>>{};

      List<dynamic> mccData = [];

      if (rawMccSummary is Map<String, dynamic>) {
        mccData = rawMccSummary['data'] as List<dynamic>? ?? [];
      } else if (rawMccSummary is List) {
        mccData = rawMccSummary;
      }

      for (final item in mccData) {
        if (item is Map<String, dynamic>) {
          final state = item['state']?.toString().trim();

          final cities = (item['cities'] as List<dynamic>? ?? [])
              .map((e) => e.toString().trim())
              .where((e) => e.isNotEmpty)
              .toList();

          if (state != null && state.isNotEmpty) {
            mapped[state] = cities;
          }
        }
      }

      mccStatewiseCities.assignAll(mapped);
      final ugCourses =
          data['courses_for_ug'] as List<CourseModel>? ?? const [];
      ugCourseOptions.assignAll(
        _sortedUnique(ugCourses.map((course) => course.name)),
      );

      final courses = data['courses'] as Map<String, dynamic>? ?? const {};
      final pgBuckets = (courses['PG'] as Map<String, dynamic>? ?? const {})
          .values
          .whereType<List<CourseModel>>();
      pgCourseOptions.assignAll(
        _sortedUnique(
          pgBuckets.expand((bucket) => bucket).map((course) => course.name),
        ),
      );
    } catch (_) {
      availableStates.clear();
      statewiseCities.clear();
      ugCourseOptions.clear();
      pgCourseOptions.clear();
      mccStatewiseCities.clear();
    }
  }
}
