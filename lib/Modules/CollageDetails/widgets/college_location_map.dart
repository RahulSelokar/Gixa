import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationMap extends StatelessWidget {
  const LocationMap({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- Theme Palette ---
    final Color titleColor = isDark ? Colors.white : const Color(0xFF111111);
    final Color borderColor = isDark ? const Color(0xFF333333) : Colors.grey.shade200;
    
    // Map Image Logic
    // In dark mode, we dim the map image slightly so it's not blindingly bright
    final ColorFilter? mapFilter = isDark 
        ? ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken) 
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.map_outlined, color: Colors.blue, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              "Location",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Map Card
        GestureDetector(
          onTap: () {
            // TODO: Launch Google Maps
            debugPrint("Launching Maps...");
          },
          child: Container(
            height: 180, // Slightly taller for better visibility
            width: double.infinity,
            clipBehavior: Clip.antiAlias, // Ensures image doesn't bleed corners
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
              boxShadow: isDark ? [] : [
                 BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // 1. Map Image Background
                Positioned.fill(
                  child: Image.network(
                    "https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/pass/GoogleMapTA.jpg",
                    fit: BoxFit.cover,
                    color: isDark ? Colors.black.withOpacity(0.3) : null,
                    colorBlendMode: isDark ? BlendMode.darken : null,
                  ),
                ),

                // 2. Center Pin (Pulse Effect)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Colors.redAccent, // Red pops better on maps
                          size: 32,
                        ),
                      ),
                      // Little point at bottom of pin
                      Container(
                        width: 4, 
                        height: 4,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      )
                    ],
                  ),
                ),

                // 3. "View on Maps" Button (Bottom Right)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Open in Maps",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_outward_rounded,
                          size: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}