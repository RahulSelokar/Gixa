import 'package:Gixa/services/rank_analysis_services.dart';
import 'package:get/get.dart';
import '../model/rank_analysis_model.dart';

class RankAnalysisController extends GetxController {
  /// Loading State
  var isLoading = false.obs;

  /// Rank Analysis Data
  Rxn<RankAnalysisModel> rankAnalysis = Rxn<RankAnalysisModel>();

  /// Fetch Rank Analysis
  Future<void> fetchRankAnalysis({
    required String collegeCode,
    required String course,
    required String category,
    required int userRank,
  }) async {
    try {
      isLoading.value = true;

      final result = await RankAnalysisApiService.getRankAnalysis(
        collegeCode: collegeCode,
        course: course,
        category: category,
        userRank: userRank,
      );

      if (result != null) {
        rankAnalysis.value = result;
      }
    } catch (e) {
      print("Rank Analysis Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
