import 'package:Gixa/Modules/seatMatrix/model/seat_matrix_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class SeatMatrixService {
  SeatMatrixService._();

  /// 🔹 GET Seat Matrix
  static Future<List<SeatMatrixModel>> getSeatMatrix({
    String? collegeName,
    bool forceRefresh = false,
  }) async {
    final response = await ApiClient.get(
      ApiEndpoints.seatMatrix,
      queryParameters: {
        if (collegeName != null && collegeName.trim().isNotEmpty)
          'college': collegeName.trim(),
      },
      showGlobalNetworkError: false,
      requestPolicy: RequestPolicy(
        ttl: Duration(minutes: 5),
        forceRefresh: forceRefresh,
      ),
    );

    print("📥 SEAT MATRIX RESPONSE: $response");

    /// API structure:
    /// {
    ///   "count": 2,
    ///   "results": [ ... ]
    /// }

    final List results = response['results'] ?? [];

    return results.map((json) => SeatMatrixModel.fromJson(json)).toList();
  }
}
