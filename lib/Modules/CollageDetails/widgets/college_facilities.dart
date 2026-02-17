import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FacilitiesSection extends StatelessWidget {
  final CollegeDetail college;

  const FacilitiesSection({
    super.key,
    required this.college,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // --- Theme Palette ---
    final Color titleColor = isDark ? Colors.white : const Color(0xFF111111);
    final Color primaryColor = const Color(0xFF1565C0); // Brand Blue

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.deck_rounded, color: Colors.orange, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              "Facilities",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Facilities Row
        // Using Row with Expanded to ensure equal spacing
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFacilityItem(
                context,
                icon: Icons.bed_rounded,
                label: "Hostel",
                isAvailable: college.hostelAvailable,
                isDark: isDark,
                primaryColor: primaryColor,
              ),
            ),
            Expanded(
              child: _buildFacilityItem(
                context,
                icon: Icons.wifi_rounded,
                label: "WiFi",
                isAvailable: true, // Assuming true as per original code
                isDark: isDark,
                primaryColor: primaryColor,
              ),
            ),
            Expanded(
              child: _buildFacilityItem(
                context,
                icon: Icons.fitness_center_rounded,
                label: "Gym",
                isAvailable: true, // Assuming true
                isDark: isDark,
                primaryColor: primaryColor,
              ),
            ),
            Expanded(
              child: _buildFacilityItem(
                context,
                icon: Icons.local_library_rounded,
                label: "Library",
                isAvailable: true, // Assuming true
                isDark: isDark,
                primaryColor: primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFacilityItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isAvailable,
    required bool isDark,
    required Color primaryColor,
  }) {
    // Colors based on availability
    final Color iconColor = isAvailable 
        ? (isDark ? Colors.blue[200]! : primaryColor) 
        : (isDark ? Colors.grey[600]! : Colors.grey[400]!);
        
    final Color bgBase = isAvailable 
        ? primaryColor 
        : (isDark ? Colors.grey[700]! : Colors.grey[300]!);

    final Color bgColor = isDark 
        ? bgBase.withOpacity(0.15) 
        : bgBase.withOpacity(0.08);

    final Color textColor = isAvailable
        ? (isDark ? Colors.grey[200]! : Colors.grey[800]!)
        : (isDark ? Colors.grey[600]! : Colors.grey[400]!);

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Main Icon Container
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16), // Squircle shape
                border: isAvailable && isDark 
                    ? Border.all(color: primaryColor.withOpacity(0.3)) 
                    : null,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 26,
              ),
            ),
            
            // Checkmark Badge (Only if available)
            if (isAvailable)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xFF00C853), // Success Green
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        
        // Label
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
            // Cross out text if not available
            decoration: isAvailable ? null : TextDecoration.lineThrough,
            decorationColor: textColor,
          ),
        ),
      ],
    );
  }
}