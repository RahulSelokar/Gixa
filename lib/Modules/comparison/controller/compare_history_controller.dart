import 'package:Gixa/services/compare_history_service.dart';
import 'package:get/get.dart';
import '../model/compare_history_model.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';

class CompareHistoryController extends GetxController {
  final isLoading = false.obs;
  final historyList = <CompareHistoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      isLoading.value = true;

      final response = await CompareHistoryService.fetchHistory();
      historyList.assignAll(response.history);
    } catch (e) {
      AppSnackbar.show("Error", "Failed to load comparison history");
    } finally {
      isLoading.value = false;
    }
  }
}

