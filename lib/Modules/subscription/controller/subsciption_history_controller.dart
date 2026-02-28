import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/services/subscription_plan_services.dart';
import 'package:get/get.dart';
import 'package:Gixa/Modules/subscription/model/subscription_history_model.dart';

class SubscriptionHistoryController extends GetxController {
  /// 🔹 Get profile controller
  final ProfileController profileController = Get.find<ProfileController>();

  /// Loading state
  final isLoading = false.obs;

  /// Subscription history list
  final historyList = <SubscriptionHistory>[].obs;

  /// Error message
  final errorMessage = ''.obs;

  bool isPlanActive(int planId) {
  return historyList.any(
    (history) =>
        history.plan.id == planId && history.isActive == true,
  );
}


  /// 🔹 Safe getter for userId
  int? get userId => profileController.profile.value?.user.id;

  @override
  void onInit() {
    super.onInit();

    /// If profile already loaded
    if (userId != null) {
      fetchSubscriptionHistory();
    }

    /// If profile loads later
    ever(profileController.profile, (_) {
      if (userId != null) {
        fetchSubscriptionHistory();
      }
    });
  }

  // ─────────────────────────────────────
  // 📦 FETCH SUBSCRIPTION HISTORY
  // ─────────────────────────────────────
  Future<void> fetchSubscriptionHistory() async {
    final id = userId;

    if (id == null) {
      errorMessage.value = "User not found";
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await SubscriptionApi.getSubscriptionHistory(userId: id);

      /// 🔥 Sort: Active first, newest first
      data.sort((a, b) {
        if (a.isActive && !b.isActive) return -1;
        if (!a.isActive && b.isActive) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });

      historyList.assignAll(data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
