import 'package:Gixa/Modules/notification/controller/alerts_controller.dart';
import 'package:Gixa/Modules/notification/model/student_notification_model.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Gixa/Modules/notification/veiw/notification_search_delegate.dart';

const Color _kPrimaryBlue = kHomeAccentColor;

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  late ScrollController _scrollController;

  final AlertsController controller = Get.isRegistered<AlertsController>()
      ? Get.find<AlertsController>()
      : Get.put(AlertsController());

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    
    // Automatically fetch fresh alerts when the page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAlerts(forceRefresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      controller.loadMoreAlerts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FD);
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111111);
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    return Obx(() {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text(
            'Alerts',
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
                    notifications: controller.alerts,
                    primaryColor: _kPrimaryBlue,
                    itemBuilder: (notification) {
                      return _AlertCard(
                        alert: notification,
                        isRead: notification.isRead,
                        isSelected: controller.isSelected(notification.id),
                        onSelect: () => controller.toggleSelection(notification.id),
                        onMarkRead: () => controller.markAsRead(notification.id),
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                        textColor: textColor,
                        subTextColor: subTextColor,
                        borderColor: borderColor,
                      );
                    },
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () {
                if (controller.selectedAlerts.length ==
                    controller.alerts.length) {
                  controller.clearSelection();
                } else {
                  controller.selectAllAlerts();
                }
              },

              child: Text(
                'Select All',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _kPrimaryBlue,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: controller.hasSelection
            ? SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: surfaceColor,
                    border: Border(top: BorderSide(color: borderColor)),
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${controller.selectedAlerts.length} selected',

                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),

                      ElevatedButton.icon(
                        onPressed: controller.markSelectedAsRead,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,

                          foregroundColor: Colors.white,

                          elevation: 0,

                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        icon: const Icon(Icons.done_all_rounded),

                        label: Text(
                          'Mark as Read',

                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
        body: Obx(() {
          if (controller.isLoading.value && controller.alerts.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: _kPrimaryBlue),
            );
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.alerts.isEmpty) {
            return RefreshIndicator(
              onRefresh: controller.refreshAlerts,
              color: _kPrimaryBlue,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.72,
                    child: _AlertPlaceholder(
                      icon: Icons.campaign_rounded,
                      title: 'Unable to load alerts',
                      message: controller.errorMessage.value,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      actionLabel: 'Retry',
                      onPressed: controller.refreshAlerts,
                    ),
                  ),
                ],
              ),
            );
          }

          if (controller.alerts.isEmpty) {
            return RefreshIndicator(
              onRefresh: controller.refreshAlerts,
              color: _kPrimaryBlue,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.72,
                    child: _AlertPlaceholder(
                      icon: Icons.campaign_outlined,
                      title: 'No alerts yet',
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
            onRefresh: controller.refreshAlerts,
            color: _kPrimaryBlue,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              itemCount:
                  controller.alerts.length + (controller.hasNext.value ? 1 : 0),
              separatorBuilder: (_, i) {
                if (i == controller.alerts.length - 1 &&
                    controller.hasNext.value) {
                  return const SizedBox(height: 12);
                }
                return const SizedBox(height: 12);
              },
              itemBuilder: (_, i) {
                // Show loading indicator at the end if there are more items to load
                if (i == controller.alerts.length) {
                  return Obx(
                    () => controller.isLoadingMore.value
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: CircularProgressIndicator(
                                color: _kPrimaryBlue,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  );
                }

                final item = controller.alerts[i];

                return _AlertCard(
                  alert: item,
                  isRead: item.isRead,
                  isSelected: controller.isSelected(item.id),

                  onSelect: () {
                    controller.toggleSelection(item.id);
                  },

                  onMarkRead: () {
                    controller.markAsRead(item.id);
                  },

                  isDark: Theme.of(context).brightness == Brightness.dark,

                  surfaceColor: item.isRead
                      ? (Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF1E1E1E)
                          : Colors.white)
                      : (Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF1E293B)
                          : _kPrimaryBlue.withOpacity(0.06)),

                  textColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF111111),

                  subTextColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]!
                      : Colors.grey[600]!,

                  borderColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]!
                      : Colors.grey[200]!,
                );
              },
            ),
          );
        }),
      );
    });
  }
}

class _AlertCard extends StatelessWidget {
  final StudentNotification alert;
  final bool isDark;
  final Color surfaceColor;
  final Color textColor;
  final Color subTextColor;
  final Color borderColor;
  final bool isRead;
  final bool isSelected;

  final VoidCallback onSelect;
  final VoidCallback onMarkRead;

  const _AlertCard({
    required this.alert,
    required this.isDark,
    required this.surfaceColor,
    required this.textColor,
    required this.subTextColor,
    required this.borderColor,
    required this.isRead,
    required this.isSelected,
    required this.onSelect,
    required this.onMarkRead,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          if (alert.link.isEmpty) {
            return;
          }
  
          final uri = Uri.parse(alert.link);
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isRead 
                          ? Colors.grey.withOpacity(0.12)
                          : _kPrimaryBlue.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.campaign_rounded,
                      color: isRead ? Colors.grey : _kPrimaryBlue,
                      size: 22,
                    ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (!isRead)
                            Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),


                          Expanded(
                            child: Text(
                              alert.title,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: isRead ? FontWeight.normal : FontWeight.w700,
                                color: isRead ? subTextColor : textColor,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isRead
                              ? Colors.grey.withOpacity(0.08)
                              : _kPrimaryBlue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          alert.source,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isRead ? Colors.grey : _kPrimaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isRead)
                  Checkbox(
                    value: isSelected,
  
                    visualDensity: VisualDensity.compact,
  
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  
                    activeColor: _kPrimaryBlue,
  
                    onChanged: (value) {
                      onSelect();
                    },
                  ),
              ],
            ),
            // const SizedBox(height: 14),
            // if (alert.createdAt != null)
            //   Row(
            //     children: [
            //       Icon(Icons.schedule_rounded, size: 16, color: subTextColor),
            //       const SizedBox(width: 6),
            //       Expanded(
            //         child: Text(
            //           DateFormat(
            //             'dd MMM yyyy • hh:mm a',
            //           ).format(alert.createdAt!.toLocal()),
            //           style: GoogleFonts.inter(
            //             fontSize: 12,
            //             fontWeight: FontWeight.w500,
            //             color: subTextColor,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _kPrimaryBlue.withOpacity(0.08),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.open_in_new_rounded,
                    size: 16,
                    color: _kPrimaryBlue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Open Alert',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _kPrimaryBlue,
                    ),
                  ),
                ],
              ),
            ),

            if (!isRead) ...[
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onMarkRead,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green.withOpacity(0.08),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.done_rounded,
                        size: 16,
                        color: Colors.green,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        'Mark as Read',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AlertPlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color textColor;
  final Color subTextColor;
  final String? actionLabel;
  final VoidCallback? onPressed;

  const _AlertPlaceholder({
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
                color: _kPrimaryBlue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 42, color: _kPrimaryBlue),
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
                  backgroundColor: _kPrimaryBlue,
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
