import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

void showDocumentPreview(String url) async {
  final lowerUrl = url.toLowerCase();

  /// IMAGE PREVIEW
  if (lowerUrl.endsWith(".jpg") ||
      lowerUrl.endsWith(".png") ||
      lowerUrl.endsWith(".jpeg")) {
    Get.dialog(
      Dialog(
        child: InteractiveViewer(
          child: Image.network(url, fit: BoxFit.contain),
        ),
      ),
    );
    return;
  }

  /// PDF PREVIEW
  if (lowerUrl.endsWith(".pdf")) {
    final dir = await getTemporaryDirectory();
    final filePath = "${dir.path}/temp.pdf";

    await Dio().download(url, filePath);

    Get.dialog(
      Dialog(
        child: SizedBox(
          height: 500,
          child: PDFView(
            filePath: filePath,
          ),
        ),
      ),
    );
    return;
  }

  /// DOC / DOCX / OTHER FILES
  final dir = await getTemporaryDirectory();
  final filePath = "${dir.path}/temp_file";

  await Dio().download(url, filePath);
  await OpenFilex.open(filePath);
}