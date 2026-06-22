import 'dart:async';

import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:Gixa/Modules/subscription/model/subscription_history_model.dart';
import 'package:Gixa/services/subscription_plan_services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SubscriptionHistoryController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();
  final GetStorage _box = GetStorage();

  final isLoading = false.obs;
  final historyList = <SubscriptionHistory>[].obs;
  final errorMessage = ''.obs;

  Future<void>? _loadFuture;

  String get _cacheKey => 'subscription_history_${userId ?? 'unknown'}';

  bool isPlanActive(int planId) {
    for (final history in historyList) {
      if (history.plan.id == planId && history.isActive && !history.isExpired) {
        return true;
      }
    }
    return false;
  }

  bool hasActiveRegularPlan() {
    for (final history in historyList) {
      if (history.isActive && !history.isExpired && !history.plan.isAddon) {
        return true;
      }
    }
    return false;
  }

  bool hasActiveAddonPlan() {
    for (final history in historyList) {
      if (history.isActive && !history.isExpired && history.plan.isAddon) {
        return true;
      }
    }
    return false;
  }

  int? get userId => profileController.profile.value?.user.id;

  Future<void> ensureLoaded({bool forceRefresh = false}) async {
    await profileController.ensureLoaded(force: forceRefresh);

    final id = userId;
    if (id == null) {
      errorMessage.value = "User not found";
      historyList.clear();
      return;
    }

    final inFlight = _loadFuture;
    if (!forceRefresh && inFlight != null) {
      return inFlight;
    }

    final future = fetchSubscriptionHistory(
      userId: id,
      forceRefresh: forceRefresh,
    );
    _loadFuture = future;

    try {
      await future;
    } finally {
      if (identical(_loadFuture, future)) {
        _loadFuture = null;
      }
    }
  }

  Future<void> fetchSubscriptionHistory({
    int? userId,
    bool forceRefresh = false,
  }) async {
    final id = userId ?? this.userId;

    if (id == null) {
      errorMessage.value = "User not found";
      historyList.clear();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await SubscriptionApi.getSubscriptionHistory(
        userId: id,
        forceRefresh: forceRefresh,
      );

      data.sort((a, b) {
        if (a.isActive && !b.isActive) return -1;
        if (!a.isActive && b.isActive) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });

      historyList.assignAll(data);
      _box.write(_cacheKey, data.map((item) => item.toJson()).toList());
    } catch (e) {
      final cached = _readCachedHistory();
      if (cached.isNotEmpty) {
        historyList.assignAll(cached);
        errorMessage.value = '';
      } else {
        final errStr = e.toString().toLowerCase();
        
        if (errStr.contains('socketexception') || errStr.contains('timeout')) {
          errorMessage.value = 'Network error. Please check your connection.';
        } else {
          historyList.clear();
          errorMessage.value = '';
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  List<SubscriptionHistory> _readCachedHistory() {
    final raw = _box.read(_cacheKey);
    if (raw is! List) return <SubscriptionHistory>[];

    return raw
        .whereType<Map>()
        .map(
          (item) =>
              SubscriptionHistory.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}
