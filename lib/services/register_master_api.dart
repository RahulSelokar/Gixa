import 'package:Gixa/commonmodels/category_model.dart';
import 'package:Gixa/commonmodels/course_model.dart';
import 'package:Gixa/commonmodels/quata_model.dart';
import 'package:Gixa/commonmodels/round_model.dart';
import 'package:Gixa/commonmodels/state_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class RegisterMasterApi {
  Future<Map<String, dynamic>> fetchMasters({
    bool showGlobalNetworkError = true,
    bool forceRefresh = false,
  }) async {
    final response = await ApiClient.get(
      ApiEndpoints.masters,
      showGlobalNetworkError: showGlobalNetworkError,
      requestPolicy: RequestPolicy(
        ttl: Duration(minutes: 5),
        forceRefresh: forceRefresh,
      ),
    );

    /// 🔹 STATES
    final List<StateModel> states = (response['states'] as List<dynamic>? ?? [])
        .map((e) => StateModel.fromJson(e))
        .toList();

    /// 🔹 CATEGORIES
    final List<CategoryModel> categories =
        (response['categories'] as List<dynamic>? ?? [])
            .map((e) => CategoryModel.fromJson(e))
            .toList();

    /// 🔹 QUOTAS
    final List<QuotaModel> quotas = (response['quotas'] as List<dynamic>? ?? [])
        .map((e) => QuotaModel.fromJson(e))
        .toList();

    /// 🔹 ✅ ROUNDS (NEW)
    final List<RoundModel> rounds =
        (response['rounds'] as List<dynamic>? ?? [])
            .map((e) => RoundModel.fromJson(e))
            .where((e) => e.isActive) // optional but recommended
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order)); // sort by order

    /// 🔹 COURSES
    final Map<String, dynamic> coursesResponse =
        response['courses'] as Map<String, dynamic>? ?? {};

    final Map<String, Map<String, List<CourseModel>>> courses = {
      'UG': _parseCourseLevel(coursesResponse['UG']),
      'PG': _parseCourseLevel(coursesResponse['PG']),
    };
    final List<CourseModel> coursesForUg =
        (response['courses_for_ug'] as List<dynamic>? ?? [])
            .map((e) => CourseModel.fromJson(e))
            .toList();
    final statewiseCities = _parseStatewiseCities(response['statewise_cities']);

    return {
      'states': states,
      'categories': categories,
      'quotas': quotas,
      'rounds': rounds,
      'courses': courses,
      'courses_for_ug': coursesForUg,

      /// STATEWISE CATEGORY
      'statewise_categories': response['statewise_categories'],

      /// HORIZONTAL RESERVATIONS
      'statewise_horizontal_categories':
          response['statewise_horizontal_categories'],

      /// STATEWISE CITIES
      'statewise_cities': statewiseCities,
      'mcc_statewise_city_summary': response['mcc_statewise_city_summary'],
    };
  }

  /// 🔁 Helper to parse UG / PG structure
  Map<String, List<CourseModel>> _parseCourseLevel(dynamic levelData) {
    if (levelData == null || levelData is! Map<String, dynamic>) {
      return {'clinical': [], 'non_clinical': [], 'para_clinical': []};
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

  Map<String, List<String>> _parseStatewiseCities(dynamic rawData) {
    final items =
        (rawData as Map<String, dynamic>?)?['data'] as List<dynamic>? ??
        const [];
    final statewiseCities = <String, List<String>>{};

    for (final item in items) {
      if (item is! Map<String, dynamic>) continue;

      final stateName = (item['state'] ?? '').toString().trim();
      if (stateName.isEmpty) continue;

      final seen = <String>{};
      final cities = <String>[];

      for (final city in item['cities'] as List<dynamic>? ?? const []) {
        final cleanedCity = _cleanCityName(city, stateName);
        if (cleanedCity == null) continue;

        final normalizedCity = _normalizeLookup(cleanedCity);
        if (seen.add(normalizedCity)) {
          cities.add(cleanedCity);
        }
      }

      cities.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

      if (cities.isNotEmpty) {
        statewiseCities[stateName] = cities;
      }
    }

    return statewiseCities;
  }

  String? _cleanCityName(dynamic rawValue, String stateName) {
    var value = rawValue?.toString().trim() ?? '';
    if (value.isEmpty) return null;

    value = value.replaceFirst(RegExp(r'^[,\s]+'), '').trim();
    if (value.isEmpty || value.contains('@')) return null;

    if (value.contains(',')) {
      value = value.split(',').first.trim();
    }

    value = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (value.isEmpty) return null;

    final normalizedValue = _normalizeLookup(value);
    if (normalizedValue.isEmpty || normalizedValue == 'none') return null;
    if (normalizedValue == _normalizeLookup(stateName)) return null;

    return value;
  }

  String _normalizeLookup(String value) => value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
