import 'dart:convert';
import 'package:Gixa/Modules/Collage/model/collage_model.dart';
import 'package:Gixa/Modules/CollageDetails/model/college_cutoff_model.dart';
import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';
import 'package:Gixa/network/app_exception.dart';

class CollegeSearchResult {
  final List<College> colleges;
  final bool hasNextPage;
  final int? count;
  final int? totalPages;

  const CollegeSearchResult({
    required this.colleges,
    required this.hasNextPage,
    this.count,
    this.totalPages,
  });
}

class CollegeApiService {
  Future<List<College>> fetchColleges({bool forceRefresh = false}) async {
    try {
      final response = await ApiClient.get(
        ApiEndpoints.colleges,
        requestPolicy: RequestPolicy(forceRefresh: forceRefresh),
      );

      print("══════════════════════════════════════");
      print("📥 COLLEGE LIST RAW RESPONSE TYPE: ${response.runtimeType}");
      print("📥 COLLEGE LIST RAW RESPONSE: $response");

      final result = _parseCollegeSearchResponse(
        response,
        invalidMessage: "Invalid college list response",
      );

      print("📚 PARSED COLLEGES COUNT: ${result.colleges.length}");

      return result.colleges;
    } catch (e) {
      if (e is AppException) rethrow;

      throw AppException(
        message: "Unable to load college list",
        debugMessage: e.toString(),
      );
    }
  }

  static Future<CollegeSearchResult> searchCollegesPaginated({
    String? search,
    String? city,
    String? state,
    String? mccState,
    String? instituteType,
    String? year,
    String? quota,
    String? round,
    int? minSeats,
    int? maxSeats,
    int page = 1,
    String? courseLevel,
    String? courseName,
    bool forceRefresh = false,
  }) async {
    try {
      final response = await ApiClient.get(
        ApiEndpoints.colleges,
        queryParameters: {
          'page': page,
          if (search != null && search.trim().isNotEmpty)
            'search': search.trim(),
          if (city != null && city.trim().isNotEmpty) 'cities': city.trim(),
          if (state != null && state.trim().isNotEmpty) 'state': state.trim(),
          if (state != null && state.trim().isNotEmpty) 'states': state.trim(),
          if (mccState != null && mccState.trim().isNotEmpty) 'mcc_state': mccState.trim(),
          if (courseLevel != null && courseLevel.trim().isNotEmpty)
            'course_level': courseLevel.trim(),
          if (courseLevel != null && courseLevel.trim().isNotEmpty)
            'course_types': courseLevel.trim(),
          if (courseName != null && courseName.trim().isNotEmpty)
            'courses': courseName.trim(),
          if (instituteType != null && instituteType.trim().isNotEmpty)
            'institute_type': instituteType.trim(),
          if (instituteType != null && instituteType.trim().isNotEmpty)
            'institute_types': instituteType.trim(),
          if (year != null && year.trim().isNotEmpty) 'year': year.trim(),
          if (quota != null && quota.trim().isNotEmpty) 'quota': quota.trim(),
          if (round != null && round.trim().isNotEmpty) 'round': round.trim(),
          if (minSeats != null) 'min_seats': minSeats,
          if (maxSeats != null) 'max_seats': maxSeats,
        },
        requestPolicy: RequestPolicy(forceRefresh: forceRefresh),
      );

      print("══════════════════════════════════════");
      print("🔍 SEARCH COLLEGE RAW RESPONSE TYPE: ${response.runtimeType}");
      print("🔍 SEARCH COLLEGE RAW RESPONSE: $response");

      final result = _parseCollegeSearchResponse(
        response,
        invalidMessage: "Invalid college search response",
      );

      print("🔍 SEARCH RESULT COUNT: ${result.colleges.length}");
      print("🔍 SEARCH HAS NEXT PAGE: ${result.hasNextPage}");

      return result;
    } catch (e) {
      if (e is AppException) rethrow;

      throw AppException(
        message: "Unable to search colleges",
        debugMessage: e.toString(),
      );
    }
  }

  static Future<List<College>> searchColleges({
    String? search,
    String? city,
    String? state,
    String? mccState,
    String? instituteType,
    String? year,
    String? quota,
    String? round,
    int? minSeats,
    int? maxSeats,
    int page = 1,
    String? courseLevel,
    String? courseName,
    bool forceRefresh = false,
  }) async {
    final result = await searchCollegesPaginated(
      search: search,
      city: city,
      state: state,
      mccState: mccState,
      instituteType: instituteType,
      year: year,
      quota: quota,
      round: round,
      minSeats: minSeats,
      maxSeats: maxSeats,
      page: page,
      courseLevel: courseLevel,
      courseName: courseName,
      forceRefresh: forceRefresh,
    );

    return result.colleges;
  }

