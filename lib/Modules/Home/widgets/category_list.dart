import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryList extends StatefulWidget {
  final bool isDark;
  final Color surface;
  final Color border;

  final VoidCallback onCollegesTap;
  final VoidCallback onPredictorTap;
  final VoidCallback onCutoffTap;
  final VoidCallback onHelpTap;
  final VoidCallback onApplicationsTap;
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
    required this.onApplicationsTap,
    required this.onAssistanceTap,
  });

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int? _pressedIndex;

  // ── LOCAL asset paths + gradient colors per tile ──────────────
  static const _items = [
    _CategoryItem(
      assetPath: 'assets/icons/college.png',
      label: 'Colleges',
      lightStart: Color(0xFFFFF3E0),
      lightEnd: Color(0xFFFFE0B2),
      darkStart: Color(0xFF4E2000),
      darkEnd: Color(0xFF7B3800),
    ),
    _CategoryItem(
      assetPath: 'assets/icons/prediction.png',
      label: 'Predictor',
      lightStart: Color(0xFFEDE9FE),
      lightEnd: Color(0xFFDDD6FE),
      darkStart: Color(0xFF2E1065),
      darkEnd: Color(0xFF4C1D95),
    ),
    _CategoryItem(
      assetPath: 'assets/icons/cutoff.png',
      label: 'Cutoffs',
      lightStart: Color(0xFFECFDF5),
      lightEnd: Color(0xFFD1FAE5),
      darkStart: Color(0xFF022C22),
      darkEnd: Color(0xFF064E3B),
    ),
    _CategoryItem(
      assetPath: 'assets/icons/support.png',
      label: 'Help',
      lightStart: Color(0xFFE0F7FA),
      lightEnd: Color(0xFFB2EBF2),
      darkStart: Color(0xFF002427),
      darkEnd: Color(0xFF00363A),
    ),
    _CategoryItem(
      assetPath: 'assets/icons/exam.png',
      label: 'Applications',
      lightStart: Color(0xFFFEF9EE),
      lightEnd: Color(0xFFFEF0C7),
      darkStart: Color(0xFF3D2000),
      darkEnd: Color(0xFF633200),
    ),
    _CategoryItem(
      assetPath: 'assets/icons/counselling.png',
      label: 'Assistance',
      lightStart: Color(0xFFEFF6FF),
      lightEnd: Color(0xFFDBEAFE),
      darkStart: Color(0xFF0C1A3D),
      darkEnd: Color(0xFF1E3A5F),
    ),
  ];

  VoidCallback _callbackFor(int index) => [
    widget.onCollegesTap,
    widget.onPredictorTap,
    widget.onCutoffTap,
    widget.onHelpTap,
    widget.onApplicationsTap,
    widget.onAssistanceTap,
  ][index];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      // decoration: BoxDecoration(
      //   color: widget.isDark ? const Color(0xFF1C1C2E) : Colors.white,
      //   borderRadius: BorderRadius.circular(24),
      //   border: Border.all(
      //     color: widget.isDark
      //         ? Colors.white.withOpacity(0.06)
      //         : Colors.black.withOpacity(0.05),
      //   ),
      //   boxShadow: widget.isDark
      //       ? null
      //       : [
      //           BoxShadow(
      //             color: Colors.black.withOpacity(0.06),
      //             blurRadius: 20,
      //             offset: const Offset(0, 6),
      //           ),
      //         ],
      // ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: _items.length,
        itemBuilder: (_, i) => _buildTile(i),
      ),
    );
  }

  Widget _buildTile(int index) {
    final isPressed = index == _pressedIndex;
    final item = _items[index];
    final isDark = widget.isDark;

    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        setState(() => _pressedIndex = index);
      },
      onTapCancel: () => setState(() => _pressedIndex = null),
      onTap: () {
        setState(() => _pressedIndex = null);
        _callbackFor(index)();
      },
      child: AnimatedScale(
        scale: isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── ICON TILE ────────────────────────────────────────
            SizedBox(
              height: 80,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                width: double.infinity,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(22),
                //   gradient: LinearGradient(
                //     begin: Alignment.topLeft,
                //     end: Alignment.bottomRight,
                //     colors: isDark
                //         ? [item.darkStart, item.darkEnd]
                //         : [item.lightStart, item.lightEnd],
                //   ),
                //   boxShadow: [
                //     BoxShadow(
                //       color: (isDark ? item.darkEnd : item.lightEnd)
                //           .withOpacity(isPressed ? 0.2 : 0.5),
                //       blurRadius: isPressed ? 6 : 14,
                //       offset: const Offset(0, 5),
                //       spreadRadius: -2,
                //     ),
                //   ],
                // ),
                // ── Image.asset — no network needed ──────────────
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Image.asset(
                    item.assetPath,
                    fit: BoxFit.contain,
                    // Black background removal:
                    // Your PNGs have black bg — use ColorFiltered
                    // to make black transparent if needed:
                    //
                    // colorBlendMode: BlendMode.multiply,
                    // color: Colors.white,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.broken_image_rounded,
                      color: isDark ? Colors.white30 : Colors.black26,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),

            // ── LABEL ────────────────────────────────────────────
            Text(
              item.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.abel(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[300] : const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data class ───────────────────────────────────────────────────────────────
class _CategoryItem {
  final String assetPath; // ← local asset, NOT a URL
  final String label;
  final Color lightStart;
  final Color lightEnd;
  final Color darkStart;
  final Color darkEnd;

  const _CategoryItem({
    required this.assetPath,
    required this.label,
    required this.lightStart,
    required this.lightEnd,
    required this.darkStart,
    required this.darkEnd,
  });
}
