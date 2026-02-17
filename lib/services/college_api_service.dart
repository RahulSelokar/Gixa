import 'package:Gixa/Modules/Collage/model/collage_model.dart';
import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';
import 'package:Gixa/network/app_exception.dart';

class CollegeApiService {
  // ─────────────────────────────────────────────
  // 📚 GET COLLEGE LIST (Basic Info)
  // ─────────────────────────────────────────────
  Future<List<College>> fetchColleges() async {
    try {
      final response = await ApiClient.get(ApiEndpoints.colleges);

      print("══════════════════════════════════════");
      print("📥 COLLEGE LIST RAW RESPONSE TYPE: ${response.runtimeType}");
      print("📥 COLLEGE LIST RAW RESPONSE: $response");

      if (response is! List) {
        throw AppException(
          message: "Invalid college list response",
          debugMessage: response.toString(),
        );
      }

      final colleges = response
          .map((e) => College.fromJson(e as Map<String, dynamic>))
          .toList();

      print("📚 PARSED COLLEGES COUNT: ${colleges.length}");

      return colleges;
    } catch (e) {
      if (e is AppException) rethrow;

      throw AppException(
        message: "Unable to load college list",
        debugMessage: e.toString(),
      );
    }
  }

  // ─────────────────────────────────────────────
  // 🔍 SEARCH & FILTER COLLEGES
  // ─────────────────────────────────────────────
  static Future<List<College>> searchColleges({
    String? search,
    String? state,
    String? instituteType,
    String? year,
    String? quota,
    String? round,
    int? minSeats,
    int? maxSeats,
  }) async {
    try {
      final response = await ApiClient.get(
        ApiEndpoints.colleges,
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (state != null && state.isNotEmpty) 'state': state,
          if (instituteType != null && instituteType.isNotEmpty)
            'institute_type': instituteType,
          if (year != null && year.isNotEmpty) 'year': year,
          if (quota != null && quota.isNotEmpty) 'quota': quota,
          if (round != null && round.isNotEmpty) 'round': round,
          if (minSeats != null) 'min_seats': minSeats,
          if (maxSeats != null) 'max_seats': maxSeats,
        },
      );

      print("══════════════════════════════════════");
      print("🔍 SEARCH COLLEGE RAW RESPONSE TYPE: ${response.runtimeType}");
      print("🔍 SEARCH COLLEGE RAW RESPONSE: $response");

      if (response is! List) {
        throw AppException(
          message: "Invalid college search response",
          debugMessage: response.toString(),
        );
      }

      final colleges = response
          .map((e) => College.fromJson(e as Map<String, dynamic>))
          .toList();

      print("🔍 SEARCH RESULT COUNT: ${colleges.length}");

      return colleges;
    } catch (e) {
      if (e is AppException) rethrow;

      throw AppException(
        message: "Unable to search colleges",
        debugMessage: e.toString(),
      );
    }
  }

  // ─────────────────────────────────────────────
  // 🏫 GET COLLEGE DETAIL (Full Info)
  // ─────────────────────────────────────────────
  Future<CollegeDetail> fetchCollegeDetail(int collegeId) async {
    try {
      final response = await ApiClient.get(
        '${ApiEndpoints.college}/$collegeId/',
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
}
