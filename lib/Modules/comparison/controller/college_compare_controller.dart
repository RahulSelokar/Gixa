import 'package:Gixa/Modules/comparison/model/college_compare_model.dart';
import 'package:Gixa/Modules/comparison/model/save_compare_model.dart';
import 'package:Gixa/services/compare_collage_services.dart';
import 'package:Gixa/services/save_compare_service.dart';
import 'package:get/get.dart';

class CollegeCompareController extends GetxController {
  /// 🔄 Loading states
  final isLoading = false.obs;
  final isSaving = false.obs;

  /// 🎯 Selected colleges (codes)
  final selectedColleges = <String>[].obs;

  /// 📊 Compare result
  final compareResult = Rxn<CollegeCompareResponse>();

  /// 💾 Last saved result
  SaveCompareResponse? lastSavedResult;

  // ─────────────────────────────────────────────
  // 🔁 AUTO COMPARE WHEN PAGE OPENS
  // ─────────────────────────────────────────────
  @override
  void onReady() {
    super.onReady();

    print('🟡 CompareController onReady');
    print('🟡 Selected Colleges onReady 👉 $selectedColleges');

    if (selectedColleges.length == 2) {
      compareColleges();
    }
  }

  // ─────────────────────────────────────────────
  // 🏫 TOGGLE COLLEGE SELECTION
  // ─────────────────────────────────────────────
  void toggleCollege(String code) {
    print('🟢 Toggle College 👉 $code');

    if (selectedColleges.contains(code)) {
      selectedColleges.remove(code);
    } else {
      if (selectedColleges.length < 2) {
        selectedColleges.add(code);
      } else {
        Get.snackbar(
          "Limit Reached",
          "Only 2 colleges can be compared at a time",
        );
      }
    }

    print('🟢 Selected Colleges NOW 👉 $selectedColleges');
  }

  // ─────────────────────────────────────────────
  // 🔍 COMPARE COLLEGES API
  // ─────────────────────────────────────────────
  Future<void> compareColleges() async {
    print('🔵 compareColleges() CALLED');
    print('🔵 Selected Colleges 👉 $selectedColleges');

    if (selectedColleges.length != 2) {
      Get.snackbar("Error", "Select exactly 2 colleges");
      return;
    }

    /// 🚨 TEMP SAFETY CHECK
    final invalidCodes = selectedColleges.where(
      (c) => !RegExp(r'^\d+$').hasMatch(c),
    );

    if (invalidCodes.isNotEmpty) {
      print('🚨 INVALID COLLEGE CODES 👉 $invalidCodes');

      Get.snackbar(
        "Comparison not supported",
        "Some colleges cannot be compared yet",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      print('🚀 Calling Compare API...');
      final result = await CollegeCompareService.compareColleges(
        selectedColleges,
      );

      compareResult.value = result;
    } catch (e, stack) {
      print('❌ Compare API FAILED');
      print('❌ Error 👉 $e');
      print('❌ Stack 👉 $stack');

      Get.snackbar("Error", "Failed to compare colleges");
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // 💾 SAVE COMPARED COLLEGES
  // ─────────────────────────────────────────────
  Future<void> saveComparedColleges() async {
    print('💾 Save Comparison CALLED');
    print('💾 Selected Colleges 👉 $selectedColleges');

    if (selectedColleges.isEmpty) {
      Get.snackbar("Error", "No colleges to save");
      return;
    }

    try {
      isSaving.value = true;

      final response = await SaveCompareService.saveComparison(
        selectedColleges,
      );

      lastSavedResult = response;

      print('✅ Save API SUCCESS 👉 ${response.message}');

      Get.snackbar(
        "Saved Successfully",
        response.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stack) {
      print('❌ Save API FAILED');
      print('❌ Error 👉 $e');
      print('❌ Stack 👉 $stack');

      Get.snackbar(
        "Error",
        "Failed to save comparison",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // ♻️ CLEAR STATE
  // ─────────────────────────────────────────────
  void clearComparison() {
    print('♻️ Clearing comparison state');
    selectedColleges.clear();
    compareResult.value = null;
  }
}
