// import 'package:Gixa/Modules/Documents/controller/view_document_controller.dart';
// import 'package:Gixa/Modules/Documents/model/view_documents_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class DocumentsGalleryPage extends StatelessWidget {
//   DocumentsGalleryPage({super.key});

//   final controller = Get.put(StudentDocumentsController());

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Documents"),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.documents.isEmpty) {
//           return const Center(child: Text("No documents uploaded"));
//         }

//         return GridView.builder(
//           padding: const EdgeInsets.all(16),
//           gridDelegate:
//               const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             mainAxisSpacing: 16,
//             crossAxisSpacing: 16,
//             childAspectRatio: 0.75,
//           ),
//           itemCount: controller.documents.length,
//           itemBuilder: (context, index) {
//             final doc = controller.documents[index];
//             return _DocumentGalleryCard(doc: doc, isDark: isDark);
//           },
//         );
//       }),
//     );
//   }
// }
// class _DocumentGalleryCard extends StatelessWidget {
//   final StudentDocumentModel doc;
//   final bool isDark;

//   const _DocumentGalleryCard({
//     required this.doc,
//     required this.isDark,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _openPreview(context),
//       child: Container(
//         decoration: BoxDecoration(
//           color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           // border: Border.all(
//           //   color: doc.isVerified ? Colors.green : Colors.orange,
//           //   width: 1.2,
//           // ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             /// PREVIEW
//             Expanded(
//               child: ClipRRect(
//                 borderRadius:
//                     const BorderRadius.vertical(top: Radius.circular(12)),
//                 child: doc.isImage
//                     ? Image.network(
//                         doc.fileUrl,
//                         fit: BoxFit.cover,
//                       )
//                     : Container(
//                         color: Colors.grey[200],
//                         child: const Center(
//                           child: Icon(
//                             Icons.picture_as_pdf,
//                             size: 48,
//                             color: Colors.red,
//                           ),
//                         ),
//                       ),
//               ),
//             ),

//             /// INFO
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     doc.documentName,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     doc.documentType
//                         .replaceAll('_', ' ')
//                         .toUpperCase(),
//                     style: const TextStyle(fontSize: 11),
//                   ),
//                   const SizedBox(height: 6),
//                   // Row(
//                   //   children: [
//                   //     Icon(
//                   //       doc.isVerified
//                   //           ? Icons.verified
//                   //           : Icons.pending,
//                   //       size: 16,
//                   //       color: doc.isVerified
//                   //           ? Colors.green
//                   //           : Colors.orange,
//                   //     ),
//                   //     const SizedBox(width: 4),
//                   //     Text(
//                   //       doc.isVerified ? "Verified" : "Pending",
//                   //       style: TextStyle(
//                   //         fontSize: 11,
//                   //         color: doc.isVerified
//                   //             ? Colors.green
//                   //             : Colors.orange,
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _openPreview(BuildContext context) {
//     if (doc.isImage) {
//       Get.to(() => _ImagePreview(url: doc.fileUrl));
//     } else {
//       // Later you can open PDF viewer
//       Get.snackbar("PDF", "Open PDF viewer here");
//     }
//   }
// }
// class _ImagePreview extends StatelessWidget {
//   final String url;

//   const _ImagePreview({required this.url});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(backgroundColor: Colors.black),
//       body: Center(
//         child: InteractiveViewer(
//           child: Image.network(url),
//         ),
//       ),
//     );
//   }
// }




import 'dart:io';
import 'package:Gixa/Modules/Documents/controller/view_document_controller.dart';
import 'package:Gixa/Modules/Documents/model/view_documents_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DocumentsGalleryPage extends StatelessWidget {
  DocumentsGalleryPage({super.key});

  final StudentDocumentsController controller =
      Get.put(StudentDocumentsController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Documents"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.documents.isEmpty) {
          return const Center(child: Text("No documents uploaded"));
        }

        return RefreshIndicator(
          onRefresh: controller.refreshDocuments,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: controller.documents.length,
            itemBuilder: (context, index) {
              final doc = controller.documents[index];
              return _DocumentGalleryCard(
                doc: doc,
                isDark: isDark,
              );
            },
          ),
        );
      }),
    );
  }
}
class _DocumentGalleryCard extends StatelessWidget {
  final StudentDocumentModel doc;
  final bool isDark;

  const _DocumentGalleryCard({
    required this.doc,
    required this.isDark,
  });

  bool get isImage =>
      doc.fileUrl.endsWith(".png") ||
      doc.fileUrl.endsWith(".jpg") ||
      doc.fileUrl.endsWith(".jpeg");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPreview(),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black.withOpacity(0.05),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// PREVIEW
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: isImage
                    ? Image.network(
                        doc.fileUrl,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.picture_as_pdf,
                            size: 48,
                            color: Colors.red,
                          ),
                        ),
                      ),
              ),
            ),

            /// INFO
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.documentName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doc.documentType.replaceAll('_', ' ').toUpperCase(),
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPreview() {
    if (isImage) {
      Get.to(() => _ImagePreview(url: doc.fileUrl));
    } else {
      Get.to(() => PdfPreviewPage(pdfUrl: doc.fileUrl));
    }
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
class PdfPreviewPage extends StatefulWidget {
  final String pdfUrl;

  const PdfPreviewPage({super.key, required this.pdfUrl});

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath =
          "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.pdf";

      await Dio().download(widget.pdfUrl, filePath);

      setState(() {
        localPath = filePath;
        isLoading = false;
      });
    } catch (e) {
      Get.snackbar("Error", "Failed to load PDF");
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Preview")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPath == null
              ? const Center(child: Text("Unable to load PDF"))
              : PDFView(
                  filePath: localPath!,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: true,
                  pageFling: true,
                ),
    );
  }
}
