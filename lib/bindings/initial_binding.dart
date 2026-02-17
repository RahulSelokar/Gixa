import 'package:get/get.dart';
import 'package:Gixa/routes/app_start_controller.dart';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import '../utils/themes/theme_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    /// 🌍 Global app controllers (permanent)
    Get.put(ThemeController(), permanent: true);
    Get.put(AppStartController(), permanent: true);

    /// 👤 Profile controller (shared across pages)
    Get.put(ProfileController(), permanent: true);
  }
}
