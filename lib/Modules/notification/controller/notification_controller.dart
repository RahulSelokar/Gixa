import 'dart:async';
import 'package:Gixa/Modules/notification/model/student_notification_model.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';
import 'package:Gixa/network/app_exception.dart';
import 'package:Gixa/services/student_notification_service.dart';
import 'package:Gixa/services/notification_service.dart';
import 'package:Gixa/services/notification_action_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {

  final notifications = <StudentNotification>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final notificationCount = 0.obs;
  final hasLoaded = false.obs;
  bool _refreshQueued = false;

  Timer? _notificationTimer;
  final GetStorage _box = GetStorage();
  final Set<int> _readNotificationIds = <int>{};
  final Set<int> _shownNotificationIds = <int>{};

  bool get hasNotifications => notificationCount.value > 0;

  String get notificationBadgeLabel =>
      notificationCount.value > 99 ? '99+' : notificationCount.value.toString();

  @override
  void onInit() {
    super.onInit();
    
    _restoreReadNotificationIds();

    /// 🔥 INITIAL FETCH
    fetchNotifications();

    /// 🔄 AUTO REFRESH EVERY 1 MINUTE
    _notificationTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      debugPrint("🔄 AUTO REFRESH NOTIFICATIONS");

      fetchNotifications();
    });
  }

  @override
  void onClose() {
    _notificationTimer?.cancel();

    super.onClose();
  }

  Future<void> fetchNotifications({
    bool forceRefresh = false,

    bool showErrorSnackbar = false,
  }) async {
    if (isLoading.value) {
      _refreshQueued = true;
      return;
    }

    try {
      isLoading.value = true;

      errorMessage.value = '';

      debugPrint("🔔 FETCHING NOTIFICATIONS...");

      final isInitialFetch = !hasLoaded.value;

      /// 🔥 OLD IDS
      final oldIds = notifications.map((e) => e.id).toList();

      final response = await StudentNotificationService.fetchNotifications(
        forceRefresh: forceRefresh,
      );

      debugPrint("✅ TOTAL ALERTS: ${response.results.length}");

      final visibleResults = response.results;

      /// 🔥 PRINT ALL ALERTS
      for (final item in visibleResults) {
        debugPrint("📢 ALERT => ${item.title}");

        debugPrint("🏷 SOURCE => ${item.source}");

        debugPrint("🔗 LINK => ${item.link}");
      }

      /// 🔥 UPDATE LIST
      notifications.assignAll(visibleResults);
      
      // Update the objects locally based on the stored read ids
      for (int i = 0; i < notifications.length; i++) {
        if (_readNotificationIds.contains(notifications[i].id)) {
          final n = notifications[i];
          notifications[i] = StudentNotification(
            id: n.id, source: n.source, sourceUrl: n.sourceUrl, title: n.title,
            body: n.body, link: n.link, attachment: n.attachment, createdAt: n.createdAt,
            isRead: true,
          );
        }
      }

      _updateUnreadCount();

      hasLoaded.value = true;

      _shownNotificationIds.addAll(response.results.map((e) => e.id));

      /// 🔔 SHOW POPUP FOR NEW ALERTS
      if (isInitialFetch) {
        debugPrint("🔕 SKIPPING POPUPS ON INITIAL FETCH");
        return;
      }

      for (final item in response.results) {
        final isNew = !oldIds.contains(item.id);
        final hasNotBeenShown = !_shownNotificationIds.contains(item.id);

        if (isNew && hasNotBeenShown) {
          debugPrint("🔥 NEW NOTIFICATION FOUND => ${item.title}");

          await NotificationService.showAlertNotification(
            id: item.id,

            title: item.title.isNotEmpty ? item.title : item.bodyText,

            body: item.source.isNotEmpty ? item.source : '',

            payload: item.link,
          );

          debugPrint("✅ LOCAL NOTIFICATION SHOWN");
        }
      }
    } on AppException catch (e) {
      errorMessage.value = e.message;

      debugPrint("❌ APP EXCEPTION => ${e.message}");

      if (showErrorSnackbar) {
        AppSnackbar.show('Error', e.message);
      }
    } catch (e) {
      errorMessage.value = 'Failed to load notifications';

      debugPrint("❌ UNKNOWN ERROR => $e");

      if (showErrorSnackbar) {
        AppSnackbar.show('Error', errorMessage.value);
      }
    } finally {
      isLoading.value = false;

      if (_refreshQueued) {
        _refreshQueued = false;
        unawaited(
          fetchNotifications(
            forceRefresh: true,
            showErrorSnackbar: showErrorSnackbar,
          ),
        );
      }

      debugPrint("🏁 NOTIFICATION FETCH COMPLETE");
    }
  }

  Future<void> refreshNotifications() async {
    debugPrint("🔄 MANUAL REFRESH TRIGGERED");

    await fetchNotifications(forceRefresh: true, showErrorSnackbar: true);
  }

  void markAsRead(int notificationId) async {
    try {
      await NotificationActionService.markAsRead(notificationId);
    } catch (e) {
      debugPrint("Failed to mark as read: $e");
    }
    
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      final n = notifications[index];
      notifications[index] = StudentNotification(
        id: n.id, source: n.source, sourceUrl: n.sourceUrl, title: n.title,
        body: n.body, link: n.link, attachment: n.attachment, createdAt: n.createdAt,
        isRead: true,
      );
    }
    
    _readNotificationIds.add(notificationId);
    _persistReadNotificationIds();
    
    _updateUnreadCount();
    notifications.refresh();
  }

  void markAllAsRead() async {
    try {
      await NotificationActionService.markAllAsRead();
    } catch (e) {
      debugPrint("Failed to mark all as read: $e");
    }
    
    for (int i = 0; i < notifications.length; i++) {
      final n = notifications[i];
      if (!n.isRead) {
        notifications[i] = StudentNotification(
          id: n.id, source: n.source, sourceUrl: n.sourceUrl, title: n.title,
          body: n.body, link: n.link, attachment: n.attachment, createdAt: n.createdAt,
          isRead: true,
        );
        _readNotificationIds.add(n.id);
      }
    }
    
    _persistReadNotificationIds();
    _updateUnreadCount();
    notifications.refresh();
  }

  void deleteNotification(int notificationId) async {
    try {
      await NotificationActionService.deleteNotification(notificationId);
    } catch (e) {
      debugPrint("Failed to delete notification: $e");
    }
    _readNotificationIds.remove(notificationId);
    _persistReadNotificationIds();
    notifications.removeWhere((item) => item.id == notificationId);
    _updateUnreadCount();
    notifications.refresh();
  }

  void deleteAllNotifications() async {
    try {
      await NotificationActionService.deleteAllNotifications();
    } catch (e) {
      debugPrint("Failed to delete all notifications: $e");
    }
    notifications.clear();
    _readNotificationIds.clear();
    _persistReadNotificationIds();
    notificationCount.value = 0;
    _updateDeviceBadge(0);
    notifications.refresh();
  }

  void deleteReadNotifications() async {
    try {
      await NotificationActionService.deleteReadNotifications();
    } catch (e) {
      debugPrint("Failed to delete read notifications: $e");
    }
    notifications.removeWhere((item) => item.isRead);
    _readNotificationIds.clear();
    _persistReadNotificationIds();
    _updateUnreadCount();
    notifications.refresh();
  }

  void _updateUnreadCount() {
    final unreadCount = notifications
        .where((n) => !n.isRead)
        .length;
    notificationCount.value = unreadCount;
    _updateDeviceBadge(unreadCount);
  }

  void _updateDeviceBadge(int count) {
    if (count > 0) {
      FlutterAppBadgeControl.updateBadgeCount(count);
    } else {
      FlutterAppBadgeControl.removeBadge();
    }
  }

  void _restoreReadNotificationIds() {
    final rawIds = _box.read('student_read_notification_ids');
    if (rawIds is List) {
      _readNotificationIds.addAll(rawIds.whereType<int>().toSet());

      for (final item in rawIds) {
        final parsed = int.tryParse(item.toString());
        if (parsed != null) {
          _readNotificationIds.add(parsed);
        }
      }
    }
  }

  void _persistReadNotificationIds() {
    _box.write('student_read_notification_ids', _readNotificationIds.toList());
  }
}
