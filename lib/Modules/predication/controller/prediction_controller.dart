// import 'package:Gixa/services/prediction_services.dart';
// import 'package:Gixa/services/profile_services.dart';
// import 'package:get/get.dart';
// import '../model/predication_model.dart';

// class PredictionController extends GetxController {

//   /// =========================
//   /// 🔹 LOADING STATES
//   /// =========================
//   var isProfileLoading = false.obs;
//   var isPredictionLoading = false.obs;
//   var hasResult = false.obs;

//   var errorMessage = ''.obs;

//   /// =========================
//   /// 🔹 PROFILE DATA (Readonly)
//   /// =========================
//   var userAir = 0.obs;

//   /// =========================
//   /// 🔹 USER INPUT (Manual)
//   /// =========================
//   var selectedState = "".obs;
//   var selectedCategory = "".obs;
//   var selectedCourse = "".obs;
//   var selectedYear = RxnInt();
//   var selectedQuota = "".obs;
//   var selectedRound = "".obs;

//   /// =========================
//   /// 🔹 Prediction Data
//   /// =========================
//   var predictionData = Rxn<PredictionData>();

//   @override
//   void onInit() {
//     super.onInit();
//     fetchUserProfile();
//   }

//   // =====================================================
//   // 🔹 FETCH USER PROFILE (ONLY AIR)
//   // =====================================================
//   Future<void> fetchUserProfile() async {
//     try {
//       isProfileLoading.value = true;
//       errorMessage.value = '';

//       final profile = await ProfileService.getProfile();
//       userAir.value = profile.allIndiaRank ?? 0;

//     } catch (e) {
//       errorMessage.value = "Failed to load profile";
//       Get.snackbar("Error", "Unable to fetch profile");
//     } finally {
//       isProfileLoading.value = false;
//     }
//   }

//   // =====================================================
//   // 🔹 VALIDATE INPUT
//   // =====================================================
//   bool _validateInputs() {
//     if (selectedState.value.isEmpty ||
//         selectedCategory.value.isEmpty ||
//         selectedCourse.value.isEmpty ||
//         selectedYear.value == null ||
//         selectedQuota.value.isEmpty ||
//         selectedRound.value.isEmpty) {

//       Get.snackbar("Error", "Please fill all required fields");
//       return false;
//     }

//     if (userAir.value == 0) {
//       Get.snackbar("Error", "AIR not found in profile");
//       return false;
//     }

//     return true;
//   }

//   // =====================================================
//   // 🔹 FETCH PREDICTION
//   // =====================================================
//   Future<void> fetchPrediction() async {

//     if (!_validateInputs()) return;

//     try {
//       isPredictionLoading.value = true;
//       errorMessage.value = '';
//       hasResult.value = false;

//       final data = await PredictionService.fetchPrediction(
//         allIndiaRank: userAir.value,
//         category: selectedCategory.value,
//         course: selectedCourse.value,
//         year: selectedYear.value!,
//         state: selectedState.value,
//         quota: selectedQuota.value,
//         counsellingRound: selectedRound.value,
//       );

//       predictionData.value = data;

//       hasResult.value = true;

//     } catch (e) {
//       errorMessage.value = "Prediction failed";
//       Get.snackbar("Error", "Prediction API failed");
//     } finally {
//       isPredictionLoading.value = false;
//     }
//   }

//   // =====================================================
//   // 🔹 RESET FORM (For Edit Button)
//   // =====================================================
//   void resetPrediction() {
//     hasResult.value = false;
//     predictionData.value = null;
//   }

//   // =====================================================
//   // 🔹 RESULT GETTERS
//   // =====================================================
//   List<CollegeModel> get safe =>
//       predictionData.value?.safeColleges ?? [];

//   List<CollegeModel> get moderate =>
//       predictionData.value?.moderateColleges ?? [];

//   List<CollegeModel> get ambitious =>
//       predictionData.value?.ambitiousColleges ?? [];

