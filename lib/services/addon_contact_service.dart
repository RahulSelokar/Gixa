import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';
import 'package:Gixa/Modules/addon_contact/model/addon_contact_model.dart';

class AddonContactService {
  static Future<AddonContactModel> getAddonContact() async {
    final response = await ApiClient.get(ApiEndpoints.addonContact);
    return AddonContactModel.fromJson(response);
  }
}
