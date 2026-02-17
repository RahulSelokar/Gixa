import 'package:Gixa/Modules/Documents/view/documents_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Gixa/Modules/Documents/controller/documents_controller.dart';
import 'package:Gixa/Modules/Documents/controller/view_document_controller.dart';
import 'package:Gixa/Modules/Documents/model/view_documents_model.dart';
import 'package:Gixa/Modules/Documents/view/view_documents_page.dart';

class StudentDocumentsUnifiedPage extends StatelessWidget {
  StudentDocumentsUnifiedPage({super.key});

  final DocumentController uploadController =
      Get.put(DocumentController());

  final StudentDocumentsController viewController =
      Get.put(StudentDocumentsController());

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    final backgroundColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("My Documents"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (viewController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: viewController.refreshDocuments,
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: uploadController.requiredDocuments.length,
            itemBuilder: (context, index) {
              final docType =
                  uploadController.requiredDocuments[index];

              final uploadedDoc =
                  viewController.documents.firstWhereOrNull(
                (doc) =>
                    doc.documentType
                        .toLowerCase()
                        .replaceAll(" ", "_") ==
                    docType,
              );

              return _buildCard(docType, uploadedDoc, isDark);
            },
          ),
        );
      }),
    );
  }

  Widget _buildCard(
      String docType, StudentDocumentModel? doc, bool isDark) {
    final cardColor =
        isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: doc == null
          ? _buildUploadSection(docType, isDark)
          : _buildPreviewSection(doc, docType, isDark),
    );
  }

  /// 🔹 NOT UPLOADED UI
  Widget _buildUploadSection(String docType, bool isDark) {
    final primaryColor = const Color(0xFF3B82F6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          docType.replaceAll("_", " ").toUpperCase(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 14),

        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: primaryColor.withOpacity(0.3)),
          ),
          child: Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                uploadController.uploadDocument(docType);
              },
              icon: const Icon(Icons.upload_file),
              label: const Text("Upload Document"),
            ),
          ),
        ),
      ],
    );
  }

  /// 🔹 UPLOADED UI
  Widget _buildPreviewSection(
      StudentDocumentModel doc, String docType, bool isDark) {
    final primaryColor = const Color(0xFF3B82F6);
    final editColor = Colors.orange;

    final isImage =
        doc.fileUrl.endsWith(".jpg") ||
        doc.fileUrl.endsWith(".png") ||
        doc.fileUrl.endsWith(".jpeg");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          doc.documentName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 14),

        /// Preview
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 170,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: isImage
                ? Image.network(
                    doc.fileUrl,
                    fit: BoxFit.cover,
                  )
                : const Center(
                    child: Icon(
                      Icons.picture_as_pdf,
                      size: 70,
                      color: Colors.red,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 16),

        /// Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (isImage) {
                    Get.to(() => _ImagePreview(url: doc.fileUrl));
                  } else {
                    Get.to(
                        () => PdfPreviewPage(pdfUrl: doc.fileUrl));
                  }
                },
                icon: const Icon(Icons.visibility),
                label: const Text("View"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: editColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showUpdateDialog(docType);
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final String url;

  const _ImagePreview({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(url),
        ),
      ),
    );
  }
}
