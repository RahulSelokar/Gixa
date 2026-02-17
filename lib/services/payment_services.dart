import 'package:Gixa/Modules/payment/model/payment_creandential_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class PaymentApiService {
  PaymentApiService._();

  /// 🔹 GET PAYMENT CREDENTIALS (Razorpay)
  static Future<List<PaymentCredentialModel>> getPaymentCredentials() async {
    final response = await ApiClient.get(
      ApiEndpoints.paymentCredentials,
    );

    final List data = response['data'];

    return data
        .map((e) => PaymentCredentialModel.fromJson(e))
        .toList();
  }
}
