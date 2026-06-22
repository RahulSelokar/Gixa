import 'dart:async';
import 'dart:io';

import 'package:Gixa/common/api.dart';

class NetworkReachability {
  NetworkReachability._();

  static const Duration _timeout = Duration(seconds: 5);

  static Future<bool> canReachBackend({int maxRetries = 3}) async {
    final uri = Uri.parse(ApiConstants.baseUrl);
    final port = uri.hasPort ? uri.port : (uri.scheme == 'https' ? 443 : 80);

    for (int i = 0; i < maxRetries; i++) {
      Socket? socket;
      try {
        socket = await Socket.connect(uri.host, port, timeout: _timeout);
        return true;
      } on SocketException {
        // Ignore and retry
      } on TimeoutException {
        // Ignore and retry
      } catch (e) {
        // Ignore other errors and retry
      } finally {
        socket?.destroy();
      }

      if (i < maxRetries - 1) {
        await Future.delayed(const Duration(milliseconds: 1500));
      }
    }
    return false;
  }
}
