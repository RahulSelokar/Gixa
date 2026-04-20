import 'dart:convert';

import 'package:Gixa/Modules/predication/model/state_category_model.dart';
import 'package:Gixa/Modules/subscription/features/feature_names.dart';
import 'package:Gixa/commonmodels/category_model.dart';
import 'package:Gixa/commonmodels/course_model.dart';
import 'package:Gixa/commonmodels/round_model.dart';
import 'package:Gixa/commonmodels/state_model.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/services/prediction_services.dart';
import 'package:Gixa/services/profile_services.dart';
import 'package:Gixa/services/register_master_api.dart';
import 'package:Gixa/services/state_category_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import '../model/predication_model.dart';
import '../view/ai_prediction_result_view.dart';

class PredictionController extends GetxController {
  /// Syncs PredictionController fields with ProfileController's latest profile
  void syncWithProfile(dynamic profileController) {
    final p = profileController.profile.value;
    if (p == null) return;
    userAir.value = p.allIndiaRank ?? 0;
    userMarks.value = p.neetScore ?? 0;
    selectedState.value = p.state ?? "";
    selectedCategory.value = p.category ?? "";
    selectedCourse.value = p.course ?? "";
    selectedGender.value = p.gender ?? "M";
    selectedQuota.value = p.quota ?? "";
    selectedInstituteType.value = p.instituteType ?? "Both";
    if (p.horizontals != null) {
      selectedHorizontals.assignAll(p.horizontals);
    } else {
      selectedHorizontals.clear();
    }
  }

  // Returns true if current state is Maharashtra
  bool get isMaharashtra =>
      selectedState.value.trim().toLowerCase() == 'maharashtra';

  // Returns horizontal categories for Reservation (excludes IQ for Maharashtra)

  // Returns horizontal categories for Reservation (excludes IQ/I.Q for Maharashtra)
  List<String> get reservationHorizontals {
    if (isMaharashtra) {
      return horizontalCategoryList
          .where((e) => e != 'IQ' && e != 'I.Q')
          .toList();
    }
    return horizontalCategoryList;
  }

  // Returns true if IQ or I.Q is available for Maharashtra
  bool get showIqQuotaTile =>
      isMaharashtra &&
      (horizontalCategoryList.contains('IQ') ||
          horizontalCategoryList.contains('I.Q'));

  // Returns the actual IQ label from backend for Maharashtra (IQ or I.Q)
  String get iqLabel => horizontalCategoryList.contains('I.Q') ? 'I.Q' : 'IQ';

  /// Returns the available quotas for the currently selected state
  List<String> get availableQuotasForSelectedState {
    final stateData = stateCategoryMap[selectedState.value];
    return stateData?.availableQuotas ?? [];
  }

  final SubscriptionController subscriptionController =
      Get.find<SubscriptionController>();

  bool get canAccessPrediction => subscriptionController.hasFeature(
    FeatureNames.selectedStateCollegePrediction,
  );

  /// =========================
  /// STORAGE
  /// =========================
  final box = GetStorage();

  /// =========================
  /// LOADING STATES
  /// =========================
  var isProfileLoading = false.obs;
  var isPredictionLoading = false.obs;
  var errorMessage = ''.obs;

  /// =========================
  /// PROFILE DATA
  /// =========================
  var userAir = 0.obs;
  var userMarks = 0.obs;

  /// =========================
  /// GENDER INPUT (MANUAL)
  /// =========================
  var selectedGender = "M".obs;

  final genderList = [
    {"label": "Male", "value": "M"},
    {"label": "Female", "value": "F"},
    {"label": "Other", "value": "Other"},
  ];

  // =========================
  // PREMIUM / FEATURE ACCESS
  // =========================

  /// Helper specifically for prediction (optional, can use canAccessPrediction directly)
  bool get isPredictionUnlocked {
    final unlocked = canAccessPrediction;
    print("🔥 Premium Access: $unlocked");
    return unlocked;
  }

