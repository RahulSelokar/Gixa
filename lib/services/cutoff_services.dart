import 'package:Gixa/Modules/cutoff/model/cutoff_graph_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class AirComparisonApiService {
  AirComparisonApiService._();

  static Future<AirComparisonModel?> getAirComparison({
    required int air,
    required String state,
    required String category,
    required String course,
    required String quota,
  }) async {
    final response = await ApiClient.get(
      "${ApiEndpoints.airComparison}"
      "?air=$air"
      "&state=$state"
      "&category=$category"
      "&course=$course"
      "&quota=$quota",
    );

    if (response['status'] == "success") {
      return AirComparisonModel.fromJson(response);
    }

    return null;
  }
}