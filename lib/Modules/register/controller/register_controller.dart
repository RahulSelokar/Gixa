import 'package:Gixa/Modules/Auth/controllers/otp_controller.dart';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/rank_predication/model/neet_rank_model.dart';
import 'package:Gixa/Modules/register/model/register_request.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';
import 'package:Gixa/commonmodels/category_model.dart';
import 'package:Gixa/commonmodels/course_model.dart';
import 'package:Gixa/commonmodels/horizontal_categories_model.dart';
import 'package:Gixa/commonmodels/specialty_model.dart';
import 'package:Gixa/commonmodels/state_model.dart';
import 'package:Gixa/network/app_exception.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/routes/app_start_controller.dart';
import 'package:Gixa/naivgation/controller/nav_bar_controller.dart';
import 'package:Gixa/services/rank_predict_services.dart';
import 'package:Gixa/services/register_master_api.dart';
import 'package:Gixa/services/register_services.dart';
import 'package:Gixa/services/token_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum CourseLevel { ug, pg }

enum CourseType { clinical, nonClinical, paraClinical }

class RegisterController extends GetxController {
  final isLoading = false.obs;
  final RegisterApiService _service = RegisterApiService();

  final isMasterLoading = false.obs;
  final RegisterMasterApi _masterApi = RegisterMasterApi();

  final states = <StateModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final masterCategories = <CategoryModel>[].obs;
  final stateCategoryMap = <String, List<String>>{}.obs;

  /// HORIZONTAL RESERVATIONS
  final horizontalReservations = <HorizontalReservationModel>[].obs;

  final selectedHorizontalCategories = <String, bool>{}.obs;

  final stateHorizontalCategoryMap =
      <String, List<HorizontalReservationModel>>{}.obs;

  final neetScoreCtrl = TextEditingController();
  final airRankCtrl = TextEditingController();
  final isPredictingRank = false.obs;
  int _rankRequestId = 0;
  int _airPredictionRevision = 0;
  final isAirPredictionActive = false.obs;
  final showAirPredictionNotice = false.obs;
  bool _isApplyingPredictedAir = false;

  final ugCourses = <String, List<CourseModel>>{}.obs;
  final pgCourses = <String, List<CourseModel>>{}.obs;
  final ugCourseList = <CourseModel>[].obs;
  final availableCourses = <CourseModel>[].obs;

  final selectedState = Rx<StateModel?>(null);
  final selectedCategory = Rx<CategoryModel?>(null);
  final selectedGender = RxnString();
  final selectedCourseLevel = Rx<CourseLevel?>(null);
  final selectedCourseType = Rx<CourseType?>(null);
  final selectedCourse = Rx<CourseModel?>(null);
  final selectedSpecialty = Rx<SpecialtyModel?>(null);

  @override
  void onInit() {
    super.onInit();
    airRankCtrl.addListener(_handleAirRankChanged);
    loadMasters();
  }

  @override
  void onClose() {
    airRankCtrl.removeListener(_handleAirRankChanged);
    neetScoreCtrl.dispose();
    airRankCtrl.dispose();
    super.onClose();
  }

  void _handleAirRankChanged() {
    if (_isApplyingPredictedAir) {
      return;
    }

    _airPredictionRevision++;

    if (isAirPredictionActive.value || showAirPredictionNotice.value) {
      _clearAirPredictionState();
    }
  }

  void _clearAirPredictionState() {
    isAirPredictionActive.value = false;
    showAirPredictionNotice.value = false;
  }

  Future<void> _predictRankForScore(int score) async {
    final requestId = ++_rankRequestId;
    final revisionAtRequestStart = _airPredictionRevision;
    isPredictingRank.value = true;

    try {
      final response = await NeetRankService.getRank(score);
      final model = NeetRankResponse.fromJson(response);

      if (requestId != _rankRequestId) return;
      if (revisionAtRequestStart != _airPredictionRevision) return;
      if (neetScoreCtrl.text.trim() != score.toString()) return;

      final predictedAir = model.data.predictedAir;
      if (predictedAir > 0) {
        _isApplyingPredictedAir = true;
        try {
          airRankCtrl.text = predictedAir.toString();
          isAirPredictionActive.value = true;
          showAirPredictionNotice.value = true;
        } finally {
          _isApplyingPredictedAir = false;
        }
      } else {
        _clearAirPredictionState();
      }
    } catch (_) {
      if (requestId != _rankRequestId) return;
      if (revisionAtRequestStart != _airPredictionRevision) return;
      if (neetScoreCtrl.text.trim() != score.toString()) return;
      _clearAirPredictionState();
    } finally {
      if (requestId == _rankRequestId) {
        isPredictingRank.value = false;
      }
    }
  }

