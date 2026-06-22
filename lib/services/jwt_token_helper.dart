import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

enum JwtTokenState { missing, valid, expired, malformed }

class JwtTokenInspection {
  const JwtTokenInspection({
    required this.label,
    required this.state,
    this.error,
  });

  final String label;
  final JwtTokenState state;
  final Object? error;

  bool get hasToken => state != JwtTokenState.missing;
  bool get isValid => state == JwtTokenState.valid;
  bool get isExpired => state == JwtTokenState.expired;
  bool get isMalformed => state == JwtTokenState.malformed;
}

class JwtTokenHelper {
  const JwtTokenHelper._();

  static JwtTokenInspection inspect(String? token, {String label = 'token'}) {
    final normalizedToken = token?.trim() ?? '';
    if (normalizedToken.isEmpty) {
      return JwtTokenInspection(label: label, state: JwtTokenState.missing);
    }

    try {
      final isExpired = JwtDecoder.isExpired(normalizedToken);
      return JwtTokenInspection(
        label: label,
        state: isExpired ? JwtTokenState.expired : JwtTokenState.valid,
      );
    } catch (error, stackTrace) {
      debugPrint('[JwtTokenHelper] Failed to inspect $label: $error');
      debugPrintStack(stackTrace: stackTrace);
      return JwtTokenInspection(
        label: label,
        state: JwtTokenState.malformed,
        error: error,
      );
    }
  }
}
