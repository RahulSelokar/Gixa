import 'package:Gixa/Modules/Documents/controller/view_document_controller.dart';
import 'package:get/get.dart';

class DocumentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentDocumentsController>(
      () => StudentDocumentsController(),
    );
  }
}
