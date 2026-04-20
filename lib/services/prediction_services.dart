// import 'package:Gixa/Modules/predication/model/predication_model.dart';
// import 'package:Gixa/network/api_client.dart';
// import 'package:Gixa/network/api_endpoints.dart';

// class PredictionService {
//   static Future<PredictionData> fetchPrediction(
//     Map<String, dynamic> requestBody,
//   ) async {
//     final rawResponse = await ApiClient.post(
//       ApiEndpoints.predictCollege,
//       requestBody,
//     );

//     print("📥 RAW RESPONSE: $rawResponse");

//     if (rawResponse is! Map<String, dynamic>) {
//       // throw Exception("Invalid API response format");
//       return PredictionData.fromApiResponse(rawResponse);
//     }

//     /// ✅ SUCCESS (Govt Colleges)
//     if (rawResponse["success"] == true) {
//       final List list = rawResponse["data"] ?? [];

//       final colleges = list.map((e) => CollegeModel.fromApiJson(e)).toList();

//       return PredictionData(
//         noChanceInHomeState: false,
//         totalCount: rawResponse["total_colleges"] ?? colleges.length,
//         predictionId: null,
//         inputSummary: InputSummary.empty(),
//         collegeList: colleges,
//       );
//     }

//     /// ⚠️ PRIVATE SUGGESTION CASE
//     if (rawResponse["suggestion_type"] == "private_college") {
//       final List list = rawResponse["data"] ?? [];

//       final colleges = list
//           .map((e) => CollegeModel.fromSuggestionJson(e))
//           .toList();

//       return PredictionData(
//         noChanceInHomeState: true,
//         totalCount: colleges.length,
//         predictionId: null,
//         inputSummary: InputSummary.empty(),
//         collegeList: colleges,
//       );
//     }

//     throw Exception(rawResponse["message"] ?? "Prediction failed");
//   }
// }


import 'package:Gixa/Modules/predication/model/predication_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class PredictionService {
  static Future<PredictionData> fetchPrediction(
    Map<String, dynamic> requestBody,
  ) async {
    final rawResponse = await ApiClient.post(
      ApiEndpoints.predictCollege,
      requestBody,
    );

    print("📥 RAW RESPONSE: $rawResponse");

    /// ✅ SAFETY CHECK
    if (rawResponse is! Map<String, dynamic>) {
      throw Exception("Invalid API response format");
    }

    return PredictionData.fromApiResponse(rawResponse);
  }
}