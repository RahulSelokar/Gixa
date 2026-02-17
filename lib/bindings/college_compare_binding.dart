import 'package:Gixa/Modules/comparison/controller/college_compare_controller.dart';
import 'package:get/get.dart';

class CollegeCompareBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CollegeCompareController());
  }
}
