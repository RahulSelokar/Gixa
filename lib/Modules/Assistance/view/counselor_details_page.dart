import 'package:Gixa/Modules/Assistance/controller/counselor_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CounselorDetailPage extends StatelessWidget {
  final int counselorId;

  CounselorDetailPage({super.key, required this.counselorId});

  final controller = Get.put(CounselorDetailController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFF6F7FB);
    final surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final border = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final textPrimary = isDark ? Colors.white : Colors.black;
    final textSecondary = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    controller.init(counselorId);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Counselor Profile"),
        backgroundColor: surface,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final counselor = controller.counselor.value;
        if (counselor == null) {
          return const Center(child: Text("No data found"));
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ───── PROFILE HEADER ─────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: counselor.profileImage.isNotEmpty
                              ? NetworkImage(counselor.profileImage)
                              : null,
                          child: counselor.profileImage.isEmpty
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                counselor.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${counselor.experienceYears} years experience",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 14, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${counselor.rating} (${counselor.totalReviews} reviews)",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ───── ABOUT ─────
                  if (counselor.bio.isNotEmpty)
                    _sectionCard(
                      title: "About",
                      child: Text(
                        counselor.bio,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: textSecondary,
                        ),
                      ),
                      surface: surface,
                      border: border,
                      textPrimary: textPrimary,
                    ),

                  /// ───── SPECIALIZATIONS ─────
                  _chipSection(
                    title: "Specializations",
                    items: counselor.specializations,
                    surface: surface,
                    border: border,
                    textPrimary: textPrimary,
                  ),

                  /// ───── EXAMS ─────
                  _chipSection(
                    title: "Exam Expertise",
                    items: counselor.examExpertise,
                    surface: surface,
                    border: border,
                    textPrimary: textPrimary,
                  ),

                  /// ───── LANGUAGES ─────
                  _chipSection(
                    title: "Languages",
                    items: counselor.languages,
                    surface: surface,
                    border: border,
                    textPrimary: textPrimary,
                  ),
                ],
              ),
            ),

            /// ───── ACTION BAR ─────
            _ActionBar(
              isDark: isDark,
              chat: counselor.availability.chat,
              call: counselor.availability.call,
              video: counselor.availability.video,
            ),
          ],
        );
      }),
    );
  }

  // ───────────────── HELPERS ─────────────────

  Widget _sectionCard({
    required String title,
    required Widget child,
    required Color surface,
    required Color border,
    required Color textPrimary,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: textPrimary,
              )),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _chipSection({
    required String title,
    required List<String> items,
    required Color surface,
    required Color border,
    required Color textPrimary,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return _sectionCard(
      title: title,
      surface: surface,
      border: border,
      textPrimary: textPrimary,
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: items.map((e) => Chip(label: Text(e))).toList(),
      ),
    );
  }
}

/// ───────────────── ACTION BAR ─────────────────

class _ActionBar extends StatelessWidget {
  final bool isDark;
  final bool chat;
  final bool call;
  final bool video;

  const _ActionBar({
    required this.isDark,
    required this.chat,
    required this.call,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            _actionButton("Chat", Icons.chat, chat),
            const SizedBox(width: 12),
            _actionButton("Call", Icons.call, call),
            const SizedBox(width: 12),
            _actionButton("Video", Icons.videocam, video),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(String label, IconData icon, bool enabled) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: enabled ? () {} : null,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? const Color(0xFF1565C0) : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
