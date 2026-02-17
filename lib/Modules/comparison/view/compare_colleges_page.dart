import 'package:Gixa/Modules/comparison/controller/college_compare_controller.dart';
import 'package:Gixa/Modules/comparison/model/college_compare_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Gixa/routes/app_routes.dart';

class CompareCollegesView extends StatelessWidget {
  const CompareCollegesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CollegeCompareController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FD),

      appBar: AppBar(
        title: const Text("College Comparison"),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Saved Comparisons",
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {
              Get.toNamed(AppRoutes.savedComparision);
            },
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final result = controller.compareResult.value;

        if (result == null || result.comparison.isEmpty) {
          return _EmptyState();
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: result.comparison.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _CollegeCompareCard(
                    college: result.comparison[index],
                  );
                },
              ),
            ),

            /// 🔹 Sticky Save Button
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: controller.isSaving.value
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      controller.isSaving.value
                          ? "Saving..."
                          : "Save Comparison",
                    ),
                    onPressed: controller.isSaving.value
                        ? null
                        : controller.saveComparedColleges,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
class _CollegeCompareCard extends StatelessWidget {
  final CollegeComparison college;

  const _CollegeCompareCard({required this.college});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// College Name
            Text(
              college.collegeName,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            /// Location
            Row(
              children: [
                const Icon(Icons.location_on, size: 14),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "${college.city}, ${college.district}",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),

            _infoRow("College Code", college.collegeCode),
            _infoRow(
              "Hostel",
              college.hostelAvailable ? "Available" : "Not Available",
              highlight: !college.hostelAvailable,
            ),
            _infoRow(
              "Established",
              college.yearEstablished?.toString() ?? "-",
            ),
            _infoRow("Admission Chance", college.admissionChances),

            if (college.collegeWebsite?.isNotEmpty == true)
              _linkRow(Icons.language, college.collegeWebsite!),

            if (college.collegeVideoUrl?.isNotEmpty == true)
              _linkRow(Icons.play_circle_outline, college.collegeVideoUrl!),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: highlight ? Colors.red : null,
                fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _linkRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.compare_arrows_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              "No colleges to compare",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Select two colleges to view comparison",
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
