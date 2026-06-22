import 'package:Gixa/Modules/cutoff/model/state_wise_distribution_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class StateWiseDistributionService {
  StateWiseDistributionService._();

  static Future<StateWiseDistributionModel?> getStateWiseDistribution({
    required int air,
    required String course,
  }) async {
    final queryParameters = <String, dynamic>{
      'air': air,
      'course': course,
    };

    final url = ApiEndpoints.stateWiseRankDistribution;

    print('========== STATE WISE DISTRIBUTION API REQUEST ==========');
    print('Endpoint: $url');
    print('Query parameters: $queryParameters');
    print('========================================================');

    try {
      final response = await ApiClient.get(
        url,
        queryParameters: queryParameters,
      );

      print('========== STATE WISE DISTRIBUTION API RESPONSE ==========');
      print('Response body: $response');
      print('==========================================================');

      if (response != null && response is Map<String, dynamic>) {
        final model = StateWiseDistributionModel.fromJson(response);
        return model;
      }

      print('❌ STATE WISE DISTRIBUTION API FAILED');
      return null;
    } catch (error) {
      print('❌ STATE WISE DISTRIBUTION API ERROR');
      print('Error: $error');
      return null;
    }
  }
}
