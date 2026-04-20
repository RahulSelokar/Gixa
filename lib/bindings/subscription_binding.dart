import 'package:Gixa/Modules/subscription/controller/subsciption_history_controller.dart';
import 'package:get/get.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SubscriptionController>()) {
      Get.lazyPut<SubscriptionController>(() => SubscriptionController());
    }

    if (!Get.isRegistered<SubscriptionHistoryController>()) {
      Get.lazyPut<SubscriptionHistoryController>(
        () => SubscriptionHistoryController(),
      );
    }
  }
}
