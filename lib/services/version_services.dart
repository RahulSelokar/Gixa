import 'package:Gixa/Modules/version/model/version_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class VersionService {
  VersionService._();

  static Future<VersionModel> checkVersion({
    required String platform,
    required String currentVersion,
  }) async {

    final response = await ApiClient.post(
      ApiEndpoints.versionCheck,
      {
        "platform": platform,
        "current_version": currentVersion,
      },
    );

    print("📥 VERSION RESPONSE: $response");

    return VersionModel.fromJson(response);
  }
}