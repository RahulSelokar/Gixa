import 'package:Gixa/Modules/Profile/models/profile_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class ProfileService {
  ProfileService._();

  /// 🔹 GET PROFILE
  static Future<ProfileModel> getProfile() async {
    final response = await ApiClient.get(
      ApiEndpoints.profile, // change if endpoint differs
    );
    print("📥 PROFILE RESPONSE: $response");

    return ProfileModel.fromJson(response);
  }
}
