import 'package:Gixa/Modules/faq/model/faq_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class FaqApiService {
  FaqApiService._();

  /// 🔹 GET FAQ LIST
  static Future<List<FaqItem>> getFaqs({
    String search = "",
    bool forceRefresh = false,
  }) async {
    final response = await ApiClient.get(
      ApiEndpoints.faq,
      queryParameters: {
        "search": search,
      },
      requestPolicy: RequestPolicy(
        ttl: Duration(minutes: 5),
        forceRefresh: forceRefresh,
      ),
    );

    /// FIXED STRUCTURE
    final List data = response['data']['faqs'];

    return data.map((e) => FaqItem.fromJson(e)).toList();
  }
}
