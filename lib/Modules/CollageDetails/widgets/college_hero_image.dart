import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/collage_gallary.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollegeHeroImage extends StatelessWidget {
  final CollegeDetail college;

  const CollegeHeroImage({
    super.key,
    required this.college,
  });

  static const Color kPrimaryBlue = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ✅ Correct image source (FULL URL from backend)
    final String? heroImageUrl =
        college.gallery.isNotEmpty ? college.gallery.first.imageUrl : null;

    final Color placeholderColor =
        isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200;

    final Color badgeBg =
        isDark ? const Color(0xFF1E1E1E).withOpacity(0.9) : Colors.white;
    final Color badgeText =
        isDark ? Colors.white : const Color(0xFF111111);
    final Color badgeBorder =
        isDark ? const Color(0xFF333333) : Colors.transparent;

    return GestureDetector(
      onTap: college.gallery.isNotEmpty ? () => _openGallery(context) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: placeholderColor,
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              /// 🖼️ Hero Image
              heroImageUrl == null
                  ? _imageFallback(placeholderColor)
                  : Image.network(
                      heroImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _imageFallback(placeholderColor),
                    ),

              /// 🌑 Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.25),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),

              /// 📸 Gallery count badge
              if (college.gallery.isNotEmpty)
                Positioned(
                  top: 14,
                  right: 14,
                  child: GestureDetector(
                    onTap: () => _openGallery(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(30),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.grid_view_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${college.gallery.length} Photos",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              /// ⚡ Match badge
              Positioned(
                bottom: 14,
                left: 14,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: badgeBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        color: kPrimaryBlue,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "95% Match",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: badgeText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🖼️ Fallback UI
  Widget _imageFallback(Color bgColor) {
    return Container(
      color: bgColor,
      alignment: Alignment.center,
      child: const Icon(
        Icons.school_outlined,
        size: 64,
        color: Colors.grey,
      ),
    );
  }

  /// 🪟 Open gallery dialog
  void _openGallery(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CollegeGalleryDialog(
        images: college.gallery.map((e) => e.imageUrl).toList(),
      ),
    );
  }
}
