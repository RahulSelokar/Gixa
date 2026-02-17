import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutSection extends StatelessWidget {
  final CollegeDetail college;

  const AboutSection({
    super.key,
    required this.college,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // --- Theme Palette ---
    final Color titleColor = isDark ? Colors.white : const Color(0xFF111111);
    final Color bodyColor = isDark ? Colors.grey[400]! : const Color(0xFF666666);
    final Color iconColor = isDark ? Colors.blue[300]! : Colors.blue[700]!;

    // Fallback text if API returns empty string
    final String description = college.about.isNotEmpty
        ? college.about
        : "${college.name} is one of the premier institutes created to be a Centre of Excellence for training, research, and development in science, engineering, and technology. It offers a wide range of undergraduate and postgraduate programs with state-of-the-art facilities.";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(Icons.info_outline_rounded, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text(
              "About Institute",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Expandable Body Text
        _ExpandableText(
          text: description,
          textColor: bodyColor,
          linkColor: iconColor,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// 🔽 Helper Widget for "Read More" Logic
// ─────────────────────────────────────────────
class _ExpandableText extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color linkColor;

  const _ExpandableText({
    required this.text,
    required this.textColor,
    required this.linkColor,
  });

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool isExpanded = false;
  static const int maxLines = 4;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Create a TextSpan to measure
        final span = TextSpan(
          text: widget.text,
          style: GoogleFonts.poppins(
            fontSize: 14,
            height: 1.6, // Good line height for readability
          ),
        );

        // Use TextPainter to determine if text exceeds maxLines
        final tp = TextPainter(
          text: span,
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);

        // Check if text overflows
        final bool isOverflowing = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The Text Content
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topLeft,
              child: Text(
                widget.text,
                maxLines: isExpanded ? null : maxLines,
                overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: widget.textColor,
                  height: 1.6,
                ),
              ),
            ),
            
            // The "Read More" Button (Only show if overflowing)
            if (isOverflowing) ...[
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isExpanded ? "Read Less" : "Read More",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: widget.linkColor,
                      ),
                    ),
                    Icon(
                      isExpanded 
                        ? Icons.keyboard_arrow_up_rounded 
                        : Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: widget.linkColor,
                    )
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}