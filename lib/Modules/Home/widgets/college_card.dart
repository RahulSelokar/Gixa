import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CollegeCard extends StatelessWidget {
  final String name;
  final String location;
  // final String rank;
  final String imageUrl;
  final int id;
  final double? cardWidth;

  const CollegeCard({
    super.key,
    required this.id,
    required this.name,
    required this.location,
    // required this.rank,
    required this.imageUrl,
    this.cardWidth,
  });

  @override
  Widget build(BuildContext context) {
    // 🌓 Theme Detection
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    // 🎨 Dynamic Colors
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF111111);
    final Color subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final Color borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final Color primaryBlue = kHomeAccentColor;

    return Container(
      width: cardWidth ?? (isTablet ? 340 : 280),
      margin: EdgeInsets.only(right: cardWidth == null ? 16 : 0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isDark
            ? [] // No shadow in dark mode, border handles depth
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🖼️ Image Section (Stack for Overlays)
          Stack(
            children: [
              // Main Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(19),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9, // 🔥 IMPORTANT FIX
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,

                          // 🔥 LOADING FIX
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return _imageLoader();
                          },

                          // 🔥 ERROR FIX
                          errorBuilder: (_, __, ___) => _fallbackImage(),
                        )
                      : _fallbackImage(),
                ),
              ),

              // 🏆 Rank Badge (Top Left)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Colors.amber,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      // Text(
                      //   rank,
                      //   style: GoogleFonts.inter(
                      //     color: Colors.white,
                      //     fontSize: 10,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),

              // ❤️ Favorite Button (Top Right - Glassmorphism)
              // Positioned(
              //   top: 12,
              //   right: 12,
              //   child: Container(
              //     height: 32,
              //     width: 32,
              //     decoration: BoxDecoration(
              //       color: Colors.white.withOpacity(0.25), // Glass effect
              //       shape: BoxShape.circle,
              //     ),
              //     child: Center(
              //       child: Icon(
              //         Icons.bookmark_border_rounded,
              //         color: Colors.white,
              //         size: 18,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),

          /// 📝 Content Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // College Name
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: isTablet ? 17 : 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // Location Row
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: subTextColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: GoogleFonts.inter(
                          fontSize: isTablet ? 13 : 12,
                          color: subTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Separator Line
                Container(
                  height: 1,
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                ),

                const SizedBox(height: 12),

                // 🦶 Footer: View Details
                InkWell(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.collageDetails,
                      arguments: {'collegeId': id},
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "View Details",
                          style: GoogleFonts.inter(
                            fontSize: isTablet ? 13 : 12,
                            fontWeight: FontWeight.w600,
                            color: primaryBlue,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: primaryBlue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageLoader() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _fallbackImage() {
    return Image.asset(
      "assets/images/Medical_College.png",
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
