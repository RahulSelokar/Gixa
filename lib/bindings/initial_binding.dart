import 'package:Gixa/common/Error/error_controller.dart';
import 'package:get/get.dart';
import 'package:Gixa/routes/app_start_controller.dart';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/subscription/controller/subscription_controller.dart';
import 'package:Gixa/services/app_verification_controller.dart';
import '../utils/themes/theme_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {

    /// 🌍 Global app controllers (permanent)
    Get.put(ThemeController(), permanent: true);
    Get.put(AppStartController(), permanent: true);
    Get.put(AppVerificationController(), permanent: true);

    /// 👤 Profile controller (shared across pages)
    Get.put(ProfileController(), permanent: true);
    Get.put(SubscriptionController(), permanent: true);

    /// 🌐 GLOBAL ERROR CONTROLLER (NEW)
    Get.put(GlobalErrorController(), permanent: true);
  }
}
