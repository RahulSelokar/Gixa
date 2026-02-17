
import 'package:dio/dio.dart';
import 'package:Gixa/Modules/updateProfile/model/update_profile.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class UpdateProfileService {
  UpdateProfileService._();

  /// 🔹 UPDATE PROFILE (PUT - MULTIPART)
  static Future<UpdateProfileResponse> updateProfile(
    UpdateProfileRequest request,
  ) async {
    /// 1️⃣ Prepare normal fields (NO FILES)
    final Map<String, dynamic> fields = request.toJson();

    /// 2️⃣ Attach profile image ONLY if selected
    if (request.profilePicture != null) {
      fields['profile_picture'] = await MultipartFile.fromFile(
        request.profilePicture!.path,
        filename: request.profilePicture!.path.split('/').last,
      );
    }

    /// 3️⃣ Call MULTIPART PUT API
    final Map<String, dynamic> response =
        await ApiClient.putMultipart(
      ApiEndpoints.profile, 
      fields: fields,
    );

    /// 4️⃣ Parse response
    return UpdateProfileResponse.fromJson(response);
  }
}
