import 'dart:convert';

import 'package:Gixa/Modules/comparison/model/college_compare_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class CollegeCompareService {
  static Future<CollegeCompareResponse> compareColleges(
    List<String> collegeCodes,
  ) async {
    final codes = collegeCodes.map((code) => code.toString()).toList();
    final payload = {
      "college_codes": codes,
    };

    print('📡 COMPARE API PAYLOAD 👉 $payload');
    print('📡 COMPARE API JSON 👉 ${jsonEncode(payload)}');
    print('📡 PAYLOAD TYPES 👉 ${codes.map((e) => e.runtimeType).toList()}');

    final response = await ApiClient.post(
      ApiEndpoints.compareColleges,
      payload,
    );

    print('📥 RAW API RESPONSE 👉 $response');

    return CollegeCompareResponse.fromJson(response);
  }
}
