import 'package:Gixa/Modules/Assistance/model/counselor_model.dart';
import 'package:Gixa/Modules/Assistance/model/couselor_details_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class CounselorService {
  /// 🔹 GET COUNSELOR LIST FOR ASSISTANCE REQUEST
  static Future<List<Counselor>> fetchCounselors({
    required String requestId,
  }) async {
    final response = await ApiClient.get(
      ApiEndpoints.assistanceCounselors,
      queryParameters: {
        "request_id": requestId,
      },
    );

    return (response['counselors'] as List)
        .map((e) => Counselor.fromJson(e))
        .toList();
  }

  /// 🔹 SELECT COUNSELOR
  static Future<void> selectCounselor({
    required String requestId,
    required int counselorId,
  }) async {
    await ApiClient.post(
      ApiEndpoints.selectCounselor,
      {
        "request_id": requestId,
        "counselor_id": counselorId,
      },
    );
  }

  /// 🔹 GET COUNSELOR DETAIL (NEW ✅)
  static Future<CounselorDetail> fetchCounselorDetail({
    required int counselorId,
  }) async {
    final response = await ApiClient.get(
      '${ApiEndpoints.counselorDetail}/$counselorId/',
    );

    return CounselorDetail.fromJson(response['counselor']);
  }
}
