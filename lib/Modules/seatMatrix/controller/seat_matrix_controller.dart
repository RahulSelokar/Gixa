import 'package:Gixa/Modules/seatMatrix/model/seat_matrix_model.dart';
import 'package:Gixa/services/seat_matrix_services.dart';
import 'package:get/get.dart';

class SeatMatrixController extends GetxController {

  /// 🔄 Loading State
  var isLoading = false.obs;

  /// 📦 All Seat Data
  var seatList = <SeatMatrixModel>[].obs;

  /// 🗂 Quick Lookup Map (collegeId → seat list)
  final Map<int, List<SeatMatrixModel>> _seatMap = {};

  @override
  void onInit() {
    fetchSeatMatrix();
    super.onInit();
  }

  /// 🔥 Fetch API
  Future<void> fetchSeatMatrix() async {
    try {
      isLoading.value = true;

      final data = await SeatMatrixService.getSeatMatrix();
      seatList.assignAll(data);

      /// Group by collegeId
      _seatMap.clear();
      for (var seat in data) {
        if (!_seatMap.containsKey(seat.collegeId)) {
          _seatMap[seat.collegeId] = [];
        }
        _seatMap[seat.collegeId]!.add(seat);
      }

    } catch (e) {
      print("❌ Seat Matrix Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🎯 Get Total Seats For College (All Years Combined)
  int getTotalSeats(int collegeId) {
    final collegeSeats = _seatMap[collegeId];
    if (collegeSeats == null) return 0;

    return collegeSeats.fold(
      0,
      (sum, seat) => sum + seat.totalSeats,
    );
  }

  /// 📊 Get Seats For Specific Year
  int getSeatsByYear(int collegeId, int year) {
    final collegeSeats = _seatMap[collegeId];
    if (collegeSeats == null) return 0;

    final yearData = collegeSeats
        .where((seat) => seat.year == year)
        .toList();

    return yearData.fold(
      0,
      (sum, seat) => sum + seat.totalSeats,
    );
  }

  /// 📌 Get Category-wise Seats (For Latest Year)
  List<CategorySeat> getCategories(int collegeId) {
    final collegeSeats = _seatMap[collegeId];
    if (collegeSeats == null || collegeSeats.isEmpty) {
      return [];
    }

    /// Example: return latest year data
    collegeSeats.sort((a, b) => b.year.compareTo(a.year));
    return collegeSeats.first.categories;
  }
}