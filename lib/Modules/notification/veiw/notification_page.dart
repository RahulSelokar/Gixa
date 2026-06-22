import 'package:Gixa/Modules/notification/controller/notification_controller.dart';
import 'package:Gixa/Modules/notification/model/student_notification_model.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';
import 'package:Gixa/Modules/notification/veiw/notification_search_delegate.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  final NotificationController controller =
      Get.isRegistered<NotificationController>()
      ? Get.find<NotificationController>()
      : Get.put(NotificationController());

  static const Color _kPrimaryBlue = kHomeAccentColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FD);
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111111);
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: textColor,
          ),
        ),
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textColor),
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NotificationSearchDelegate(
                  notifications: controller.notifications,
                  primaryColor: _kPrimaryBlue,
                  itemBuilder: (notification) {
                    return _NotificationCard(
                      notification: notification,
                      onMarkAsRead: () =>
                          controller.markAsRead(notification.id),
                      onDelete: () =>
                          controller.deleteNotification(notification.id),
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      borderColor: borderColor,
                      isRead: notification.isRead,
                    );
                  },
                ),
              );
            },
          ),
          Obx(() {
            final hasNotifications = controller.notifications.isNotEmpty;
            return PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) {
                if (value == 'mark_all_read') {
                  controller.markAllAsRead();
                } else if (value == 'delete_read') {
                  controller.deleteReadNotifications();
                } else if (value == 'delete_all') {
                  controller.deleteAllNotifications();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                if (hasNotifications)
                  PopupMenuItem<String>(
                    value: 'mark_all_read',
                    child: Text(
                      'Mark all as read',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    ),
                  ),
                PopupMenuItem<String>(
                  value: 'delete_read',
                  child: Text(
                    'Delete read notifications',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete_all',
                  child: Text(
                    'Delete all notifications',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: _kPrimaryBlue),
          );
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.notifications.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshNotifications,
            color: _kPrimaryBlue,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.72,
                  child: _NotificationPlaceholder(
                    icon: Icons.wifi_off_rounded,
                    title: 'Unable to load notifications',
                    message: controller.errorMessage.value,
                    textColor: textColor,
                    subTextColor: subTextColor,
                    actionLabel: 'Retry',
                    onPressed: controller.refreshNotifications,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.notifications.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshNotifications,
            color: _kPrimaryBlue,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.72,
                  child: _NotificationPlaceholder(
                    icon: Icons.notifications_none_rounded,
                    title: 'No notifications yet',
                    message: 'New alerts and updates will appear here.',
                    textColor: textColor,
                    subTextColor: subTextColor,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNotifications,
          color: _kPrimaryBlue,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _NotificationCard(
              notification: controller.notifications[i],
              onMarkAsRead: () {
                controller.markAsRead(controller.notifications[i].id);
              },
              onDelete: () {
                controller.deleteNotification(controller.notifications[i].id);
              },
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
              subTextColor: subTextColor,
              borderColor: borderColor,
              isRead: controller.notifications[i].isRead,
            ),
          ),
        );
      }),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final StudentNotification notification;

  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  final bool isDark;

  final Color surfaceColor;

  final Color textColor;

  final Color subTextColor;

  final Color borderColor;

  final bool isRead;

  const _NotificationCard({
    required this.notification,
    required this.onMarkAsRead,
    required this.onDelete,
    required this.isDark,
    required this.surfaceColor,
    required this.textColor,
    required this.subTextColor,
    required this.borderColor,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          if (notification.link.isEmpty) {
            return;
          }

          final uri = Uri.parse(notification.link);

          await launchUrl(uri, mode: LaunchMode.externalApplication);
        },

        child: Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: surfaceColor,

            borderRadius: BorderRadius.circular(18),

            border: Border.all(color: borderColor),

            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),

                      blurRadius: 14,

                      offset: const Offset(0, 5),
                    ),
                  ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// 🔔 TOP
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: NotificationPage._kPrimaryBlue.withOpacity(0.12),

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: const Icon(
                      Icons.notifications_active,

                      color: NotificationPage._kPrimaryBlue,

                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        /// 🔥 TITLE
                        Text(
                          notification.title.isNotEmpty
                              ? notification.title
                              : notification.bodyText,

                          style: GoogleFonts.inter(
                            fontSize: 15,

                            fontWeight: FontWeight.w700,

                            color: textColor,

                            height: 1.3,
                          ),
                        ),

                        if (notification.bodyText.isNotEmpty &&
                            notification.bodyText != notification.title) ...[
                          const SizedBox(height: 8),
                          Text(
                            notification.bodyText,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: subTextColor,
                              height: 1.45,
                            ),
                          ),
                        ],

                        const SizedBox(height: 8),

                        /// 🏷 SOURCE BADGE
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            color: NotificationPage._kPrimaryBlue.withOpacity(
                              0.08,
                            ),

                            borderRadius: BorderRadius.circular(999),
                          ),

                          child: Text(
                            notification.source.isNotEmpty
                                ? notification.source
                                : 'Admin',

                            style: GoogleFonts.inter(
                              fontSize: 11,

                              fontWeight: FontWeight.w600,

                              color: NotificationPage._kPrimaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              if (notification.attachment.isNotEmpty) ...[
                Builder(
                  builder: (context) {
                    final uri = Uri.tryParse(notification.attachment);
                    final path =
                        uri?.path.toLowerCase() ??
                        notification.attachment.toLowerCase();

                    final isImage =
                        path.endsWith('.png') ||
                        path.endsWith('.jpg') ||
                        path.endsWith('.jpeg') ||
                        path.endsWith('.gif') ||
                        path.endsWith('.webp');

                    final isPdf = path.endsWith('.pdf');
                    final isDoc =
                        path.endsWith('.doc') || path.endsWith('.docx');

                    if (isImage) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: const EdgeInsets.all(10),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  InteractiveViewer(
                                    child: Image.network(
                                      notification.attachment,
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      onPressed: () => Navigator.pop(ctx),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            notification.attachment,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                      );
                    } else {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          bool isDownloading = false;

                          return GestureDetector(
                            onTap: isDownloading
                                ? null
                                : () async {
                                    setState(() {
                                      isDownloading = true;
                                    });
                                    try {
                                      AppSnackbar.info(
                                        'Downloading...',
                                        'Please wait while we open the document.',
                                      );
                                      final dio = Dio();
                                      final tempDir =
                                          await getTemporaryDirectory();
                                      final fileName = notification.attachment
                                          .split('/')
                                          .last
                                          .split('?')
                                          .first;
                                      final savePath =
                                          '${tempDir.path}/$fileName';

                                      await dio.download(
                                        notification.attachment,
                                        savePath,
                                      );

                                      final result = await OpenFilex.open(
                                        savePath,
                                      );
                                      if (result.type != ResultType.done) {
                                        AppSnackbar.error(
                                          'Error',
                                          'Could not open document: ${result.message}',
                                        );
                                      }
                                    } catch (e) {
                                      AppSnackbar.error(
                                        'Error',
                                        'Failed to download document: $e',
                                      );
                                    } finally {
                                      if (context.mounted) {
                                        setState(() {
                                          isDownloading = false;
                                        });
                                      }
                                    }
                                  },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: NotificationPage._kPrimaryBlue
                                    .withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: NotificationPage._kPrimaryBlue
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isPdf
                                        ? Icons.picture_as_pdf_rounded
                                        : Icons.description_rounded,
                                    color: isPdf
                                        ? Colors.redAccent
                                        : NotificationPage._kPrimaryBlue,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isPdf
                                              ? "PDF Document"
                                              : (isDoc
                                                    ? "Word Document"
                                                    : "Attached File"),
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          isDownloading
                                              ? "Downloading..."
                                              : "Tap to view or download",
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: subTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: NotificationPage._kPrimaryBlue
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: isDownloading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: NotificationPage
                                                  ._kPrimaryBlue,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.download_rounded,
                                            color:
                                                NotificationPage._kPrimaryBlue,
                                            size: 20,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: 14),
              ],

              // /// 📅 DATE
              // if (notification.createdAt != null)
              //   Row(
              //     children: [
              //       Icon(Icons.schedule_rounded, size: 16, color: subTextColor),

              //       const SizedBox(width: 6),

              //       Expanded(
              //         child: Text(
              //           _formatDate(notification.createdAt!),

              //           style: GoogleFonts.inter(
              //             fontSize: 12,

              //             fontWeight: FontWeight.w500,

              //             color: subTextColor,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),

              // const SizedBox(height: 14),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 16,
                      color: Colors.redAccent,
                    ),
                    label: Text(
                      'Delete',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                  const Spacer(),
                  if (!isRead)
                    TextButton.icon(
                      onPressed: onMarkAsRead,
                      icon: const Icon(
                        Icons.done_rounded,
                        size: 16,
                        color: NotificationPage._kPrimaryBlue,
                      ),
                      label: Text(
                        'Mark as read',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: NotificationPage._kPrimaryBlue,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy • hh:mm a').format(date.toLocal());
  }
}

Color _statusColor(String value) {
  switch (value.trim().toUpperCase()) {
    case 'SENT':
    case 'DELIVERED':
      return Colors.green;
    case 'PARTIAL':
    case 'PENDING':
      return Colors.orange;
    case 'FAILED':
    case 'ERROR':
      return Colors.red;
    default:
      return NotificationPage._kPrimaryBlue;
  }
}

// String _formatDate(DateTime date) {
//   return DateFormat('dd MMM yyyy | hh:mm a').format(date.toLocal());
// }

String _formatStatus(String value) {
  if (value.trim().isEmpty) return value;

  return value
      .toLowerCase()
      .split('_')
      .map(
        (word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}',
      )
      .join(' ');
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _NotificationPlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color textColor;
  final Color subTextColor;
  final String? actionLabel;
  final VoidCallback? onPressed;

  const _NotificationPlaceholder({
    required this.icon,
    required this.title,
    required this.message,
    required this.textColor,
    required this.subTextColor,
    this.actionLabel,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: NotificationPage._kPrimaryBlue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 42,
                color: NotificationPage._kPrimaryBlue,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.5,
                color: subTextColor,
              ),
            ),
            if (actionLabel != null && onPressed != null) ...[
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: NotificationPage._kPrimaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