  /// =========================
  /// USER INPUT
  /// =========================
  var selectedState = "".obs;
  var selectedCategory = "".obs;
  var selectedCourse = "".obs;

  var roundsList = <RoundModel>[].obs;
  var selectedRound = "".obs;
  var selectedRoundId = 0.obs;

  var selectedYear = RxnInt();
  // Default quota is empty; only set if user selects
  var selectedQuota = "".obs;
  // var selectedRound = "Round 1".obs;

  /// 🔥 Dynamic Statewise Categories
  var stateCategoryMap = <String, StateCategoryModel>{}.obs;
  var horizontalCategoryList = <String>[].obs;
  var selectedInstituteType = "Both".obs;

  // var selectedHorizontal = "".obs;
  var selectedHorizontals = <String>[].obs;

  var predictionData = Rxn<PredictionData>();
  var recentPredictions = <Map<String, dynamic>>[].obs;

  /// Master lists
  var stateList = <StateModel>[].obs;
  var categoryList = <CategoryModel>[].obs;
  var courseList = <CourseModel>[].obs;

  void _logPredictionRequest(Map<String, dynamic> requestBody) {
    final pretty = const JsonEncoder.withIndent('  ').convert(requestBody);
    print("========== PREDICTION REQUEST (OUTGOING) ==========");
    print(pretty);
    print("===================================================");

    //     {
    // I/flutter (29267):   "year": 2026,
    // I/flutter (29267):   "rank": 386506,
    // I/flutter (29267):   "marks": 0,
    // I/flutter (29267):   "course": "MBBS",
    // I/flutter (29267):   "state": "Maharashtra",
    // I/flutter (29267):   "category": "EWS",
    // I/flutter (29267):   "gender": "M",
    // I/flutter (29267):   "horizontal": "EWS",
    // I/flutter (29267):   "institute_type": "both",
    // I/flutter (29267):   "quota": "State Quota"
    // I/flutter (29267): }
  }

  String _getFormattedHorizontal() {
    return selectedHorizontals
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .join(" ");
  }

  String _getSelectedCombinationKey() {
    final stateData = stateCategoryMap[selectedState.value.trim()];
    final category = selectedCategory.value.trim();
    if (category.isEmpty) return "";

    final selectedHorizontalItems = selectedHorizontals
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // Do not send category as horizontal when user has not selected any
    // horizontal reservation.
    if (selectedHorizontalItems.isEmpty) return "";

    final orderedHorizontals = stateData == null
        ? selectedHorizontalItems
        : stateData.availableHorizontalCategories
              .where(selectedHorizontals.contains)
              .toList();

    final candidate = [category, ...orderedHorizontals].join("|");
    if (stateData?.availableCombinationKeys.contains(candidate) ?? false) {
      return candidate;
    }

    final normalizedSelected = {
      category,
      ...orderedHorizontals.map((e) => e.trim()).where((e) => e.isNotEmpty),
    };

    final matches =
        (stateData?.availableCombinationKeys ?? const <String>[]).where((key) {
            final parts = key
                .split("|")
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();

            if (parts.isEmpty || parts.first != category) return false;

            return normalizedSelected.every(parts.contains);
          }).toList()
          ..sort((a, b) => a.split("|").length.compareTo(b.split("|").length));

    return matches.isNotEmpty ? matches.first : candidate;
  }

  void handleHorizontalSelection(String label) {
    if (selectedHorizontals.contains(label)) {
      selectedHorizontals.remove(label);
    } else {
      selectedHorizontals.add(label);
    }

    // IQ selection should always behave as management quota.
    // if (label == "IQ") {
    //   if (selectedHorizontals.contains("IQ")) {
    //     selectedQuota.value = "IQ/Management";
    //   } else if (selectedQuota.value == "IQ/Management") {
    //     selectedQuota.value = "State Quota";
    //   }
    // }
  }

  String _getFormattedQuota() {
    // If user did not select quota (value is empty or only whitespace), send empty string
    if (selectedQuota.value.trim().isEmpty) {
      return "";
    }
    // If IQ is selected, send Management Quota
    // if (selectedHorizontals.contains("IQ")) {
    //   return "Management Quota";
    // }
    // Otherwise, send the selected quota value
    return selectedQuota.value.trim();
  }

