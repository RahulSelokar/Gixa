import 'package:Gixa/Modules/choice_filling/model/prediction_sheet_model.dart';
import 'package:Gixa/services/predication_sheet_service.dart';
import 'package:get/get.dart';

class PredictionSheetController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isExpanded = false.obs;

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  RxList<PredictionSheetModel> sheets =
      <PredictionSheetModel>[].obs;

  /// ================================
  /// ✅ FETCH SHEETS
  /// ================================
  Future<void> fetchPredictionSheets() async {
    try {
      isLoading.value = true;

      final data =
          await PredictionSheetService.getPredictionSheets();

      sheets.assignAll(data);
    } catch (e) {
      print("❌ CONTROLLER ERROR => $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ================================
  /// ✅ DOWNLOAD FILE
  /// ================================
  Future<void> openSheet(
    PredictionSheetModel sheet,
  ) async {
    await PredictionSheetService.downloadAndOpenFile(
      url: sheet.fileUrl,
      fileName: sheet.fileName,
    );
  }

  @override
  void onInit() {
    fetchPredictionSheets();

    super.onInit();
  }
}