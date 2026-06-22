import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gixa/common/utils/app_responsive.dart';

class HomeSearchBar extends StatelessWidget {
  final Color background;
  final Color hintColor;

  const HomeSearchBar({
    super.key,
    required this.background,
    required this.hintColor,
  });

  /// 🔥 GIXA BRAND GRADIENT
  static const LinearGradient gixaGradient = LinearGradient(
    colors: [
      Color(0xFFFF7A18), // orange
      Color(0xFFFF3D77), // pink
      Color(0xFF8E2DE2), // purple
      Color(0xFF4A00E0), // blue
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    final isTablet = AppResponsive.isTablet(context);

    return Container(
      height: isTablet ? 58 : 50,

      /// 🔥 Gradient Border Wrapper
      decoration: BoxDecoration(
        gradient: gixaGradient,
        borderRadius: BorderRadius.circular(18),
      ),

      /// 🔥 Inner Container (actual search box)
      child: Container(
        margin: const EdgeInsets.all(1.2), // border thickness
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          readOnly: true,

          /// ✅ ADD THIS
          style: GoogleFonts.inter(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            fontSize: isTablet ? 15 : 14,
            fontWeight: FontWeight.w500,
          ),

          decoration: InputDecoration(
            hintText: "Search Colleges",

            hintStyle: GoogleFonts.inter(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromARGB(255, 239, 236, 236)
                  : const Color.fromARGB(255, 20, 19, 19),
              fontWeight: FontWeight.w500,
              fontSize: isTablet ? 15 : 14,
            ),

            prefixIcon: Icon(
              Icons.search,
              color: const Color(0xFFFF7A18),
              size: isTablet ? 24 : 22,
            ),

            border: InputBorder.none,

            contentPadding: EdgeInsets.symmetric(vertical: isTablet ? 17 : 14),
          ),
        ),
      ),
    );
  }
}
