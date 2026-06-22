import 'package:get/get.dart';
import 'package:Gixa/Modules/addon_contact/model/addon_contact_model.dart';
import 'package:Gixa/services/addon_contact_service.dart';

class AddonContactController extends GetxController {
  final isLoading = false.obs;
  final addonContactData = Rxn<AddonContactModel>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddonContact();
  }

  Future<void> fetchAddonContact() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await AddonContactService.getAddonContact();
      addonContactData.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
