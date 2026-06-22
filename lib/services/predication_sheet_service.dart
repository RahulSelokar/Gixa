import 'dart:io';

import 'package:Gixa/Modules/choice_filling/model/prediction_sheet_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class PredictionSheetService {
  PredictionSheetService._();

  /// ================================
  /// ✅ GET PREDICTION SHEETS
  /// ================================
  static Future<List<PredictionSheetModel>>
      getPredictionSheets() async {
    try {
      final response = await ApiClient.get(
        ApiEndpoints.predictionSheets,
      );

      print("📥 PREDICTION SHEETS RESPONSE => $response");

      final List results = response['results'] ?? [];

      return results
          .map((e) => PredictionSheetModel.fromJson(e))
          .toList();
    } catch (e) {
      print("❌ GET PREDICTION SHEETS ERROR => $e");
      return [];
    }
  }

  /// ================================
  /// ✅ DOWNLOAD & OPEN FILE
  /// ================================
  static Future<void> downloadAndOpenFile({
    required String url,
    required String fileName,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();

      final filePath = "${dir.path}/$fileName";

      print("📥 DOWNLOADING FILE => $filePath");

      await Dio().download(
        url,
        filePath,
      );

      print("✅ FILE DOWNLOADED");

      await OpenFilex.open(filePath);
    } catch (e) {
      print("❌ FILE DOWNLOAD ERROR => $e");
    }
  }
}