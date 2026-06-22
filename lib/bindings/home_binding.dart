import 'package:Gixa/Modules/Home/controller/home_controller.dart';
import 'package:Gixa/Modules/notification/controller/notification_controller.dart';
import 'package:Gixa/Modules/notification/controller/alerts_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<AlertsController>(() => AlertsController());
  }
}
