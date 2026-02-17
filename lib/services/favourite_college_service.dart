import 'package:Gixa/Modules/favourite/model/fevorite_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class FavouriteCollegeService {
  FavouriteCollegeService._();

  static Future<void> addToFavourite(int collegeId) async {
    await ApiClient.post(
      ApiEndpoints.addToFavourite,
      {"college_id": collegeId},
    );
  }

  static Future<void> removeFromFavourite(int collegeId) async {
    await ApiClient.delete(
      ApiEndpoints.removeFromFavourite,
      {"college_id": collegeId},
    );
  }

  static Future<List<FavouriteCollege>> getFavouriteColleges() async {
    final response = await ApiClient.get(ApiEndpoints.favourite);

    final data = response is List ? response : response['data'];

    if (data is! List) {
      throw Exception('Invalid favourite colleges response');
    }

    return data
        .map<FavouriteCollege>(
          (e) => FavouriteCollege.fromJson(e),
        )
        .toList();
  }
}
