import 'package:get/get.dart';
import '../model/counselling_state_model.dart';
import '../data/ug/ug_states.dart';
import '../data/pg/pg_states.dart';

class CounsellingRoadmapController extends GetxController {
  final RxBool isUG = true.obs;
  final RxInt selectedStateIndex = 0.obs;

  List<CounsellingStateData> get currentStates =>
      isUG.value ? ugCounsellingStates : pgCounsellingStates;

  CounsellingStateData get selectedState =>
      currentStates[selectedStateIndex.value];

  void switchTab(bool ug) {
    isUG.value = ug;
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