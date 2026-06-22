import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';
import 'package:Gixa/Modules/predication/model/state_category_model.dart';

class StateCategoryApiService {
  StateCategoryApiService._();

  static Future<List<StateCategoryModel>> getStateCategories({
    List<String>? states,
    bool showGlobalNetworkError = true,
    bool forceRefresh = false,
  }) async {
    try {
      final requestedStates = (states ?? const <String>[])
          .map((state) => state.trim())
          .where((state) => state.isNotEmpty)
          .toList();
      final endpoint = requestedStates.isEmpty
          ? ApiEndpoints.statewiseAvailability
          : "${ApiEndpoints.statewiseAvailability}"
                "?states=${requestedStates.join(",")}";

      final response = await ApiClient.get(
        endpoint,
        showGlobalNetworkError: showGlobalNetworkError,
        requestPolicy: RequestPolicy(
          ttl: Duration(minutes: 5),
          forceRefresh: forceRefresh,
        ),
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
