import 'package:Gixa/Modules/predication/model/predication_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class PredictionService {

  /// 🔹 GET COLLEGE PREDICTION
  static Future<PredictionData> fetchPrediction({
    required int allIndiaRank,
    required String category,
    required String course,
    required int year,
    required String state,
    required String quota,
    required String counsellingRound,
  }) async {

    final rawResponse = await ApiClient.post(
      ApiEndpoints.predictCollege,
      {
        "all_india_rank": allIndiaRank,
        "category": category,
        "course": course,
        "year": year,
        "state": state,
        "quota": quota,
        "counselling_round": counsellingRound,
      },
    );

    print("🔎 RAW API RESPONSE: $rawResponse");

    /// --------------------------------------------------------
    /// HANDLE DIFFERENT RESPONSE STRUCTURES SAFELY
    /// --------------------------------------------------------

    Map<String, dynamic> response;

    if (rawResponse is Map<String, dynamic>) {
      response = rawResponse;
    } else {
      throw Exception("Invalid API response format");
    }

    /// Case 1: Normal structure
    /// {
    ///   "success": true,
    ///   "data": { ... }
    /// }
    if (response.containsKey('success')) {

      if (response['success'] == true) {

        final data = response['data'];

        if (data is Map<String, dynamic>) {
          final parsed = PredictionData.fromJson(data);

          print("✅ SAFE COUNT: ${parsed.safeColleges.length}");
          print("✅ MODERATE COUNT: ${parsed.moderateColleges.length}");
          print("✅ AMBITIOUS COUNT: ${parsed.ambitiousColleges.length}");
          print("✅ NO CUTOFF COUNT: ${parsed.noCutoffColleges.length}");

          return parsed;
        } else {
          throw Exception("Invalid data format inside response");
        }

      } else {
        throw Exception(response['message'] ?? "Prediction API failed");
      }
    }

    /// Case 2: Wrapped inside another "data"
    /// {
    ///   "data": {
    ///       "success": true,
    ///       "data": { ... }
    ///   }
    /// }
    if (response.containsKey('data') &&
        response['data'] is Map<String, dynamic> &&
        response['data']['success'] == true) {

      final innerData = response['data']['data'];

      if (innerData is Map<String, dynamic>) {
        final parsed = PredictionData.fromJson(innerData);

        print("✅ SAFE COUNT: ${parsed.safeColleges.length}");

        return parsed;
      } else {
        throw Exception("Invalid nested data format");
      }
    }

    throw Exception("Prediction API failed - Unknown structure");
  }
}