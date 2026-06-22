class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic data) fromJson,
  ) {
    if (json.containsKey('is_registered')) {
      return ApiResponse<T>(
        success: true,
        message: json['message'] ?? 'OTP verified',
        data: fromJson(json),
      );
    }

    if (json.containsKey('token') ||
        json.containsKey('otp') ||
        json.containsKey('student')) {
      return ApiResponse<T>(
        success: true,
        message: json['message'] ?? 'Success',
        data: fromJson(json),
      );
    }

    if (json.containsKey('error_code')) {
      return ApiResponse<T>(
        success: false,
        message: json['message'] ?? 'Request failed',
        data: fromJson(json),
      );
    }

    if (json.containsKey('non_field_errors')) {
      return ApiResponse<T>(
        success: false,
        message: (json['non_field_errors'] as List).first.toString(),
        data: null,
      );
    }

    return ApiResponse<T>(
      success: false,
      message: json['message'] ?? 'Something went wrong',
      data: null,
    );
  }
}
