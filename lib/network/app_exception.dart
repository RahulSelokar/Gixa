class AppException implements Exception {
  final String message;
  final String? debugMessage;
    final int? statusCode;

  

  AppException({
    required this.message,
    this.debugMessage,
    this.statusCode
  });

  @override
  String toString() => message;
}
