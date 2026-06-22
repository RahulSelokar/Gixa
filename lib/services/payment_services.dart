import 'package:Gixa/Modules/payment/model/payment_creandential_model.dart';
import 'package:Gixa/Modules/subscription/model/payment_verification_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class PaymentApiService {
  PaymentApiService._();

  /// 🔹 GET PAYMENT CREDENTIALS (Razorpay)
  static Future<List<PaymentCredentialModel>> getPaymentCredentials({
    bool forceRefresh = false,
  }) async {
    final response = await ApiClient.get(
      ApiEndpoints.paymentCredentials,
      requestPolicy: RequestPolicy(
        ttl: Duration(minutes: 5),
        forceRefresh: forceRefresh,
      ),
    );

    final List data = response['data'];

    return data
        .map((e) => PaymentCredentialModel.fromJson(e))
        .toList();
  }
  static Future<PaymentVerificationModel>
checkPaymentVerification({
  bool forceRefresh = false,
}) async {
  final response = await ApiClient.get(
    ApiEndpoints.appVerification,
    requestPolicy: RequestPolicy(
      ttl: const Duration(minutes: 1),
      forceRefresh: forceRefresh,
    ),
  );

  return PaymentVerificationModel.fromJson(
    response['data'] ?? response,
  );
}
}
