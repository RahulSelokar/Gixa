import 'package:Gixa/Modules/Documents/model/view_documents_model.dart';
import 'package:Gixa/services/view_document_service.dart';
import 'package:get/get.dart';

class StudentDocumentsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<StudentDocumentModel> documents =
      <StudentDocumentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    try {
      isLoading.value = true;

      final result = await StudentDocumentService.fetchDocuments();

      final Map<String, StudentDocumentModel> latestDocs = {};

      for (final doc in result) {
        // 🔥 NORMALIZE document type
        final key = doc.documentType
            .trim()
            .toLowerCase()
            .replaceAll(' ', '_');

        if (!latestDocs.containsKey(key)) {
          latestDocs[key] = doc;
        } else {
          // pick latest by id
          if (doc.id > latestDocs[key]!.id) {
            latestDocs[key] = doc;
          }
        }
      }

      documents.assignAll(latestDocs.values.toList());
    } catch (e) {
      Get.snackbar("Error", "Failed to load documents");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDocuments() async {
    await fetchDocuments();
  }
}
