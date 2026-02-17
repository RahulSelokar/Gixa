import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollegeGalleryDialog extends StatefulWidget {
  final List<String> images;

  const CollegeGalleryDialog({
    super.key,
    required this.images,
  });

  @override
  State<CollegeGalleryDialog> createState() => _CollegeGalleryDialogState();
}

class _CollegeGalleryDialogState extends State<CollegeGalleryDialog> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color iconColor = isDark ? Colors.white : Colors.black;
    final Color buttonBg = isDark
        ? Colors.grey[800]!.withOpacity(0.8)
        : Colors.white.withOpacity(0.9);

    // ❌ No images safety
    if (widget.images.isEmpty) {
      return Dialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          height: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text("No images available"),
              ],
            ),
          ),
        ),
      );
    }

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: bgColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isDark
            ? BorderSide(color: Colors.grey[800]!, width: 1)
            : BorderSide.none,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 500),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// 🖼️ Image Slider
              PageView.builder(
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final imageUrl = widget.images[index]; // ✅ FULL URL

                  return InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDark ? Colors.white : Colors.blue,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image_rounded,
                                color: isDark
                                    ? Colors.grey[600]
                                    : Colors.grey[400],
                                size: 48,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Failed to load image",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),

              /// ❌ Close Button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: buttonBg,
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          )
                      ],
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                ),
              ),

              /// 🔢 Page Indicator
              Positioned(
                bottom: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${_currentIndex + 1} / ${widget.images.length}",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
