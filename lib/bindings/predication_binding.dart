import 'package:Gixa/Modules/predication/controller/prediction_controller.dart';
import 'package:get/get.dart';

class PredicationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PredictionController>()) {
      Get.lazyPut<PredictionController>(() => PredictionController());
    }
  }
}
