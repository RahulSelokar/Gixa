import 'package:Gixa/Modules/cutoff/model/cutoff_data.dart';
import 'package:Gixa/Modules/cutoff/model/cutoff_model.dart';
import 'package:get/get.dart';

class CutoffController extends GetxController {
  final selectedState = "".obs;
  final selectedCourse = "".obs;
  final selectedCategory = "GEN".obs;

  final colleges = <CutoffCollegeModel>[].obs;

  final states = ["Delhi", "Maharashtra"];
  final courses = ["MBBS"];
  final categories = ["GEN", "OBC", "SC", "ST"];

  void applyFilters() {
    colleges.value = staticCutoffColleges.where((c) {
      return c.state == selectedState.value &&
          c.category == selectedCategory.value;
    }).toList();
  }
}
