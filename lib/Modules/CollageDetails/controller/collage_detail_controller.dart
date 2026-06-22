import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:Gixa/Modules/seatMatrix/controller/seat_matrix_controller.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:get/get.dart';
import 'package:Gixa/services/college_api_service.dart';
import 'package:Gixa/network/app_exception.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';

class CollegeDetailController extends GetxController {
  final CollegeApiService _service = CollegeApiService();

  /// UI STATES
  final isLoading = true.obs;
  final college = Rxn<CollegeDetail>(); 
  final isFetchingDetails = false.obs; // To track background fetch if needed
  final errorMessage = ''.obs;

  // final selectedTabIndex = 0.obs;
  final selectedTabIndex = 'Overview'.obs;

  @override
  void onInit() async {
    super.onInit();

    final args = Get.arguments;
    final int? collegeId = args is Map ? args['collegeId'] : null;
    final initialCollege = args is Map ? args['college'] : null;

    if (initialCollege != null) {
      college.value = CollegeDetail.fromCollege(initialCollege);
      isLoading.value = false;
    }

    final subscriptionController = Get.find<SubscriptionController>();

    /// 🔥 WAIT for plan
    await subscriptionController.ensureActivePlanReady();

    if (collegeId == null) {
      errorMessage.value = 'Invalid college';
      isLoading.value = false;
      return;
    }

    fetchCollegeDetail(collegeId);
  }

  Future<void> fetchCollegeDetail(int collegeId) async {
    try {
      if (college.value == null) {
        isLoading.value = true;
      }
      isFetchingDetails.value = true;
      errorMessage.value = '';

      final result = await _service.fetchCollegeDetail(collegeId);

      // UG COURSES
      if (result.courses.ug.isNotEmpty) {
        print("ðŸŽ“ UG Courses:");
        for (final ug in result.courses.ug) {
          print("   â€¢ ${ug.name}");
        }
      }

      // PG COURSES
      if (result.courses.pg.isNotEmpty) {
        print("ðŸŽ“ PG Courses:");
        for (final pg in result.courses.pg) {
          print("   â€¢ ${pg.courseName} (${pg.specialtyType})");
        }
      }
      college.value = result;

      final seatController = Get.isRegistered<SeatMatrixController>()
          ? Get.find<SeatMatrixController>()
          : Get.put(SeatMatrixController());

      await seatController.fetchSeatMatrix(
        collegeName: result.name,
        forceRefresh: true,
      );
    } catch (e) {
      if (e is AppException) {
        errorMessage.value = e.message;
        AppSnackbar.show('Error', e.message);
      } else {
        errorMessage.value = 'Something went wrong';
        AppSnackbar.show('Error', errorMessage.value);
      }
    } finally {
      isLoading.value = false;
      isFetchingDetails.value = false;
    }
  }

  void changeTab(String tab) {
    selectedTabIndex.value = tab;
  }

  Future<void> refreshCollegeDetail() async {
    if (college.value != null) {
      await fetchCollegeDetail(college.value!.id);
    }
  }
}
