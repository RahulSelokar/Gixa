import 'package:get/get.dart';
import '../service/coach_service.dart';
import '../model/coach_step.dart';

class CoachController extends GetxController {
  final steps = <CoachStep>[].obs;
  final index = 0.obs;
  final visible = false.obs;
  final transitioning = false.obs;
  final activeScreenKey = RxnString();

  void start(String screenKey, List<CoachStep> s) {
    steps.assignAll(s);
    activeScreenKey.value = screenKey;
    index.value = 0;
    visible.value = true;
  }

  Future<void> next() async {
    if (index.value < steps.length - 1) {
      index.value++;
    } else {
      await close();
    }
  }

  Future<void> skip() => close();

  Future<void> close() async {
    final screenKey = activeScreenKey.value;
    if (screenKey != null && screenKey.isNotEmpty) {
      await CoachService.markSeen(screenKey);
    }
    transitioning.value = false;
    visible.value = false;
    activeScreenKey.value = null;
    index.value = 0;
    steps.clear();
  }

  CoachStep? get current => steps.isEmpty ? null : steps[index.value];
  bool get isLastStep => steps.isNotEmpty && index.value == steps.length - 1;
  int get totalSteps => steps.length;
  int get currentStepNumber => steps.isEmpty ? 0 : index.value + 1;
}
