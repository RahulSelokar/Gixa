// import 'package:Gixa/Modules/cutoff/model/cutoff_data.dart';
// import 'package:Gixa/Modules/cutoff/model/cutoff_model.dart';
// import 'package:get/get.dart';

// class CutoffController extends GetxController {
//   final selectedState = "".obs;
//   final selectedCourse = "".obs;
//   final selectedCategory = "GEN".obs;

//   final colleges = <CutoffCollegeModel>[].obs;

//   final states = ["Delhi", "Maharashtra"];
//   final courses = ["MBBS"];
//   final categories = ["GEN", "OBC", "SC", "ST"];

//   void applyFilters() {
//     colleges.value = staticCutoffColleges.where((c) {
//       return c.state == selectedState.value &&
//           c.category == selectedCategory.value;
//     }).toList();
//   }
// }
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/cutoff/model/cutoff_graph_model.dart';
import 'package:Gixa/services/cutoff_services.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class AirComparisonController extends GetxController {
  final ProfileController profileController = Get.find();

  var isLoading = false.obs;
  var comparison = Rxn<AirComparisonModel>();

  /// Filters
  var selectedState = "".obs;
  var selectedCategory = "".obs;
  var selectedCourse = "".obs;
  var selectedQuota = "State".obs;
  var userAir = 0.obs;

  /// Graph Spots
  List<FlSpot> closingSpots = [];
  List<FlSpot> userSpots = [];

  /// Chance Result
  var chanceText = "".obs;
  var chanceColor = 0xFFEC8B04.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserFilters();
  }

  void loadUserFilters() {
    final profile = profileController.profile.value;

    if (profile != null) {
      selectedState.value = profile.state ?? "";
      selectedCategory.value = profile.category ?? "";
      selectedCourse.value = profile.course ?? "";
      userAir.value = profile.allIndiaRank ?? 0;
    }
  }

  Future<void> fetchComparison() async {
    isLoading.value = true;

    final res = await AirComparisonApiService.getAirComparison(
      air: userAir.value,
      state: selectedState.value,
      category: selectedCategory.value,
      course: selectedCourse.value,
      quota: selectedQuota.value,
    );

    if (res != null) {
      comparison.value = res;
      _prepareGraph();
      _calculateChance();
    }

    isLoading.value = false;
  }

  void _prepareGraph() {
    final years = comparison.value!.graph.years;
    final closing = comparison.value!.graph.closingLine;
    final user = comparison.value!.graph.userAirLine;

    closingSpots = [];
    userSpots = [];

    for (int i = 0; i < years.length; i++) {
      closingSpots.add(FlSpot(i.toDouble(), closing[i].toDouble()));
      userSpots.add(FlSpot(i.toDouble(), user[i].toDouble()));
    }
  }

  void _calculateChance() {
    final closing = comparison.value!.graph.closingLine.last;
    final user = comparison.value!.user.air;

    final diff = user - closing;

    if (user <= closing) {
      chanceText.value = "High Chance";
      chanceColor.value = 0xFF2E7D32;
    } else if (diff < 50000) {
      chanceText.value = "Moderate Chance";
      chanceColor.value = 0xFFF9A825;
    } else {
      chanceText.value = "Low Chance";
      chanceColor.value = 0xFFC62828;
    }
  }

  void updateFilters({
    String? state,
    String? category,
    String? course,
    String? quota,
    int? air,
  }) {
    if (state != null) selectedState.value = state;
    if (category != null) selectedCategory.value = category;
    if (course != null) selectedCourse.value = course;
    if (quota != null) selectedQuota.value = quota;
    if (air != null) userAir.value = air;

    fetchComparison();
  }
}
