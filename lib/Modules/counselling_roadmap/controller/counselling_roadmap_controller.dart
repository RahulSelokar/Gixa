import 'package:get/get.dart';
import '../model/counselling_state_model.dart';
import '../model/counselling_state_parser.dart';
import 'package:Gixa/network/api_client.dart';

class CounsellingRoadmapController extends GetxController {
  final RxBool isUG = true.obs;
  final RxInt selectedStateIndex = 0.obs;
  final RxBool isLoading = false.obs;

  final RxList<CounsellingStateData> ugStatesList = <CounsellingStateData>[].obs;
  final RxList<CounsellingStateData> pgStatesList = <CounsellingStateData>[].obs;

  final Map<String, CounsellingStateData> _detailedStatesCache = {};

  @override
  void onInit() {
    super.onInit();
    fetchCounsellingStates(isUG.value);
  }

  List<CounsellingStateData> get currentStates =>
      isUG.value ? ugStatesList : pgStatesList;

  CounsellingStateData? get selectedState {
    if (currentStates.isEmpty) return null;
    final stateSummary = currentStates[selectedStateIndex.value];
    return _detailedStatesCache[stateSummary.id] ?? stateSummary;
  }

  void switchTab(bool ug) {
    if (isUG.value == ug) return;
    isUG.value = ug;
    selectedStateIndex.value = 0;
    fetchCounsellingStates(ug);
  }

  void selectState(int index) {
    if (index == selectedStateIndex.value) return;
    selectedStateIndex.value = index;
    _fetchStateDetailsIfNeeded();
  }

  final RxInt selectedSectionTab = 0.obs;

  void selectSectionTab(int index) {
    selectedSectionTab.value = index;
  }

  Future<void> fetchCounsellingStates(bool isUGFetch) async {
    final listToUpdate = isUGFetch ? ugStatesList : pgStatesList;
    if (listToUpdate.isNotEmpty) {
      _fetchStateDetailsIfNeeded();
      return;
    }

    try {
      isLoading.value = true;
      final type = isUGFetch ? 'ug' : 'pg';
      final response = await ApiClient.get('/api/counselling/states/?type=$type');
      
      if (response != null && response['data'] != null) {
        final List<dynamic> dataList = response['data'];
        final parsedList = dataList.map((e) => CounsellingStateParser.parse(e as Map<String, dynamic>)).toList();
        
        listToUpdate.assignAll(parsedList);
        await _fetchStateDetailsIfNeeded();
      }
    } catch (e) {
      print('Error fetching counselling states: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchStateDetailsIfNeeded() async {
    if (currentStates.isEmpty) return;
    if (selectedStateIndex.value >= currentStates.length) return;
    
    final stateSummary = currentStates[selectedStateIndex.value];
    if (_detailedStatesCache.containsKey(stateSummary.id)) {
      // Create a new reference to trigger UI updates just in case, or just refresh
      ugStatesList.refresh();
      pgStatesList.refresh();
      return;
    }

    try {
      isLoading.value = true;
      final type = isUG.value ? 'ug' : 'pg';
      final response = await ApiClient.get('/api/counselling/states/${stateSummary.id}/?type=$type');
      
      if (response != null && response['data'] != null) {
        final parsedDetails = CounsellingStateParser.parse(response['data'] as Map<String, dynamic>);
        _detailedStatesCache[stateSummary.id] = parsedDetails;
        
        // Notify UI that a state detail was loaded
        ugStatesList.refresh();
        pgStatesList.refresh();
      }
    } catch (e) {
      print('Error fetching counselling state details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}