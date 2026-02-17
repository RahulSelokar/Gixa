import 'package:Gixa/Modules/register/model/register_request.dart';
import 'package:Gixa/commonmodels/category_model.dart';
import 'package:Gixa/commonmodels/course_model.dart';
import 'package:Gixa/commonmodels/specialty_model.dart';
import 'package:Gixa/commonmodels/state_model.dart';
import 'package:Gixa/network/app_exception.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/routes/app_start_controller.dart';
import 'package:Gixa/services/register_master_api.dart';
import 'package:Gixa/services/register_services.dart';
import 'package:Gixa/services/token_services.dart';
import 'package:get/get.dart';

/// 🔽 COURSE LEVEL ENUM
enum CourseLevel { ug, pg }

/// 🔽 COURSE TYPE ENUM
enum CourseType { clinical, nonClinical, paraClinical }

class RegisterController extends GetxController {
  /// 🔄 REGISTER STATE
  final isLoading = false.obs;
  final RegisterApiService _service = RegisterApiService();

  /// 🔄 MASTER LOADING
  final isMasterLoading = false.obs;
  final RegisterMasterApi _masterApi = RegisterMasterApi();

  /// 🔽 MASTER DATA
  final states = <StateModel>[].obs;
  final categories = <CategoryModel>[].obs;

  /// 🔽 COURSES (LEVEL → TYPE)
  final ugCourses = <String, List<CourseModel>>{}.obs;
  final pgCourses = <String, List<CourseModel>>{}.obs;

  /// 🔽 SELECTED VALUES
  final selectedState = Rx<StateModel?>(null);
  final selectedCategory = Rx<CategoryModel?>(null);
  final selectedCourseLevel = Rx<CourseLevel?>(null);
  final selectedCourseType = Rx<CourseType?>(null);
  final selectedCourse = Rx<CourseModel?>(null);
  final selectedSpecialty = Rx<SpecialtyModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadMasters();
  }

  // ───────────────────────── LOAD MASTER DATA ─────────────────────────

  Future<void> loadMasters() async {
    try {
      isMasterLoading.value = true;

      final data = await _masterApi.fetchMasters();

      states.assignAll(data['states']);
      categories.assignAll(data['categories']);

      ugCourses.assignAll(
        Map<String, List<CourseModel>>.from(data['courses']['UG']),
      );

      pgCourses.assignAll(
        Map<String, List<CourseModel>>.from(data['courses']['PG']),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dropdown data');
    } finally {
      isMasterLoading.value = false;
    }
  }

  // ───────────────────────── COURSE HELPERS ─────────────────────────

  Map<String, List<CourseModel>> get _currentLevelCourses {
    if (selectedCourseLevel.value == CourseLevel.ug) {
      return ugCourses;
    } else if (selectedCourseLevel.value == CourseLevel.pg) {
      return pgCourses;
    }
    return {};
  }

  List<CourseModel> get coursesByType {
    final key = switch (selectedCourseType.value) {
      CourseType.clinical => 'clinical',
      CourseType.nonClinical => 'non_clinical',
      CourseType.paraClinical => 'para_clinical',
      _ => null,
    };

    if (key == null) return [];
    return _currentLevelCourses[key] ?? [];
  }

  void onCourseLevelSelected(CourseLevel level) {
    if (selectedCourseLevel.value == level) return;

    selectedCourseLevel.value = level;
    selectedCourseType.value = null;
    selectedCourse.value = null;
    selectedSpecialty.value = null;
  }

  void onCourseTypeSelected(CourseType type) {
    if (selectedCourseType.value == type) return;

    selectedCourseType.value = type;
    selectedCourse.value = null;
    selectedSpecialty.value = null;
  }

  void onCourseSelected(CourseModel course) {
    selectedCourse.value = course;
    selectedSpecialty.value = null;
  }

  bool get isDropdownValid =>
      selectedState.value != null &&
      selectedCategory.value != null &&
      selectedCourseLevel.value != null &&
      selectedCourseType.value != null &&
      selectedCourse.value != null &&
      selectedSpecialty.value != null;

  // ───────────────────────── REGISTER USER ─────────────────────────

  Future<void> register(RegisterStudentRequest request) async {
    if (isLoading.value) return; // 🛑 prevent double tap

    try {
      isLoading.value = true;

      final data = await _service.registerStudent(request);

      await TokenService.saveTokens(
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
      );

      /// 🚀 NAVIGATE FIRST
      Get.offAllNamed(AppRoutes.mainNav);

      /// 🧠 Do background work AFTER navigation
      Future.microtask(() async {
        final appStart = Get.find<AppStartController>();
        await appStart.registrationCompleted();
        await TokenService.printTokens(); // optional
      });
    } catch (e) {
      if (e is AppException) {
        Get.snackbar('Failed', e.message);
      } else {
        Get.snackbar('Error', e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }
}
