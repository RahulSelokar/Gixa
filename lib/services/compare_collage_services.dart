import 'package:Gixa/Modules/comparison/model/college_compare_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class CollegeCompareService {
  static Future<CollegeCompareResponse> compareColleges(
    List<String> collegeCodes,
  ) async {
    final payload = {
      "college_codes": collegeCodes,
    };

    print('📡 COMPARE API PAYLOAD 👉 $payload');
    print('📡 PAYLOAD TYPES 👉 ${collegeCodes.map((e) => e.runtimeType).toList()}');

    final response = await ApiClient.post(
      ApiEndpoints.compareColleges,
      payload,
    );

    print('📥 RAW API RESPONSE 👉 $response');

    return CollegeCompareResponse.fromJson(response);
  }
}
