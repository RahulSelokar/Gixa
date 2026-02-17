import 'package:get/get.dart';
import '../../../services/support_service.dart';
import '../model/support_contact_model.dart';

class SupportController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rxn<SupportContactModel> contact = Rxn<SupportContactModel>();

  @override
  void onInit() {
    super.onInit();
    fetchSupportContact();
  }

  Future<void> fetchSupportContact() async {
    try {
      isLoading.value = true;

      final result = await SupportService.getSupportContact();
      contact.value = result;

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
