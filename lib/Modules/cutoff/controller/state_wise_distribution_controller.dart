import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/cutoff/model/state_wise_distribution_model.dart';
import 'package:Gixa/services/state_wise_distribution_service.dart';
import 'package:get/get.dart';

class StateWiseDistributionController extends GetxController {
  var isLoading = false.obs;
  var model = Rxn<StateWiseDistributionModel>();
  var sortedChartData = <ChartData>[].obs;

  var userAir = 0.obs;
  var selectedCourse = "".obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserFilters();
  }

  void _loadUserFilters() {
    if (Get.isRegistered<ProfileController>()) {
      final profileController = Get.find<ProfileController>();
      final profile = profileController.profile.value;
      if (profile != null) {
        userAir.value = profile.allIndiaRank ?? 0;
        selectedCourse.value = profile.course ?? "MBBS";
      }
    }
  }

  Future<void> fetchDistribution() async {
    isLoading.value = true;
    final response = await StateWiseDistributionService.getStateWiseDistribution(
      air: userAir.value > 0 ? userAir.value : 655, // Fallback for testing if userAir is 0
      course: selectedCourse.value.isNotEmpty ? selectedCourse.value : "MBBS",
    );

    if (response != null && response.success) {
      model.value = response;
      _prepareGraphData();
    }
    
    isLoading.value = false;
  }

  void _prepareGraphData() {
    if (model.value?.data == null) return;
    
    final data = List<ChartData>.from(model.value!.data!.chartData);
    // Sort descending by count
    data.sort((a, b) => b.count.compareTo(a.count));
    
    sortedChartData.value = data;
  }
}
