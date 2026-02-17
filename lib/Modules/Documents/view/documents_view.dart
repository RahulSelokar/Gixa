import 'package:Gixa/Modules/Documents/controller/documents_controller.dart';
import 'package:Gixa/Modules/Documents/controller/view_document_controller.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadDocumentPage extends StatelessWidget {
  UploadDocumentPage({super.key});

  final DocumentController controller = Get.put(
    DocumentController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    // 1. Determine Theme Mode
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 2. Define Adaptive Palette
    final Color primaryColor = const Color(
      0xFF3B82F6,
    ); // Slightly lighter blue for better dark contrast
    final Color successColor = const Color(0xFF10B981);

    final Color backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF8FAFC);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark ? Colors.grey.shade400 : Colors.black54;
    final Color borderColor = isDark
        ? Colors.grey.shade800
        : Colors.grey.shade200;
    final Color iconBgUnselected = isDark
        ? const Color(0xFF2C2C2C)
        : Colors.blueGrey.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Verification",
          style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<DocumentController>(
        builder: (controller) {
          final viewController = Get.find<StudentDocumentsController>();

          int total = controller.requiredDocuments.length;

          int uploadedCount = controller.requiredDocuments
              .where(
                (docType) => viewController.documents.any(
                  (doc) =>
                      doc.documentType.toLowerCase().replaceAll(" ", "_") ==
                      docType,
                ),
              )
              .length;

          double progress = total == 0 ? 0 : uploadedCount / total;

          return Column(
            children: [
              _buildHeader(
                uploaded: uploadedCount,
                total: total,
                progress: progress,
                textColor: textColor,
                subTextColor: subTextColor,
                primaryColor: primaryColor,
                successColor: successColor,
                isDark: isDark,
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  itemCount: controller.requiredDocuments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final docType = controller.requiredDocuments[index];

                    final isUploaded = viewController.documents.any(
                      (doc) =>
                          doc.documentType.toLowerCase().replaceAll(" ", "_") ==
                          docType,
                    );

                    final isUploading =
                        controller.currentUploadingDoc == docType;

                    return _buildDocumentCard(
                      docType: docType,
                      isUploaded: isUploaded,
                      isUploading: isUploading,
                      controller: controller,
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      primaryColor: primaryColor,
                      successColor: successColor,
                      iconBgUnselected: iconBgUnselected,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader({
    required int uploaded,
    required int total,
    required double progress,
    required Color textColor,
    required Color subTextColor,
    required Color primaryColor,
    required Color successColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upload Required Documents",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Please upload clear Documents to verify your identity.",
            style: TextStyle(color: subTextColor, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Progress",
                style: TextStyle(
                  color: subTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "$uploaded/$total Completed",
                style: TextStyle(
                  color: progress == 1.0 ? successColor : primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: isDark
                  ? Colors.grey.shade800
                  : Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? successColor : primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard({
    required String docType,
    required bool isUploaded,
    required bool isUploading,
    required DocumentController controller,
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    required Color subTextColor,
    required Color primaryColor,
    required Color successColor,
    required Color iconBgUnselected,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUploaded ? successColor.withOpacity(0.5) : borderColor,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            /// Status Icon
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: isUploaded
                    ? successColor.withOpacity(0.15)
                    : iconBgUnselected,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: isUploading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: primaryColor,
                        ),
                      )
                    : Icon(
                        isUploaded
                            ? Icons.check_circle_outline
                            : Icons.file_upload_outlined,
                        color: isUploaded ? successColor : subTextColor,
                        size: 26,
                      ),
              ),
            ),
            const SizedBox(width: 16),

            /// Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDocName(docType),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isUploaded
                        ? "Verified & Uploaded"
                        : "Tap Upload to add document",
                    style: TextStyle(
                      fontSize: 13,
                      color: isUploaded ? successColor : subTextColor,
                    ),
                  ),
                ],
              ),
            ),

            /// Upload / Update Button
            if (!isUploading)
              GestureDetector(
                onTap: () {
                  if (isUploaded) {
                    showUpdateDialog(docType);
                    // 👈 call your dialog
                  } else {
                    controller.updateDocument(docType);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isUploaded
                        ? Colors.orange.withOpacity(0.1)
                        : primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isUploaded ? "Update" : "Upload",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isUploaded ? Colors.orange : primaryColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDocName(String raw) {
    if (raw.isEmpty) return "";
    return raw
        .replaceAll('_', ' ')
        .split(' ')
        .map((str) => str.capitalizeFirst)
        .join(' ');
  }
}

void showUpdateDialog(String docType) {
  final DocumentController controller = Get.find<DocumentController>();

  final isDark = Get.isDarkMode;

  final Color backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
  final Color textColor = isDark ? Colors.white : Colors.black87;
  final Color subTextColor = isDark ? Colors.grey.shade400 : Colors.black54;
  final Color cancelBgColor = isDark
      ? Colors.grey.shade800
      : Colors.grey.shade200;

  const Color primaryColor = Color(0xFF3B82F6);
  final Color accentColor = Colors.orange;

  Get.dialog(
    Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Icon
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.refresh_rounded, color: accentColor, size: 34),
            ),
            const SizedBox(height: 20),

            /// Title
            Text(
              "Update Document?",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            /// Subtitle
            Text(
              "Are you sure you want to replace this document?\nThis action cannot be undone.",
              style: TextStyle(fontSize: 14, height: 1.4, color: subTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            /// Buttons
            Row(
              children: [
                /// Cancel
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cancelBgColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                /// Confirm
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      controller.updateDocument(docType);
                    },
                    child: const Text(
                      "Yes, Update",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}
