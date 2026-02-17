import 'package:Gixa/Modules/Assistance/controller/counselor_controller.dart';
import 'package:Gixa/Modules/Assistance/model/counselor_model.dart';
import 'package:Gixa/Modules/Assistance/view/counselor_details_page.dart';
import 'package:Gixa/Modules/Assistance/view/request_guidance_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CounselorListView extends StatelessWidget {
  final String requestId;

  CounselorListView({super.key, required this.requestId});

  final CounselorController controller = Get.put(CounselorController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFF6F7FB);
    final surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final border = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final textPrimary = isDark ? Colors.white : Colors.black;
    final textSecondary = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    controller.init(requestId);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          "Choose Counselor",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: surface,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.counselors.isEmpty) {
          return _EmptyState(isDark: isDark);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.counselors.length,
          itemBuilder: (_, index) {
            final counselor = controller.counselors[index];
            return _CounselorCard(
              counselor: counselor,
              isDark: isDark,
              surface: surface,
              border: border,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              onSelect: () {
                Get.dialog(
                  RequestGuidanceDialog(
                    counselorId: counselor.id,
                    counselorName: counselor.name,
                  ),
                  barrierDismissible: false,
                );
              },
            );
          },
        );
      }),
    );
  }
}

class _CounselorCard extends StatelessWidget {
  final Counselor counselor;
  final bool isDark;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onSelect;

  const _CounselorCard({
    required this.counselor,
    required this.isDark,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = counselor.availability == "available";

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.to(() => CounselorDetailPage(counselorId: counselor.id));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 Avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: NetworkImage(counselor.profileImage),
              onBackgroundImageError: (_, __) {},
              child: counselor.profileImage.isEmpty
                  ? const Icon(Icons.person, size: 32)
                  : null,
            ),

            const SizedBox(width: 14),

            // 📄 Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          counselor.name,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      _StatusBadge(isAvailable: isAvailable),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    counselor.specialization,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: textSecondary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Icon(Icons.work_outline, size: 14, color: textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        "${counselor.experienceYears} yrs experience",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        "${counselor.rating} (${counselor.totalReviews})",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: isAvailable ? onSelect : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAvailable
                            ? const Color(0xFF1565C0)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        "Select",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isAvailable;

  const _StatusBadge({required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAvailable
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isAvailable ? "Available" : "Busy",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isAvailable ? Colors.green : Colors.red,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.support_agent,
            size: 64,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "No counselors available",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Please try again later",
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
