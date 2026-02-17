import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class RequestGuidanceService {
  static Future<Map<String, dynamic>> requestGuidance({
    required int counselorId,
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String message,
  }) async {
    final body = {
      "counselor_id": counselorId,
      "first_name": firstName,
      "last_name": lastName,
      "mobile_number": mobileNumber,
      "message": message,
    };

    
    print("══════════════════════════════════════");
    print("📩 REQUEST GUIDANCE API CALL");
    print("👨‍🏫 COUNSELOR ID : $counselorId");
    print("👤 NAME          : $firstName $lastName");
    print("📞 MOBILE        : $mobileNumber");
    print("💬 MESSAGE       : $message");
    print("══════════════════════════════════════");

    final response = await ApiClient.post(
      ApiEndpoints.requestGuidance,
      body,
    );

   
    print("📬 RESPONSE: $response");
    print("══════════════════════════════════════");

    return response;
  }
}
