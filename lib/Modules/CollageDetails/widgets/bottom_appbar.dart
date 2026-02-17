import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:Gixa/Modules/favourite/controller/fevorite_collage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomActionBar extends StatelessWidget {
  final CollegeDetail college;

  const BottomActionBar({
    super.key,
    required this.college,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    /// ✅ Safe controller injection (single instance)
    final FavouriteCollegeController favController =
        Get.isRegistered<FavouriteCollegeController>()
            ? Get.find<FavouriteCollegeController>()
            : Get.put(FavouriteCollegeController(), permanent: true);

    // ── Theme Palette ──
    final Color surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color borderColor =
        isDark ? const Color(0xFF333333) : Colors.transparent;
    const Color kPrimaryBlue = Color(0xFF1565C0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: isDark
            ? Border(top: BorderSide(color: borderColor, width: 1))
            : null,
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            /// 🌐 WEBSITE BUTTON
            if (college.website.isNotEmpty) ...[
              _squareButton(
                icon: Icons.language_rounded,
                color: kPrimaryBlue,
                bgColor: kPrimaryBlue.withOpacity(0.12),
                onTap: () => _launchWebsite(college.website),
              ),
              const SizedBox(width: 12),
            ],

            /// ❤️ FAV ICON BUTTON
            Obx(() {
              final bool isFav = favController.isFavourite(college.id);

              return _squareButton(
                icon: isFav
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: isFav
                    ? Colors.redAccent
                    : (isDark ? Colors.grey[300]! : Colors.grey[600]!),
                bgColor:
                    isDark ? const Color(0xFF2C2C2C) : Colors.grey[100]!,
                borderColor:
                    isDark ? Colors.grey[800]! : Colors.grey[300]!,
                onTap: () => favController.toggleFavourite(college.id),
              );
            }),

            const SizedBox(width: 12),

            /// 🔵 MAIN ACTION BUTTON
            Expanded(
              child: SizedBox(
                height: 54,
                child: Obx(() {
                  final bool isFav = favController.isFavourite(college.id);

                  return ElevatedButton(
                    onPressed: () =>
                        favController.toggleFavourite(college.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isFav ? Colors.redAccent : kPrimaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.bookmark_rounded,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isFav ? "Saved" : "Save College",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Reusable square icon button
  Widget _squareButton({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
    Color? borderColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: borderColor != null ? Border.all(color: borderColor) : null,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  /// 🌐 Launch Website safely
  Future<void> _launchWebsite(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      debugPrint('❌ Website launch failed: $e');
    }
  }
}
