import 'package:Gixa/Modules/Assistance/model/request_guidance_model.dart';
import 'package:Gixa/Modules/subscription/model/subscription_plan.dart';
import 'package:Gixa/Modules/subscription/utils/plan_hierarchy.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';
import 'package:Gixa/services/auth_guard.dart';
import 'package:Gixa/services/request_guidance_service.dart';
import 'package:Gixa/services/subscription_plan_services.dart';
import 'package:get/get.dart';

class GuidanceRequestsController extends GetxController {
  final RxList<GuidanceRequestItem> requests = <GuidanceRequestItem>[].obs;
  final RxList<SubscriptionPlan> plans = <SubscriptionPlan>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPlansLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<SubscriptionPlan> selectedPlan = Rxn<SubscriptionPlan>();

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final hasSession = await AuthGuard.hasValidSession();
    if (hasSession) {
      await fetchRequests();
    } else {
      requests.clear();
      errorMessage.value = '';
    }

    await fetchPlans();
  }

  Future<void> fetchRequests() async {
    final hasSession = await AuthGuard.hasValidSession();
    if (!hasSession) {
      requests.clear();
      errorMessage.value = '';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await RequestGuidanceService.fetchGuidanceRequests();
      requests.assignAll(data);
    } catch (e) {
      errorMessage.value = e.toString();
      AppSnackbar.show(
        'Error',
        'Unable to load guidance requests',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPlans({bool forceRefresh = false}) async {
    try {
      isPlansLoading.value = true;

      final data = await SubscriptionApi.getPlans(forceRefresh: forceRefresh);
      data.sort((a, b) {
        // 1. Regular plans always before add-on plans
        final aIsAddon = a.isAddon;
        final bIsAddon = b.isAddon;
        if (aIsAddon != bIsAddon) return aIsAddon ? 1 : -1;

        // 2. Within same group, sort by tier (basic → classic → premium → unknown)
        //    Plans whose name/code don't match a known tier keyword resolve to
        //    PlanTier.free (index 0). We remap index 0 → 999 so that
        //    "Round Wise" and similar plans go AFTER the known tiers instead of first.
        int _effectiveTier(int rawIndex) => rawIndex == 0 ? 999 : rawIndex;

        final tierA = _effectiveTier(
          PlanHierarchy.getTierFromPlan(
            planCode: a.planCode,
            planName: a.planName,
          ).index,
        );
        final tierB = _effectiveTier(
          PlanHierarchy.getTierFromPlan(
            planCode: b.planCode,
            planName: b.planName,
          ).index,
        );
        if (tierA != tierB) return tierA.compareTo(tierB);

        // 3. Recommended plans first within same tier
        if (a.isRecommended == b.isRecommended) return 0;
        return a.isRecommended ? -1 : 1;
      });

      plans.assignAll(data);

      if (selectedPlan.value == null && data.isNotEmpty) {
        selectedPlan.value = data.first;
      }
    } catch (e) {
      AppSnackbar.show(
        'Plans Unavailable',
        'Unable to load subscription plans right now.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isPlansLoading.value = false;
    }
  }

  Future<GuidanceRequestItem> fetchRequestDetail(int requestId) {
    return RequestGuidanceService.fetchGuidanceRequestDetail(
      requestId: requestId,
    );
  }

  void selectPlan(SubscriptionPlan plan) {
    selectedPlan.value = plan;
  }
}
