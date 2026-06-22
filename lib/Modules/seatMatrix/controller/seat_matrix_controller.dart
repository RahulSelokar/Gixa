import 'package:Gixa/Modules/seatMatrix/model/seat_matrix_model.dart';
import 'package:Gixa/services/seat_matrix_services.dart';
import 'package:get/get.dart';

class SeatMatrixController extends GetxController {
  /// Loading State
  var isLoading = false.obs;

  /// All Seat Data
  var seatList = <SeatMatrixModel>[].obs;

  /// Quick Lookup Map (college name -> seat list)
  final Map<String, List<SeatMatrixModel>> _seatMap = {};

  /// Fetch API
  Future<void> fetchSeatMatrix({
    String? collegeName,
    bool forceRefresh = false,
  }) async {
    try {
      isLoading.value = true;

      final data = await SeatMatrixService.getSeatMatrix(
        collegeName: collegeName,
        forceRefresh: forceRefresh,
      );

      seatList.assignAll(data);
      _seatMap
        ..clear()
        ..addEntries(_groupSeatsByCollege(data).entries);
    } catch (e) {
      print("Seat Matrix Error: $e");
      seatList.clear();
      _seatMap.clear();
    } finally {
      isLoading.value = false;
    }
  }

  List<SeatMatrixModel> getSeatsForCollege(String collegeName) {
    return List<SeatMatrixModel>.from(
      _seatMap[_normalizeCollegeName(collegeName)] ?? const [],
    );
  }

  int getTotalSeats(String collegeName) {
    final collegeSeats = getSeatsForCollege(collegeName);
    if (collegeSeats.isEmpty) return 0;

    return collegeSeats.fold(0, (sum, seat) => sum + seat.totalSeats);
  }

  int getSeatsByYear(String collegeName, int year) {
    final collegeSeats = getSeatsForCollege(collegeName);
    if (collegeSeats.isEmpty) return 0;

    final yearData = collegeSeats.where((seat) => seat.year == year).toList();
    return yearData.fold(0, (sum, seat) => sum + seat.totalSeats);
  }

  List<CategorySeat> getCategories(String collegeName) {
    final collegeSeats = getSeatsForCollege(collegeName);
    if (collegeSeats.isEmpty) {
      return [];
    }

    collegeSeats.sort((a, b) => b.year.compareTo(a.year));
    return collegeSeats.first.categories;
  }

  Map<String, List<SeatMatrixModel>> _groupSeatsByCollege(
    List<SeatMatrixModel> data,
  ) {
    final grouped = <String, List<SeatMatrixModel>>{};

    for (final seat in data) {
      final collegeKey = _normalizeCollegeName(seat.collegeName);
      grouped.putIfAbsent(collegeKey, () => []);
      grouped[collegeKey]!.add(seat);
    }

    return grouped;
  }

  String _normalizeCollegeName(String collegeName) {
    return collegeName.trim().toLowerCase();
  }
}
