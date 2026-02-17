import 'package:Gixa/Modules/Assistance/model/couselor_details_model.dart';
import 'package:Gixa/services/counselor_services.dart';
import 'package:get/get.dart';

class CounselorDetailController extends GetxController {
  final Rx<CounselorDetail?> counselor = Rx<CounselorDetail?>(null);
  final RxBool isLoading = false.obs;

  late int counselorId;

  void init(int id) {
    counselorId = id;
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      isLoading.value = true;

      final data =
          await CounselorService.fetchCounselorDetail(counselorId: counselorId);

      counselor.value = data;

      print("👨‍🏫 COUNSELOR DETAIL LOADED: ${data.name}");
    } catch (e) {
      Get.snackbar("Error", "Failed to load counselor details");
    } finally {
      isLoading.value = false;
    }
  }
}
