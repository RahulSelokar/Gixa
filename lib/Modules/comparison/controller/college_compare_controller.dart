import 'package:Gixa/Modules/comparison/model/college_compare_model.dart';
import 'package:Gixa/Modules/comparison/model/compare_history_model.dart';
import 'package:Gixa/Modules/comparison/model/save_compare_model.dart';
import 'package:Gixa/services/compare_collage_services.dart';
import 'package:Gixa/services/save_compare_service.dart';
import 'package:get/get.dart';

class CollegeCompareController extends GetxController {
  final isLoading = false.obs;
  final isSaving = false.obs;

  final selectedColleges = <String>[].obs;

  final compareResult = Rxn<CollegeCompareResponse>();

  SaveCompareResponse? lastSavedResult;

  // ─────────────────────────────────────────────
  // 🔁 AUTO COMPARE WHEN PAGE OPENS
  // ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
  }

  /// Called by the compare page each time it opens
  void initFromArgs(dynamic args) {
    // Reset previous state
    selectedColleges.clear();
    compareResult.value = null;
    lastSavedResult = null;

    if (args == null) return;

    // From college list page: {'collegeCodes': ['101', '102']}
    if (args is Map && args['collegeCodes'] is List) {
      final codes = List<String>.from(args['collegeCodes']);
      if (codes.isNotEmpty) {
        selectedColleges.assignAll(codes);
        print('🟡 Loaded colleges from args 👉 $codes');
      }
    }

    // From history page: CompareHistoryItem
    if (args is CompareHistoryItem) {
      final codes = args.colleges.map((c) => c.collegeCode).toList();
      if (codes.isNotEmpty) {
        selectedColleges.assignAll(codes);
        print('🟡 Loaded colleges from history 👉 $codes');
      }
    }

    // Auto-compare if enough colleges
    if (selectedColleges.length >= 2) {
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

      print("===== COMPARE API RESPONSE =====");
      print("Status: ${result.status}");
      print("Total Colleges: ${result.totalColleges}");

      for (var college in result.comparison) {
        print("------------");
        print("College Name: ${college.collegeName}");
        print("College Code: ${college.collegeCode}");
        print("Total Seats: ${college.seats}");
        print("Cutoffs Count: ${college.cutoffs.length}");

        for (var cutoff in college.cutoffs) {
          print("Cutoff Seats: ${cutoff.totalSeats}");
        }
      }

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

  void loadHistoryComparison(dynamic historyItem) {
    compareResult.value = CollegeCompareResponse(
      status: "success",
      studentProfile: null,
      totalColleges: historyItem.colleges.length,
      comparison: historyItem.colleges,
    );
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
