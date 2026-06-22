import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/collage_gallary.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/collage_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollegeHeroImage extends StatelessWidget {
  final CollegeDetail college;

  const CollegeHeroImage({super.key, required this.college});

  @override
  Widget build(BuildContext context) {
    final colors = CollegeTheme.colors(context);

    final heroImageUrl = college.gallery.isNotEmpty
        ? college.gallery.first.imageUrl
        : null;

    return GestureDetector(
      onTap: college.gallery.isNotEmpty ? () => _openGallery(context) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AspectRatio(
            aspectRatio: 16 / 9, // ✅ responsive height
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 🖼 IMAGE
                heroImageUrl == null
                    ? _imageFallback(colors.heroPlaceholder)
                    : Image.network(
                        heroImageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return _shimmerLoader();
                        },
                        errorBuilder: (_, __, ___) =>
                            _imageFallback(colors.heroPlaceholder),
                      ),

                // 🌑 GRADIENT OVERLAY
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.75),
                        Colors.black.withOpacity(0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // 📸 GALLERY CHIP
                if (college.gallery.isNotEmpty)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _glassChip(
                      icon: Icons.grid_view_rounded,
                      text: "${college.gallery.length} Photos",
                      colors: colors,
                      onTap: () => _openGallery(context),
                    ),
                  ),

                // 🏷 CAMPUS LABEL
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: _glassChip(
                    icon: Icons.auto_awesome_rounded,
                    text: "Campus view",
                    colors: colors,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔥 SHIMMER / LOADER
  Widget _shimmerLoader() {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  // 🔥 GLASS CHIP (Reusable UI)
  Widget _glassChip({
    required IconData icon,
    required String text,
    required CollegeThemeColors colors,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: colors.primary),
            const SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 FALLBACK IMAGE
  Widget _imageFallback(Color bgColor) {
    return Container(
      color: bgColor,
      alignment: Alignment.center,
      child: Image.asset(
        "assets/images/Medical_College.png",
        fit: BoxFit.cover, // ✅ FIXED (was small before)
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  // 🔥 OPEN GALLERY
  void _openGallery(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CollegeGalleryDialog(
        images: college.gallery.map((e) => e.imageUrl).toList(),
      ),
    );
  }
}