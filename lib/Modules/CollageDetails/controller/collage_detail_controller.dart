import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:get/get.dart';
import 'package:Gixa/services/college_api_service.dart';
import 'package:Gixa/network/app_exception.dart';

class CollegeDetailController extends GetxController {
  final CollegeApiService _service = CollegeApiService();

  /// UI STATES
  final isLoading = false.obs;
  final college = Rxn<CollegeDetail>(); // ✅ Changed from College to CollegeDetail
  final errorMessage = ''.obs;

  final selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    final int? collegeId = args is Map ? args['collegeId'] : null;

    if (collegeId == null) {
      errorMessage.value = 'Invalid college';
      print("❌ COLLEGE DETAIL ERROR: collegeId missing in arguments");
      return;
    }

    fetchCollegeDetail(collegeId);
  }

  // ─────────────────────────────────────────────
  // 🏫 FETCH COLLEGE DETAIL
  // ─────────────────────────────────────────────
  Future<void> fetchCollegeDetail(int collegeId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _service.fetchCollegeDetail(collegeId);

      /// ✅ CONTROLLER-LEVEL LOG
      print("══════════════════════════════════════");
      print("🏫 COLLEGE DETAIL LOADED");
      print("🏫 ID: ${result.id}");
      print("🏫 Name: ${result.name}");
      print("📍 State: ${result.state.name}");
      print("🏛 Institute Type: ${result.instituteType.name}");
      print("📅 Established: ${result.yearEstablished}");
      print("🏨 Hostel Available: ${result.hostelAvailable}");
      print("🏨 Hostel For: ${result.hostelFor}");
      
      // ✅ NEW: Log additional detail fields
      print("🌐 Website: ${result.website}");
      print("📹 Video URL: ${result.videoUrl}");
      print("📍 Address: ${result.address}");
      print("👤 Contact: ${result.contactName} (${result.contactDesignation})");
      print("📧 Email: ${result.contactEmail}");
      print("📱 Mobile: ${result.contactMobile}");

      // UG COURSES
      if (result.courses.ug.isNotEmpty) {
        print("🎓 UG Courses:");
        for (final ug in result.courses.ug) {
          print("   • ${ug.name}");
        }
      }

      // PG COURSES
      if (result.courses.pg.isNotEmpty) {
        print("🎓 PG Courses:");
        for (final pg in result.courses.pg) {
          print("   • ${pg.courseName} (${pg.specialtyType})");
        }
      }

      print("══════════════════════════════════════");

      /// ✅ UPDATE UI
      college.value = result;
    } catch (e) {
      if (e is AppException) {
        errorMessage.value = e.message;
        print("❌ COLLEGE DETAIL ERROR: ${e.debugMessage ?? e.message}");
        Get.snackbar('Error', e.message);
      } else {
        errorMessage.value = 'Something went wrong';
        print("❌ UNKNOWN ERROR: $e");
        Get.snackbar('Error', errorMessage.value);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // 📑 TAB SELECTION
  // ─────────────────────────────────────────────
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  // ─────────────────────────────────────────────
  // 🔄 REFRESH COLLEGE DETAIL
  // ─────────────────────────────────────────────
  Future<void> refreshCollegeDetail() async {
    if (college.value != null) {
      await fetchCollegeDetail(college.value!.id);
    }
  }
}