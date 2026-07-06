import 'package:get/get.dart';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import '../model/counselling_state_model.dart';
import '../data/ug/ug_states.dart';
import '../data/pg/pg_states.dart';

class CounsellingRoadmapController extends GetxController {
  final ProfileController _profileController = Get.find<ProfileController>();

  bool get isUG => _profileController.isUGUser;

  final RxInt selectedStateIndex = 0.obs;

  List<CounsellingStateData> get currentStates =>
      isUG ? ugCounsellingStates : pgCounsellingStates;

  CounsellingStateData get selectedState =>
      currentStates[selectedStateIndex.value];

  // switchTab logic removed as level is tied to user profile
  void switchTab(bool ug) {
    selectedStateIndex.value = 0;
  }

  void selectState(int index) {
    selectedStateIndex.value = index;
  }

  final RxInt selectedSectionTab = 0.obs;

  void selectSectionTab(int index) {
    selectedSectionTab.value = index;
  }
}