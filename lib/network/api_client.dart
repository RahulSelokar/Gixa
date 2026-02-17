import 'dart:io';
import 'package:Gixa/common/api.dart';
import 'package:Gixa/network/api_endpoints.dart';
import 'package:Gixa/services/logout_services.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:Gixa/services/token_services.dart';
import 'package:Gixa/network/app_exception.dart';

class ApiClient {
  ApiClient._();

  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {'Accept': 'application/json'},
          ),
        )
        ..interceptors.add(CookieManager(CookieJar()))
        ..interceptors.add(
          InterceptorsWrapper(
            // onRequest: (options, handler) async {
            //   final token = await TokenService.getAccessToken();

            //   if (token != null &&
            //       token.isNotEmpty &&
            //       _requiresAuth(options.path)) {
            //     options.headers['Authorization'] = 'Bearer $token';
            //   }

            //   return handler.next(options);
            // },
            onRequest: (options, handler) async {
              final token = await TokenService.getAccessToken();

              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }

              options.headers['Accept'] = 'application/json';

              return handler.next(options);
            },

            onError: (error, handler) async {
              final statusCode = error.response?.statusCode;

              if (statusCode == 401) {
                print("⚠️ 401 DETECTED → CLEARING TOKENS");

                await TokenService.clearTokens();
                await Future.delayed(const Duration(milliseconds: 200));
                await SessionService.forceLogout();

                return;
              }

              return handler.next(error);
            },
          ),
        );

  // ─────────────────────────────────────────────
  // 🔐 AUTH RULES
  // ─────────────────────────────────────────────
  static bool _requiresAuth(String endpoint) {
    return endpoint != ApiEndpoints.sendOtp &&
        endpoint != ApiEndpoints.verifyOtp &&
        endpoint != ApiEndpoints.googleLogin &&
        endpoint != ApiEndpoints.registerStudent;
  }

  // ─────────────────────────────────────────────
  // POST JSON
  // ─────────────────────────────────────────────
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      print("🚀 API CALL → GET $endpoint");

      // final token = await TokenService.getAccessToken();

      // final requestHeaders = {
      //   'Content-Type': 'application/json',
      //   if (_requiresAuth(endpoint) && token != null && token.isNotEmpty)
      //     'Authorization': 'Bearer $token',
      //   if (headers != null) ...headers,
      // };

      final response = await _dio.post(
        endpoint,
        data: body,
        options: headers != null ? Options(headers: headers) : null,
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print("❌ FAILED → $endpoint");
      print("❌ STATUS → ${e.response?.statusCode}");
      print("❌ DATA → ${e.response?.data}");
      _handleDioError(e);
    }
  }

  // ─────────────────────────────────────────────
  // POST JSON (ALLOW 409)
  // ─────────────────────────────────────────────
  static Future<Map<String, dynamic>> postAllow409(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      // final token = await TokenService.getAccessToken();

      // final requestHeaders = {
      //   'Content-Type': 'application/json',
      //   if (_requiresAuth(endpoint) && token != null && token.isNotEmpty)
      //     'Authorization': 'Bearer $token',
      //   if (headers != null) ...headers,
      // };

      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(headers: headers, validateStatus: (_) => true),
      );
      print("══════════════════════════════");
      print("🚀 postAllow409 CALLED");
      print("📍 ENDPOINT: $endpoint");
      print("📤 REQUEST BODY: $body");
      print("📥 STATUS CODE: ${response.statusCode}");
      print("📥 RESPONSE DATA: ${response.data}");
      print("══════════════════════════════");

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return Map<String, dynamic>.from(response.data);
      }

      // 🔥 Extract proper error message
      String errorMessage = "Request failed (${response.statusCode})";

      if (response.data is Map) {
        final data = response.data as Map;

        if (data['message'] != null) {
          errorMessage = data['message'];
        } else if (data['non_field_errors'] != null &&
            data['non_field_errors'] is List &&
            data['non_field_errors'].isNotEmpty) {
          errorMessage = data['non_field_errors'][0];
        } else if (data.values.isNotEmpty) {
          errorMessage = data.values.first.toString();
        }
      }

      throw AppException(message: errorMessage);
    } on DioException catch (e) {
      print("❌ FAILED → $endpoint");
      print("❌ STATUS → ${e.response?.statusCode}");
      print("❌ DATA → ${e.response?.data}");
      throw AppException(message: "Network error", debugMessage: e.message);
    }
  }

  // ─────────────────────────────────────────────
  // PUT JSON
  // ─────────────────────────────────────────────
  static Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      // final token = await TokenService.getAccessToken();

      // final requestHeaders = {
      //   'Content-Type': 'application/json',
      //   if (_requiresAuth(endpoint) && token != null && token.isNotEmpty)
      //     'Authorization': 'Bearer $token',
      //   if (headers != null) ...headers,
      // };

      final response = await _dio.put(
        endpoint,
        data: body,
        options: headers != null ? Options(headers: headers) : null,
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // ─────────────────────────────────────────────
  // POST FORM
  // ─────────────────────────────────────────────
  static Future<Map<String, dynamic>> postForm(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      // ✅ Convert Map → FormData
      final formData = FormData.fromMap(body);

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(headers: {...?headers}),
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // ─────────────────────────────────────────────
  // POST MULTIPART
  // ─────────────────────────────────────────────
  static Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required File file,
    required String fileFieldName,
    required Map<String, dynamic> fields,
  }) async {
    try {
      final token = await TokenService.getAccessToken();

      final formData = FormData.fromMap({
        ...fields,
        fileFieldName: await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final headers = {
        'Content-Type': 'multipart/form-data',
        if (_requiresAuth(endpoint) && token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
      };

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: headers != null ? Options(headers: headers) : null,
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  //delete Method

  // ─────────────────────────────────────────────
  // DELETE JSON (WITH BODY SUPPORT)
  // ─────────────────────────────────────────────
  static Future<dynamic> delete(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: body, // ✅ DELETE with request body
        options: headers != null ? Options(headers: headers) : null,
      );

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // ─────────────────────────────────────────────
  // ✅ UPDATED GET (NOW SUPPORTS QUERY PARAMETERS)
  // ─────────────────────────────────────────────
  static Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  static Future<Map<String, dynamic>> putMultipart(
    String endpoint, {
    required Map<String, dynamic> fields,
  }) async {
    try {
      final token = await TokenService.getAccessToken();

      final formData = FormData.fromMap(fields);

      final headers = {
        if (_requiresAuth(endpoint) && token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
        // ❌ DO NOT set Content-Type manually
      };

      final response = await _dio.put(
        endpoint,
        data: formData,
        options: headers != null ? Options(headers: headers) : null,
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  //Put Multipart With file
  static Future<Map<String, dynamic>> putMultipartWithFile(
    String endpoint, {
    required File file,
    required String fileFieldName,
    required Map<String, dynamic> fields,
  }) async {
    try {
      final token = await TokenService.getAccessToken();

      final formData = FormData.fromMap({
        ...fields,
        fileFieldName: await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await _dio.put(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            if (_requiresAuth(endpoint) && token != null)
              'Authorization': 'Bearer $token',
          },
        ),
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // ─────────────────────────────────────────────
  // ❌ ERROR HANDLER
  // ─────────────────────────────────────────────
  static Never _handleDioError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    // 🔴 FILE TOO LARGE
    if (status == 413) {
      throw AppException(
        message: "File size is too large. Please upload a smaller file.",
        debugMessage: e.message,
      );
    }
    print("STATUS CODE: $status");
    print("RESPONSE DATA: $data");

    // 🔴 VALIDATION ERROR (400)
    if (status == 400 && data is Map) {
      final firstValue = data.values.first;

      if (firstValue is List && firstValue.isNotEmpty) {
        throw AppException(message: firstValue.first.toString());
      }

      throw AppException(message: data['message'] ?? "Invalid request data.");
    }

    // 🔴 UNAUTHORIZED
    if (status == 401) {
      throw AppException(message: "Session expired. Please login again.");
    }

    // 🔴 FORBIDDEN
    if (status == 403) {
      throw AppException(
        message: "You don’t have permission to perform this action.",
      );
    }

    // 🔴 METHOD NOT ALLOWED
    if (status == 405) {
      throw AppException(message: "Request method not allowed.");
    }

    // 🔴 SERVER ERROR
    if (status != null && status >= 500) {
      throw AppException(message: "Server error. Please try again later.");
    }

    // 🔴 NETWORK ERROR
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw AppException(
        message: "Network error. Please check your internet connection.",
      );
    }

    // 🔴 DEFAULT
    throw AppException(
      message: "Something went wrong. Please try again.",
      debugMessage: e.message,
    );
  }
}