//   List<CollegeModel> get noCutoff =>
//       predictionData.value?.noCutoffColleges ?? [];
// }



import 'package:Gixa/services/prediction_services.dart';
import 'package:Gixa/services/profile_services.dart';
import 'package:get/get.dart';
import '../model/predication_model.dart';
import '../view/ai_prediction_result_view.dart';

class PredictionController extends GetxController {

  /// =========================
  /// 🔹 LOADING STATES
  /// =========================
  var isProfileLoading = false.obs;
  var isPredictionLoading = false.obs;
  var errorMessage = ''.obs;

  /// =========================
  /// 🔹 PROFILE DATA (AIR - Readonly)
  /// =========================
  var userAir = 0.obs;

  /// =========================
  /// 🔹 USER MANUAL INPUT
  /// =========================
  var selectedState = "".obs;
  var selectedCategory = "".obs;
  var selectedCourse = "".obs;
  var selectedYear = RxnInt();
  var selectedQuota = "".obs;
  var selectedRound = "".obs;

  /// =========================
  /// 🔹 Prediction Data
  /// =========================
  var predictionData = Rxn<PredictionData>();

  // =====================================================
  // 🔹 INIT
  // =====================================================
  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  // =====================================================
  // 🔹 FETCH USER PROFILE (ONLY AIR)
  // =====================================================
  Future<void> fetchUserProfile() async {
    try {
      isProfileLoading.value = true;
      errorMessage.value = '';

      final profile = await ProfileService.getProfile();
      userAir.value = profile.allIndiaRank ?? 0;

    } catch (e) {
      errorMessage.value = "Failed to load profile";
      Get.snackbar("Error", "Unable to fetch profile");
    } finally {
      isProfileLoading.value = false;
    }
  }

  // =====================================================
  // 🔹 VALIDATE INPUT
  // =====================================================
  bool _validateInputs() {

    if (userAir.value == 0) {
      Get.snackbar("Error", "AIR not found in profile");
      return false;
    }

    if (selectedState.value.trim().isEmpty ||
        selectedCategory.value.trim().isEmpty ||
        selectedCourse.value.trim().isEmpty ||
        selectedYear.value == null ||
        selectedQuota.value.trim().isEmpty ||
        selectedRound.value.trim().isEmpty) {

      Get.snackbar("Error", "Please fill all required fields");
      return false;
    }

    if (selectedYear.value! < 2000) {
      Get.snackbar("Error", "Enter valid year");
      return false;
    }

    return true;
  }

  // =====================================================
  // 🔹 FETCH PREDICTION
  // =====================================================
  Future<void> fetchPrediction() async {

    if (!_validateInputs()) return;

    try {
      isPredictionLoading.value = true;
      errorMessage.value = '';

      final data = await PredictionService.fetchPrediction(
        allIndiaRank: userAir.value,
        category: selectedCategory.value.trim().toUpperCase(),
        course: selectedCourse.value.trim().toUpperCase(),
        year: selectedYear.value!,
        state: selectedState.value.trim(),
        quota: selectedQuota.value.trim().toUpperCase(),
        counsellingRound: selectedRound.value.trim().toUpperCase(),
      );

      predictionData.value = data;

      isPredictionLoading.value = false;

      /// 🔥 Navigate to AI Result Screen
      Get.to(() => AiPredictionResultView(
            predictionData: data,
          ));

    } catch (e) {
      isPredictionLoading.value = false;
      errorMessage.value = "Prediction failed";
      Get.snackbar("Error", "Prediction API failed");
    }
  }

  // =====================================================
  // 🔹 RESET FORM
  // =====================================================
  void resetPrediction() {
    predictionData.value = null;

    selectedState.value = "";
    selectedCategory.value = "";
    selectedCourse.value = "";
    selectedYear.value = null;
    selectedQuota.value = "";
    selectedRound.value = "";
  }
}