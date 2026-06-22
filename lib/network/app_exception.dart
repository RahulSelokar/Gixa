class AppException implements Exception {
  final String message;
  final String? debugMessage;
  final int? statusCode;
  final Map<String, dynamic>? errors;
  final bool isNetworkError;

  AppException({
    required this.message,
    this.debugMessage,
    this.statusCode,
    this.errors,
    this.isNetworkError = false,
  });

  @override
  String toString() => message;
}
