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
    final queryParameters = <String, dynamic>{
      'air': air,
      'state': state,
      'category': category,
      'course': course,
      'quota': quota,
    };

    final url = ApiEndpoints.airComparison;

    print('========== AIR COMPARISON API REQUEST ==========');
    print('Endpoint: $url');
    print('Query parameters: $queryParameters');
    print('================================================');

    try {
      final response = await ApiClient.get(
        url,
        queryParameters: queryParameters,
      );

      print('========== AIR COMPARISON API RESPONSE ==========');
      print('Response body: $response');
      print('=================================================');

      if (response['status'] == 'success') {
        final model = AirComparisonModel.fromJson(response);

        print('========== AIR COMPARISON PARSED DATA ==========');
        print('================================================');

        return model;
      }

      print('❌ AIR COMPARISON API FAILED');
      print('Backend response: $response');
      return null;
    } catch (error) {
      print('❌ AIR COMPARISON API ERROR');
      print('Sent query parameters: $queryParameters');
      print('Error: $error');
      return null;
    }
  }
}
