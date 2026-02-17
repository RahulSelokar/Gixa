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
  /// ✅ OTP VERIFY SUCCESS (IMPORTANT FIX)
  if (json.containsKey('is_registered')) {
    return ApiResponse<T>(
      success: true,
      message: json['message'] ?? 'OTP verified',
      data: fromJson(json),
    );
  }

  /// ✅ OTHER SUCCESS CASES
  if (json.containsKey('token') ||
      json.containsKey('otp') ||
      json.containsKey('student')) {
    return ApiResponse<T>(
      success: true,
      message: json['message'] ?? 'Success',
      data: fromJson(json),
    );
  }

  /// ❌ ERROR CASE (OTP expired, invalid, etc.)
  if (json.containsKey('non_field_errors')) {
    return ApiResponse<T>(
      success: false,
      message: (json['non_field_errors'] as List).first.toString(),
      data: null,
    );
  }

  /// ❌ GENERIC FAILURE
  return ApiResponse<T>(
    success: false,
    message: json['message'] ?? 'Something went wrong',
    data: null,
  );
}
}