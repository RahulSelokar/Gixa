import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';
import 'package:Gixa/Modules/predication/model/state_category_model.dart';

class StateCategoryApiService {
  StateCategoryApiService._();

  static Future<List<StateCategoryModel>> getStateCategories({
    required List<String> states,
  }) async {
    try {
      final response = await ApiClient.get(
        "${ApiEndpoints.statewiseAvailability}"
        "?states=${states.join(",")}",
      );

      print("📥 Statewise Categories Response: $response");

      if (response['success'] == true) {
        final List data = response['data'] ?? [];

        return data
            .whereType<Map<String, dynamic>>()
            .map(StateCategoryModel.fromJson)
            .toList();
      }

      return [];
    } catch (e) {
      print("❌ StateCategoryApi Error: $e");
      return [];
    }
  }
}
