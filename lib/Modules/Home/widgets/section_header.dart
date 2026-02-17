import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.bold)),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text("See All",
                style: GoogleFonts.poppins(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}
