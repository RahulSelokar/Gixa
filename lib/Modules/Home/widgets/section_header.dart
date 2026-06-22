import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:Gixa/common/utils/app_responsive.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final isTablet = AppResponsive.isTablet(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              "See All",
              style: GoogleFonts.inter(
                color: kHomeAccentColor,
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 14 : 13,
              ),
            ),
          ),
      ],
    );
  }
}
