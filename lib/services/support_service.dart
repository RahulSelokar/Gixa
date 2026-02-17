import 'package:Gixa/Modules/support/model/support_contact_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class SupportService {
  SupportService._();

  static Future<SupportContactModel> getSupportContact() async {
    final response = await ApiClient.get(
     ApiEndpoints.supportContact
    );

    return SupportContactModel.fromJson(response);
  }
}
