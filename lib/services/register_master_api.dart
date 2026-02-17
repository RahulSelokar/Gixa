import 'package:Gixa/commonmodels/category_model.dart';
import 'package:Gixa/commonmodels/course_model.dart';
import 'package:Gixa/commonmodels/state_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class RegisterMasterApi {
  Future<Map<String, dynamic>> fetchMasters() async {
    final response = await ApiClient.get(ApiEndpoints.masters);

    /// 🔹 STATES
    final List<StateModel> states =
        (response['states'] as List<dynamic>? ?? [])
            .map((e) => StateModel.fromJson(e))
            .toList();

    /// 🔹 CATEGORIES
    final List<CategoryModel> categories =
        (response['categories'] as List<dynamic>? ?? [])
            .map((e) => CategoryModel.fromJson(e))
            .toList();

    /// 🔹 COURSES (UG + PG)
    final Map<String, dynamic> coursesResponse =
        response['courses'] as Map<String, dynamic>? ?? {};

    final Map<String, Map<String, List<CourseModel>>> courses = {
      'UG': _parseCourseLevel(coursesResponse['UG']),
      'PG': _parseCourseLevel(coursesResponse['PG']),
    };

    return {
      'states': states,
      'categories': categories,
      'courses': courses,
    };
  }

  /// 🔁 Helper to parse UG / PG structure
  Map<String, List<CourseModel>> _parseCourseLevel(
    dynamic levelData,
  ) {
    if (levelData == null || levelData is! Map<String, dynamic>) {
      return {
        'clinical': [],
        'non_clinical': [],
        'para_clinical': [],
      };
    }

    return {
      'clinical': (levelData['clinical'] as List<dynamic>? ?? [])
          .map((e) => CourseModel.fromJson(e))
          .toList(),

      'non_clinical': (levelData['non_clinical'] as List<dynamic>? ?? [])
          .map((e) => CourseModel.fromJson(e))
          .toList(),

      'para_clinical': (levelData['para_clinical'] as List<dynamic>? ?? [])
          .map((e) => CourseModel.fromJson(e))
          .toList(),
    };
  }
}