  String _getFormattedInstituteType() {
    switch (selectedInstituteType.value) {
      case "Govt":
        return "govt";
      case "Pvt":
        return "private";
      case "Both":
        return "both";
      default:
        return "";
    }
  }

  Future<void> loadStatewiseCategories() async {
    try {
      // Optionally, you can use all states or a default list if needed
      // For now, use the states from the master list
      final stateNames = stateList.map((e) => e.name).toList();

      final data = await StateCategoryApiService.getStateCategories(
        states: stateNames,
      );

      // Update stateList to only those states returned by the API
      // StateCategoryModel from statewiseAvailability API does not provide id, so use 0 as a placeholder
      stateList.value = data
          .map((e) => StateModel(id: 0, name: e.state))
          .toList();

      for (var item in data) {
        stateCategoryMap[item.state] = item;
      }
      if (selectedState.value.isNotEmpty) {
        updateCategoriesByState(
          selectedState.value,
          preserveExistingCategory: true,
        );
      }
    } catch (e) {
      print("❌ Failed to load statewise categories: $e");
    }
  }

  void updateCategoriesByState(
    String state, {
    bool preserveExistingCategory = false,
  }) {
    final data = stateCategoryMap[state];
    if (data == null) return;

    final previousCategory = selectedCategory.value.trim();

    /// Update categories
    categoryList.value = data.availableCategories
        .asMap()
        .entries
        .map(
          (entry) =>
              CategoryModel(id: entry.key, name: entry.value, totalSeats: 0),
        )
        .toList();

    /// Update horizontal categories
    horizontalCategoryList.value = data.availableHorizontalCategories;

    /// Keep profile/user selected category when possible.
    if (preserveExistingCategory && previousCategory.isNotEmpty) {
      final exists = categoryList.any((e) => e.name == previousCategory);
      selectedCategory.value = exists
          ? previousCategory
          : (categoryList.isNotEmpty ? categoryList.first.name : "");
    } else {
      selectedCategory.value = categoryList.isNotEmpty
          ? categoryList.first.name
          : "";
    }

    selectedHorizontals.clear();
  }

  void onStateChanged(String state) {
    selectedState.value = state;
    updateCategoriesByState(state);
  }

  void loadRecentPredictions() {
    final List? recent = box.read("recent_predictions");
    recentPredictions.assignAll(
      (recent ?? []).whereType<Map<String, dynamic>>(),
    );
  }

  @override
  void onInit() {
    super.onInit();

    selectedYear.value = DateTime.now().year;
    loadRecentPredictions();

    _initializePredictionInputs();
  }

  Future<void> _initializePredictionInputs() async {
    await fetchUserProfile();
    await loadMasters();
    await loadStatewiseCategories();
  }

  // FETCH USER PROFILE
  Future<void> fetchUserProfile() async {
    try {
      isProfileLoading.value = true;
      errorMessage.value = '';

      final profile = await ProfileService.getProfile();

      userAir.value = profile.allIndiaRank ?? 0;
      userMarks.value = profile.neetScore ?? 0;
      // userGender.value = profile.gender ?? "";

      selectedState.value = profile.state ?? "";
      selectedCategory.value = profile.category ?? "";
      selectedCourse.value = profile.course ?? "";
    } catch (e) {
      errorMessage.value = "Failed to load profile";
      Get.snackbar("Error", "Unable to fetch profile");
    } finally {
      isProfileLoading.value = false;
    }
  }

  // =====================================================
  // VALIDATE INPUT
  // =====================================================
  bool _validateInputs() {
    if (userAir.value == 0) {
      Get.snackbar("Error", "AIR not found in profile");
      return false;
    }

    if (selectedState.value.trim().isEmpty ||
        selectedCategory.value.trim().isEmpty ||
        selectedCourse.value.trim().isEmpty ||
        selectedYear.value == null) {
      Get.snackbar("Error", "Please fill all required fields");
      return false;
    }

    return true;
  }

