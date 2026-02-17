import 'package:Gixa/Modules/Documents/controller/documents_controller.dart';
import 'package:get/get.dart';

class DocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DocumentController>(DocumentController());
  }
}
