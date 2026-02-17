import 'dart:io';
import 'package:get/get.dart';
import 'package:file_selector/file_selector.dart';
import 'package:Gixa/services/document_api_services.dart';
import 'package:Gixa/network/app_exception.dart';
import 'package:Gixa/Modules/Documents/controller/view_document_controller.dart';

class DocumentController extends GetxController {
  final DocumentApiService _service = DocumentApiService();

  /// ✅ ADD THIS BACK
  final List<String> requiredDocuments = [
    "10th_marksheet",
    "12th_marksheet",
    "neet_scorecard",
  ];

  bool isUploading = false;
  String currentUploadingDoc = '';

  final int maxFileSizeMB = 10;

  Future<void> uploadDocument(String docType) async {
    await _pickAndProcess(docType, isUpdate: false);
  }

  Future<void> updateDocument(String docType) async {
    await _pickAndProcess(docType, isUpdate: true);
  }

  Future<void> _pickAndProcess(String docType, {required bool isUpdate}) async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'documents',
      extensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    final XFile? pickedFile = await openFile(acceptedTypeGroups: [typeGroup]);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);

    final sizeInMB = await file.length() / (1024 * 1024);
    if (sizeInMB > maxFileSizeMB) {
      Get.snackbar(
        "File Too Large",
        "Maximum allowed size is $maxFileSizeMB MB",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isUploading = true;
    currentUploadingDoc = docType;
    update();

    final documentName = docType.replaceAll('_', ' ').toUpperCase();

    try {
      if (isUpdate) {
        final viewController = Get.find<StudentDocumentsController>();
        print("DOCUMENT COUNT: ${viewController.documents.length}");
        print("LOOKING FOR TYPE: $docType");
        print("BACKEND TYPES:");

        for (var d in viewController.documents) {
          print("RAW TYPE: ${d.documentType}");
        }

        final existingDoc = viewController.documents.firstWhere(
          (doc) {
            final backendType = doc.documentType
                .trim()
                .toLowerCase()
                .replaceAll(" ", "_");

            final requiredType = docType.trim().toLowerCase().replaceAll(
              " ",
              "_",
            );

            return backendType == requiredType;
          },
          orElse: () {
            print("DEBUG TYPES:");
            print("Looking for: $docType");
            print("Available types:");
            for (var d in viewController.documents) {
              print(d.documentType);
            }
            throw Exception("Document not found for update");
          },
        );

        await _service.updateDocument(
          file: file,
          documentType: docType,
          documentName: documentName,
          documentId: existingDoc.id,
        );
      } else {
        await _service.uploadDocument(
          file: file,
          documentType: docType,
          documentName: documentName,
        );
      }

      /// Refresh list
      Get.find<StudentDocumentsController>().refreshDocuments();

      Get.snackbar(
        "Success",
        isUpdate
            ? "Document updated successfully"
            : "Document uploaded successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print("ERROR: $e");
      Get.snackbar(
        "Error",
        "Operation failed. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUploading = false;
      currentUploadingDoc = '';
      update();
    }
  }
}
