import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gixa/Modules/notification/model/student_notification_model.dart';
import 'package:Gixa/Modules/notification/controller/notification_search_history_service.dart';

typedef NotificationCardBuilder = Widget Function(StudentNotification notification);

class NotificationSearchDelegate extends SearchDelegate<StudentNotification?> {
  final RxList<StudentNotification> notifications;
  final NotificationCardBuilder itemBuilder;
  final Color primaryColor;

  NotificationSearchDelegate({
    required this.notifications,
    required this.itemBuilder,
    required this.primaryColor,
  });

  // Ensure the history service is initialized
  final NotificationSearchHistoryService historyService = 
      Get.isRegistered<NotificationSearchHistoryService>()
          ? Get.find<NotificationSearchHistoryService>()
          : Get.put(NotificationSearchHistoryService());

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: GoogleFonts.inter(
          color: isDark ? Colors.grey[500] : Colors.grey[400],
        ),
        border: InputBorder.none,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: GoogleFonts.inter(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isNotEmpty) {
      historyService.addSearchTerm(query);
    }
    return _buildList(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _buildHistoryView(context);
    }
    return _buildList(context, query);
  }

  Widget _buildList(BuildContext context, String searchQuery) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FD);

    final lowercaseQuery = searchQuery.toLowerCase();
    
    return Obx(() {
      // Alphabetic match functionality checking title, body, and source
      final filteredNotifications = notifications.where((notification) {
        final titleMatch = notification.title.toLowerCase().contains(lowercaseQuery);
        final bodyMatch = notification.bodyText.toLowerCase().contains(lowercaseQuery);
        final sourceMatch = notification.source.toLowerCase().contains(lowercaseQuery);
        return titleMatch || bodyMatch || sourceMatch;
      }).toList();

      // Optionally sort alphabetically
      filteredNotifications.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

      if (filteredNotifications.isEmpty) {
        return Container(
          color: bgColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No results found for "$searchQuery"',
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Container(
        color: bgColor,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filteredNotifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return itemBuilder(filteredNotifications[index]);
          },
        ),
      );
    });
  }

  Widget _buildHistoryView(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FD);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      color: bgColor,
      child: Obx(() {
        final history = historyService.searchHistory;
        
        if (history.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_rounded, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'Search history is empty',
                  style: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Searches',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      historyService.clearHistory();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Clear',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...history.map((term) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: Icon(Icons.history, color: Colors.grey[400]),
              title: Text(
                term,
                style: GoogleFonts.inter(
                  color: textColor,
                  fontSize: 15,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.close, size: 18, color: Colors.grey[400]),
                onPressed: () {
                  historyService.removeSearchTerm(term);
                },
              ),
              onTap: () {
                query = term;
                showResults(context);
              },
            )),
          ],
        );
      }),
    );
  }
}
