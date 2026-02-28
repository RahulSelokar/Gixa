import 'package:Gixa/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/compare_history_controller.dart';

class CompareHistoryView extends StatelessWidget {
  const CompareHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CompareHistoryController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryText = isDark ? Colors.white : const Color(0xFF1E293B);
    final secondaryText = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final accentBlue = const Color(0xFF2563EB);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Comparison History",
          style: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryText),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: accentBlue));
        }

        if (controller.historyList.isEmpty) {
          return _EmptyState(isDark: isDark);
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: controller.historyList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = controller.historyList[index];

            return Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
                ),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: const Color(0xFF64748B).withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Get.toNamed(AppRoutes.compareCollage, arguments: item); 
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today_rounded, size: 14, color: secondaryText),
                                const SizedBox(width: 6),
                                Text(
                                  item.createdDate,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: secondaryText,
                                  ),
                                ),
                              ],
                            ),
                            _CountBadge(count: item.totalColleges, color: accentBlue),
                          ],
                        ),

                        const SizedBox(height: 16),
                        
                        ...item.colleges.take(3).map((college) => _CollegeRowItem(
                              college: college,
                              isDark: isDark,
                              primaryText: primaryText,
                              secondaryText: secondaryText,
                            )),
                        if (item.colleges.length > 3)
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 50),
                            child: Text(
                              "+ ${item.colleges.length - 3} more colleges",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: accentBlue,
                              ),
                            ),
                          ),

                        const SizedBox(height: 16),
                        
                        Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.shade100),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "View Analysis",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: accentBlue,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(Icons.arrow_forward_rounded, size: 16, color: accentBlue),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// ───────────────── COLLEGE ROW ITEM ─────────────────
class _CollegeRowItem extends StatelessWidget {
  final dynamic college; // Replace dynamic with CollegeModel type
  final bool isDark;
  final Color primaryText;
  final Color secondaryText;

  const _CollegeRowItem({
    required this.college,
    required this.isDark,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    // Generate initials (e.g. "IIT Delhi" -> "ID")
    String initials = "";
    if (college.collegeName.isNotEmpty) {
      initials = college.collegeName.split(" ").take(2).map((e) => e[0]).join();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.1) : const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: Text(
              initials.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF2563EB),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Name & City
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  college.collegeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primaryText,
                  ),
                ),
                Text(
                  college.city,
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  final Color color;

  const _CountBadge({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        "$count Comparison",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;

  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                ],
              ),
              child: Icon(
                Icons.history_toggle_off_rounded,
                size: 48,
                color: isDark ? Colors.white54 : const Color(0xFFCBD5E1),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No History Found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "You haven't compared any colleges yet. \nStart comparing to save results here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : const Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 180,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.compareCollage),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFF2563EB).withOpacity(0.4),
                ),
                child: const Text("Start Comparing"),
              ),
            )
          ],
        ),
      ),
    );
  }
}