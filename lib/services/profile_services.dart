import 'package:Gixa/Modules/Profile/models/profile_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class ProfileService {
  ProfileService._();

  /// 🔹 GET PROFILE
  static Future<ProfileModel> getProfile({
    bool showGlobalNetworkError = true,
    bool forceRefresh = false,
  }) async {
    final response = await ApiClient.get(
      ApiEndpoints.profile, // change if endpoint differs
      showGlobalNetworkError: showGlobalNetworkError,
      requestPolicy: RequestPolicy(
        ttl: Duration(seconds: 15),
        forceRefresh: forceRefresh,
      ),
    );
    print("📥 PROFILE RESPONSE: $response");

    return ProfileModel.fromJson(response);
  }

  static Future<void> deleteProfileImage() async {
    try {
      final response = await ApiClient.delete(
        ApiEndpoints.removeProfileImage,
        {}
      
      );

      print("🗑️ DELETE IMAGE RESPONSE: $response");
    } catch (e) {
      print("❌ DELETE IMAGE ERROR: $e");
      rethrow;
    }
  }
}
