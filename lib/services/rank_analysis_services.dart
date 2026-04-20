import 'package:Gixa/Modules/rankAnalysis/model/rank_analysis_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class RankAnalysisApiService {
  RankAnalysisApiService._();

  /// 🔹 GET RANK ANALYSIS FOR COLLEGE
  static Future<RankAnalysisModel?> getRankAnalysis({
    required String collegeCode,
    required String course,
    required String category,
    required int userRank,
  }) async {
    final response = await ApiClient.post(ApiEndpoints.rankAnalysis, {
      "college_code": collegeCode,
      "course": course,
      "category": category,
      "user_rank": userRank,
    });

    if (response['success'] == true) {
      return RankAnalysisModel.fromJson(response['data']);
    }

    return null;
  }
}
