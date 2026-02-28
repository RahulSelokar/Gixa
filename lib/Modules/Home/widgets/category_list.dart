import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryList extends StatelessWidget {
  final bool isDark;
  final Color surface;
  final Color border;

  // 🔹 Navigation callbacks
  final VoidCallback onCollegesTap;
  final VoidCallback onPredictorTap;
  final VoidCallback onCutoffTap;
  final VoidCallback onHelpTap;
  final VoidCallback onAssistanceTap;

  const CategoryList({
    super.key,
    required this.isDark,
    required this.surface,
    required this.border,
    required this.onCollegesTap,
    required this.onPredictorTap,
    required this.onCutoffTap,
    required this.onHelpTap,
    required this.onAssistanceTap, // ✅ NEW
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          _item(
            imageUrl:
                "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/School/3D/school_3d.png",
            label: "Colleges",
            isActive: true,
            onTap: onCollegesTap,
          ),
          _item(
            imageUrl:
                "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Crystal%20ball/3D/crystal_ball_3d.png",
            label: "Predictor",
            isActive: false,
            onTap: onPredictorTap,
          ),
          _item(
            imageUrl:
                "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Bar%20chart/3D/bar_chart_3d.png",
            label: "Cutoffs",
            isActive: false,
            onTap: onCutoffTap,
          ),
          _item(
            imageUrl:
                "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Headphone/3D/headphone_3d.png",
            label: "Help",
            isActive: false,
            onTap: onHelpTap,
          ),
          _item(
            imageUrl:
                "https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Robot/3D/robot_3d.png",
            label: "Assistance",
            isActive: false,
            onTap: onAssistanceTap,
          ),
        ],
      ),
    );
  }

  Widget _item({
    required String imageUrl,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF1565C0).withOpacity(0.08)
                    : (isDark ? Colors.grey[800] : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF1565C0).withOpacity(0.5)
                      : border,
                  width: isActive ? 1.5 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.category,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isActive
                    ? const Color(0xFF1565C0)
                    : (isDark ? Colors.grey[400] : Colors.grey[800]),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