  Future<CollegeDetail> fetchCollegeDetail(
    int collegeId, {
    bool forceRefresh = false,
  }) async {
    try {
      final response = await ApiClient.get(
        '${ApiEndpoints.college}/$collegeId/',
        requestPolicy: RequestPolicy(forceRefresh: forceRefresh),
      );

      print("══════════════════════════════════════");
      print("📥 COLLEGE DETAIL RAW RESPONSE TYPE: ${response.runtimeType}");
      print("📥 COLLEGE DETAIL RAW RESPONSE: $response");

      if (response is! Map<String, dynamic>) {
        throw AppException(
          message: "Invalid college detail response",
          debugMessage: response.toString(),
        );
      }

      final college = CollegeDetail.fromJson(response);

      print("🏫 COLLEGE DETAIL");
      print("🏫 ID: ${college.id}");
      print("🏫 Name: ${college.name}");
      print("📧 Contact: ${college.contactEmail}");
      print("🌐 Website: ${college.website}");
      print("══════════════════════════════════════");

      return college;
    } catch (e) {
      if (e is AppException) rethrow;

      throw AppException(
        message: "Unable to load college details",
        debugMessage: e.toString(),
      );
    }
  }

  Future<CollegeCategoryCutoffResponse> fetchCollegeCategoryCutoffs(
    int collegeId, {
    required int allIndiaRank,
    int? year,
    int? courseId,
    int? quotaId,
    bool forceRefresh = false,
  }) async {
    try {
      final response = await ApiClient.get(
        '${ApiEndpoints.college}/$collegeId/category-cutoff/',
        queryParameters: {
          'all_india_rank': allIndiaRank,
          if (year != null) 'year': year,
          if (courseId != null) 'course_id': courseId,
          if (quotaId != null) 'quota_id': quotaId,
        },
        requestPolicy: RequestPolicy(forceRefresh: forceRefresh),
      );

      if (response is! Map<String, dynamic>) {
        throw AppException(
          message: 'Invalid cutoff response',
          debugMessage: response.toString(),
        );
      }

      print("══════════════════════════════════════");
      print("📥 CUTOFF RAW RESPONSE:");
      try {
        final encoder = const JsonEncoder.withIndent('  ');
        print(encoder.convert(response));
      } catch (_) {
        print(response);
      }
      print("══════════════════════════════════════");

      return CollegeCategoryCutoffResponse.fromJson(response);
    } catch (e) {
      if (e is AppException) rethrow;

      throw AppException(
        message: 'Unable to load cutoff data',
        debugMessage: e.toString(),
      );
    }
  }

  static CollegeSearchResult _parseCollegeSearchResponse(
    dynamic response, {
    required String invalidMessage,
  }) {
    if (response is List) {
      final colleges = _parseCollegeList(response);
      return CollegeSearchResult(
        colleges: colleges,
        hasNextPage: colleges.isNotEmpty,
      );
    }

    if (response is Map) {
      final map = Map<String, dynamic>.from(response);
      final rawResults = map['results'];

      if (rawResults == null) {
        // GUEST USER EMPTY RESPONSE
        return const CollegeSearchResult(
          colleges: [],
          hasNextPage: false,
          count: 0,
          totalPages: 0,
        );
      }

      if (rawResults is! List) {
        throw AppException(
          message: invalidMessage,
          debugMessage: response.toString(),
        );
      }

      final currentPage = _readInt(map['page']);
      final totalPages = _readInt(map['total_pages']);
      final next = map['next']?.toString();

      return CollegeSearchResult(
        colleges: _parseCollegeList(rawResults),
        hasNextPage:
            (next != null && next.isNotEmpty && next != 'null') ||
            (currentPage != null &&
                totalPages != null &&
                currentPage < totalPages),
        count: _readInt(map['count']),
        totalPages: totalPages,
      );
    }

    throw AppException(
      message: invalidMessage,
      debugMessage: response.toString(),
    );
  }

  static List<College> _parseCollegeList(List rawList) {
    return rawList
        .map((e) => College.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  static int? _readInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
