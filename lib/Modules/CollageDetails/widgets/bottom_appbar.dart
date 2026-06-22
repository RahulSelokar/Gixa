import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/collage_theme.dart';
import 'package:Gixa/Modules/favourite/controller/fevorite_collage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomActionBar extends StatelessWidget {
  final CollegeDetail college;

  const BottomActionBar({super.key, required this.college});

  @override
  Widget build(BuildContext context) {
    final colors = CollegeTheme.colors(context);

    final FavouriteCollegeController favController =
        Get.isRegistered<FavouriteCollegeController>()
        ? Get.find<FavouriteCollegeController>()
        : Get.put(FavouriteCollegeController(), permanent: true);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.appBarBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: colors.subtleBorder)),
        boxShadow: colors.cardShadow,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (college.website.isNotEmpty) ...[
              _squareButton(
                icon: Icons.language_rounded,
                iconColor: Colors.white,
                fillColor: colors.primary,
                gradient: colors.coolGradient,
                borderColor: colors.secondary.withOpacity(0.25),
                onTap: () => _launchWebsite(college.website),
              ),
              const SizedBox(width: 12),
            ],
            Obx(() {
              final isFav = favController.isFavourite(college.id);

              return _squareButton(
                icon: isFav
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                iconColor: isFav ? Colors.white : colors.textMain,
                fillColor: isFav
                    ? colors.danger
                    : colors.softFill(
                        colors.pink,
                        lightOpacity: 0.10,
                        darkOpacity: 0.18,
                      ),
                gradient: isFav ? colors.warmGradient : null,
                borderColor: colors.subtleBorder,
                onTap: () => favController.toggleFavourite(college.id),
              );
            }),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 54,
                child: Obx(() {
                  final isFav = favController.isFavourite(college.id);

                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: isFav ? colors.warmGradient : colors.brandGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: colors.floatingShadow,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => favController.toggleFavourite(college.id),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isFav
                                    ? Icons.favorite_rounded
                                    : Icons.bookmark_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isFav ? "Saved" : "Save College",
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  Widget _squareButton({
    required IconData icon,
    required Color iconColor,
    required Color fillColor,
    required VoidCallback onTap,
    Color? borderColor,
    Gradient? gradient,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
          color: gradient == null ? fillColor : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          border: borderColor != null ? Border.all(color: borderColor) : null,
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }

  Future<void> _launchWebsite(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Website launch failed: $e');
    }
  }
}
