import 'package:Gixa/Modules/comparison/model/save_compare_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class SaveCompareService {
  static Future<SaveCompareResponse> saveComparison(
    List<String> collegeCodes,
  ) async {
    final response = await ApiClient.post(
      ApiEndpoints.saveCompareColleges,
      {
        "college_codes": collegeCodes,
      },
    );

    return SaveCompareResponse.fromJson(response);
  }
}