  // =====================================================
  // FETCH PREDICTION
  // =====================================================
  Future<void> fetchPrediction() async {
    final instituteType = _getFormattedInstituteType();

    if (!_validateInputs()) return;

    try {
      isPredictionLoading.value = true;
      errorMessage.value = '';

      /// 🔥 CLEAN REQUEST BODY (remove nulls)
      final combinationKey = _getSelectedCombinationKey();

      final requestBody = {
        "year": selectedYear.value,
        "rank": userAir.value,
        "marks": userMarks.value,
        "course": selectedCourse.value.trim(),
        "state": selectedState.value.trim(),
        "category": selectedCategory.value.trim(),
        "gender": selectedGender.value,
        // if (isPwd.value) "pwd": true,
        // if (isDefence.value) "defence": "DEFENCE",
        // if (isMinority.value) "minority": true,
        // if (isOrphan.value) "orphan": true,
        // if (isHillyArea.value) "hilly_area": true,
        "horizontal": combinationKey,

        if (_getFormattedInstituteType().isNotEmpty)
          "institute_type": _getFormattedInstituteType(),
        "quota": _getFormattedQuota(),
      };
      print("Selected Horizontals: $selectedHorizontals");
      print("Formatted Horizontal: ${_getFormattedHorizontal()}");
      print("Combination Key: $combinationKey");

      _logPredictionRequest(requestBody);

      final data = await PredictionService.fetchPrediction(requestBody);

      predictionData.value = data;

      if (data.message != null) {
        print('API Message: \\${data.message}');
      }

      box.write("last_prediction", requestBody);

      // Save recent predictions (keep only last 2)
      List recent = box.read("recent_predictions") ?? [];
      // Add new prediction to the start
      recent.insert(0, requestBody);
      // Remove duplicates (by year, rank, state, category, course, quota, etc.)
      final seen = <String>{};
      recent = recent.where((p) {
        final key =
            "${p['year']}_${p['rank']}_${p['state']}_${p['category']}_${p['course']}_${p['quota']}";
        if (seen.contains(key)) return false;
        seen.add(key);
        return true;
      }).toList();
      // Keep only the last 2
      if (recent.length > 2) recent = recent.sublist(0, 2);
      box.write("recent_predictions", recent);
      recentPredictions.assignAll(recent.whereType<Map<String, dynamic>>());

      /// Get recent predictions (returns List<Map>)

      /// 🔥 HANDLE PRIVATE FALLBACK
      // if (data.noChanceInHomeState) {
      //   Get.snackbar(
      //     "No Government College",
      //     "Showing Private College Suggestions",
      //     snackPosition: SnackPosition.BOTTOM,
      //   );
      // } else {
      //   Get.snackbar(
      //     "Success",
      //     "Government Colleges Found",
      //     snackPosition: SnackPosition.BOTTOM,
      //   );
      // }

      /// Navigate AFTER data is ready
      await Future.delayed(const Duration(seconds: 5));
      Get.to(() => AiPredictionResultView(predictionData: data));
    } catch (e) {
      print("❌ Prediction Error: $e");

      errorMessage.value = "Prediction failed";

      Get.snackbar(
        "Error",
        "Unable to fetch prediction",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isPredictionLoading.value = false;
    }
  }

  List<Map<String, dynamic>> getRecentPredictions() {
    return recentPredictions.toList();
  }

  Future<void> loadMasters() async {
    try {
      final data = await RegisterMasterApi().fetchMasters();

      /// existing
      stateList.value = data['states'];
      categoryList.value = data['categories'];
    } catch (e) {
      Get.snackbar("Error", "Failed to load master data");
    }
  }

  void goToPremium() {
    Get.toNamed(AppRoutes.subscription);
  }

  void setSelectedRound(String value) {
    final round = roundsList.firstWhere((e) => e.roundName == value);

    selectedRound.value = round.roundName;
    selectedRoundId.value = round.id; // 🔥 important
  }
}
