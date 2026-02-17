import 'package:get/get.dart';
import '../model/coach_step.dart';

class CoachController extends GetxController {
  final steps = <CoachStep>[].obs;
  final index = 0.obs;
  final visible = false.obs;

  void start(List<CoachStep> s) {
    steps.assignAll(s);
    index.value = 0;
    visible.value = true;
  }

  void next() {
    if (index.value < steps.length - 1) {
      index.value++;
    } else {
      close();
    }
  }

  void skip() => close();

  void close() {
    visible.value = false;
    steps.clear();
  }

  CoachStep? get current =>
      steps.isEmpty ? null : steps[index.value];
}
