import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeSearchBar extends StatelessWidget {
  final Color background;
  final Color hintColor;

  const HomeSearchBar({
    super.key,
    required this.background,
    required this.hintColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: hintColor.withOpacity(0.2), width: 1),
      ),
      child: TextField(
        readOnly: true, // ✅ Prevent keyboard
        decoration: InputDecoration(
          hintText: "Search Colleges, Exams...",
          hintStyle: GoogleFonts.poppins(color: hintColor),
          prefixIcon: Icon(Icons.search, color: hintColor),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
