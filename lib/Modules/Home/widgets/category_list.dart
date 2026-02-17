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
    final iconColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final textColor = iconColor;

    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _item(
            icon: Icons.account_balance_rounded,
            label: "Colleges",
            isActive: true,
            onTap: onCollegesTap,
            iconColor: iconColor,
            textColor: textColor,
          ),
          _item(
            icon: Icons.auto_graph_rounded,
            label: "Predictor",
            isActive: false,
            onTap: onPredictorTap,
            iconColor: iconColor,
            textColor: textColor,
          ),
          _item(
            icon: Icons.pie_chart_outline,
            label: "Cutoffs",
            isActive: false,
            onTap: onCutoffTap,
            iconColor: iconColor,
            textColor: textColor,
          ),
          _item(
            icon: Icons.support_agent,
            label: "Help",
            isActive: false,
            onTap: onHelpTap,
            iconColor: iconColor,
            textColor: textColor,
          ),
          _item(
            icon: Icons.person_search,
            label: "Assistance",
            isActive: false,
            onTap: onAssistanceTap,
            iconColor: iconColor,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required Color iconColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF1565C0) : surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? Colors.transparent : border,
                ),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isActive ? Colors.white : iconColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isActive ? const Color(0xFF1565C0) : textColor,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