  Future<void> predictRank() async {
    final rawScore = neetScoreCtrl.text.trim();

    if (rawScore.isEmpty) {
      AppSnackbar.show(
        "Validation",
        "Please enter your NEET score",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final score = int.tryParse(rawScore);

    if (score == null || score < 0 || score > 720) {
      AppSnackbar.show(
        "Validation",
        "Enter valid NEET score (0-720)",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    await _predictRankForScore(score);
  }

  Future<void> loadMasters() async {
    try {
      isMasterLoading.value = true;

      final data = await _masterApi.fetchMasters();
      print("📦 FULL MASTER API RESPONSE:");
      print(data);
      print("\n📍 STATES FROM BACKEND:");
      for (var s in data['states']) {
        print("➡️ ${s.name} (ID: ${s.id})");
      }

      print("\n📊 STATEWISE CATEGORY RAW:");
      print(data['statewise_categories']);

      states.assignAll(data['states'] ?? []);
      masterCategories.assignAll(data['categories'] ?? []);

      ugCourses.assignAll(
        Map<String, List<CourseModel>>.from(data['courses']?['UG'] ?? {}),
      );

      pgCourses.assignAll(
        Map<String, List<CourseModel>>.from(data['courses']?['PG'] ?? {}),
      );

      ugCourseList.assignAll(data['courses_for_ug'] ?? <CourseModel>[]);
      _refreshAvailableCourses();

      print("\n🔥 STATE → CATEGORIES MAPPING:");

      final statewise = data['statewise_categories']?['data'] ?? [];

      stateCategoryMap.clear();

      for (final item in statewise) {
        final stateName = (item['state'] ?? '').toString().trim();

        final categories = (item['available_categories'] as List? ?? [])
            .map((e) => (e['category_name'] ?? '').toString().trim())
            .where((name) => name.isNotEmpty)
            .toList();

        if (stateName.isNotEmpty && categories.isNotEmpty) {
          stateCategoryMap[stateName] = categories;
        }
      }

      print("✅ State Category Map: $stateCategoryMap");

      /// HORIZONTAL RESERVATIONS
      final horizontalData =
          data['statewise_horizontal_categories']?['data'] ?? [];

      stateHorizontalCategoryMap.clear();

      for (final item in horizontalData) {
        final stateName = (item['state'] ?? '').toString().trim();

        final reservations =
            (item['available_horizontal_categories'] as List? ?? [])
                .map((e) => HorizontalReservationModel.fromJson(e))
                .toList();

        if (stateName.isNotEmpty) {
          stateHorizontalCategoryMap[stateName] = reservations;
        }
      }

      print(
        "✅ State Horizontal Reservation Map: "
        "$stateHorizontalCategoryMap",
      );
    } catch (e) {
      print('❌ Register masters load error: $e');
      AppSnackbar.show('Error', 'Failed to load dropdown data');
    } finally {
      isMasterLoading.value = false;
    }
  }

  void updateHorizontalReservationsByState(StateModel state) {
    List<HorizontalReservationModel>? items;

    for (final e in stateHorizontalCategoryMap.entries) {
      if (e.key.toLowerCase() == state.name.toLowerCase()) {
        items = e.value;
        break;
      }
    }

    horizontalReservations.assignAll(items ?? []);

    /// RESET PREVIOUS SELECTIONS
    selectedHorizontalCategories.clear();
  }

  void toggleHorizontalCategory(String code, bool value) {
    final selectedCount = selectedHorizontalCategories.values
        .where((e) => e == true)
        .length;

    /// LIMIT = 2
    if (value &&
        selectedHorizontalCategories[code] != true &&
        selectedCount >= 2) {
      AppSnackbar.show(
        "Selection Limit Reached",
        "You can select up to two applicable reservation categories only.",
        snackPosition: SnackPosition.TOP,
      );

      return;
    }

    selectedHorizontalCategories[code] = value;
  }

  void updateCategoriesByState(StateModel state) {
    selectedState.value = state;

    MapEntry<String, List<String>>? entry;

    for (final e in stateCategoryMap.entries) {
      if (e.key.toLowerCase() == state.name.toLowerCase()) {
        entry = e;
        break;
      }
    }

    final availableCategoryNames = entry?.value;

    if (availableCategoryNames == null || availableCategoryNames.isEmpty) {
      categories.clear();
      selectedCategory.value = null;
      selectedHorizontalCategories.clear();
      return;
    }

    final masterMap = {
      for (final cat in masterCategories) _normalizeCategoryName(cat.name): cat,
    };

    final filtered = availableCategoryNames
        .map((name) => masterMap[_normalizeCategoryName(name)])
        .whereType<CategoryModel>()
        .toList();

    categories.assignAll(filtered);
    selectedCategory.value = categories.isNotEmpty ? categories.first : null;
  }

  List<String> get selectedHorizontalReservationCodes {
    return selectedHorizontalCategories.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
  }

  bool get isHorizontalReservationValid {
    return selectedHorizontalReservationCodes.length <= 2;
  }

  List<CourseModel> get _ugCoursesForSelection {
    if (ugCourseList.isNotEmpty) {
      return ugCourseList;
    }

    final merged = <CourseModel>[];
    final seenIds = <int>{};

    for (final bucket in ugCourses.values) {
      for (final course in bucket) {
        if (seenIds.add(course.id)) {
          merged.add(course);
        }
      }
    }

    return merged;
  }

  List<CourseModel> get coursesByType {
    final key = switch (selectedCourseType.value) {
      CourseType.clinical => 'clinical',
      CourseType.nonClinical => 'non_clinical',
      CourseType.paraClinical => 'para_clinical',
      _ => null,
    };

    if (key == null) return [];
    return _currentLevelCourses[key] ?? [];
  }

  Map<String, List<CourseModel>> get _currentLevelCourses {
    if (selectedCourseLevel.value == CourseLevel.pg) {
      return pgCourses;
    }
    return {};
  }

  void onCourseLevelSelected(CourseLevel level) {
    if (selectedCourseLevel.value == level) return;

    selectedCourseLevel.value = level;
    selectedCourseType.value = null;
    selectedCourse.value = null;
    selectedSpecialty.value = null;
    _refreshAvailableCourses();
  }

  void onCourseTypeSelected(CourseType type) {
    if (selectedCourseType.value == type) return;

    selectedCourseType.value = type;
    selectedCourse.value = null;
    selectedSpecialty.value = null;
    _refreshAvailableCourses();
  }

  void onCourseSelected(CourseModel course) {
    selectedCourse.value = course;
    selectedSpecialty.value = null;
  }

  void _refreshAvailableCourses() {
    if (selectedCourseLevel.value == CourseLevel.ug) {
      availableCourses.assignAll(_ugCoursesForSelection);
      return;
    }

    if (selectedCourseLevel.value == CourseLevel.pg) {
      availableCourses.assignAll(coursesByType);
      return;
    }

    availableCourses.clear();
  }

  bool get shouldShowSpecialty => selectedCourseLevel.value == CourseLevel.pg;

  bool get shouldShowCourseType => selectedCourseLevel.value == CourseLevel.pg;

  bool get isDropdownValid =>
      selectedState.value != null &&
      selectedCategory.value != null &&
      selectedCourseLevel.value != null &&
      (!shouldShowCourseType || selectedCourseType.value != null) &&
      selectedCourse.value != null &&
      (!shouldShowSpecialty || selectedSpecialty.value != null);

  String _normalizeCategoryName(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  Future<void> register(RegisterStudentRequest request) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final data = await _service.registerStudent(request);

      await TokenService.saveTokens(
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
      );

      final appStart = Get.find<AppStartController>();
      await appStart.registrationCompleted();

      final navController = Get.isRegistered<MainNavController>()
          ? Get.find<MainNavController>()
          : Get.put(MainNavController(), permanent: true);
      navController.requestSubscriptionPopup();

      if (Get.isRegistered<OtpController>()) {
        Get.find<OtpController>().isLoggedIn.value = true;
      }

      AppSnackbar.show(
        'Success',
        'Registration completed successfully',
        snackPosition: SnackPosition.TOP,
      );

      Future.delayed(const Duration(milliseconds: 700), () async {
        Get.offAllNamed(AppRoutes.mainNav);

        Future.microtask(() async {
          try {
            final profileController = Get.find<ProfileController>();

            await profileController.fetchProfile();
          } catch (_) {}
        });
      });
    } catch (e) {
      if (e is AppException) {
        AppSnackbar.show('Failed', e.message);
      } else {
        AppSnackbar.show('Error', e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }
}
