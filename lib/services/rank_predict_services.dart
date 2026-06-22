import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class NeetRankService {
  static Future<Map<String, dynamic>> getRank(int score) async {
    final response = await ApiClient.get(
      ApiEndpoints.neetRankPredictor(score),
    );

    print("📥 RANK API RESPONSE: $response");

    if (response is! Map<String, dynamic>) {
      throw Exception("Invalid response format");
    }

    if (response["success"] != true) {
      throw Exception(response["message"] ?? "Failed to fetch rank");
    }

    return response;
  }
}