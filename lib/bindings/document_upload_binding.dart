import 'package:Gixa/Modules/Documents/controller/documents_controller.dart';
import 'package:Gixa/Modules/Documents/controller/view_document_controller.dart';
import 'package:get/get.dart';

class DocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentController>(() => DocumentController());
    Get.lazyPut<StudentDocumentsController>(() => StudentDocumentsController());
  }
}