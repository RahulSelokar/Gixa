import 'package:Gixa/Modules/Assistance/model/request_guidance_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class RequestGuidanceService {
  static Future<RequestGuidanceResponse> requestGuidance({
    int? counselorId,
    int? subscriptionPlanId,
    String? subscriptionPlanName,
    String? subscriptionPlanCode,
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String message,
    required String email,
  }) async {
    final body = <String, dynamic>{
      if (counselorId != null) "counselor_id": counselorId,
      if (subscriptionPlanId != null) "subscription_plan_id": subscriptionPlanId,
      if (subscriptionPlanName != null && subscriptionPlanName.trim().isNotEmpty)
        "subscription_plan_name": subscriptionPlanName.trim(),
      if (subscriptionPlanCode != null && subscriptionPlanCode.trim().isNotEmpty)
        "subscription_plan_code": subscriptionPlanCode.trim(),
      "first_name": firstName,
      "last_name": lastName,
      "mobile_number": mobileNumber,
      "message": message,
      "email": email,
    };

    
    print("══════════════════════════════════════");
    print("📩 REQUEST GUIDANCE API CALL");
    print("👨‍🏫 COUNSELOR ID : $counselorId");
    print("📦 PLAN ID       : $subscriptionPlanId");
    print("📦 PLAN NAME     : ${subscriptionPlanName ?? ''}");
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

    return RequestGuidanceResponse.fromJson(response);
  }

  static Future<List<GuidanceRequestItem>> fetchGuidanceRequests() async {
    final response = await ApiClient.get(ApiEndpoints.requestGuidance);
    final data = response['data'];

    if (data is! List) {
      return <GuidanceRequestItem>[];
    }

    return data
        .map((item) => GuidanceRequestItem.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  static Future<GuidanceRequestItem> fetchGuidanceRequestDetail({
    required int requestId,
  }) async {
    final response = await ApiClient.get(
      '${ApiEndpoints.requestGuidance}$requestId/',
    );
    final data = response['data'];

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid guidance request detail response');
    }

    return GuidanceRequestItem.fromJson(Map<String, dynamic>.from(data));
  }
}
