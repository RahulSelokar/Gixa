import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AIMatchCard extends StatelessWidget {
  const AIMatchCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- Theme Palette ---
    final Color kPrimaryBlue = const Color(0xFF2979FF); // Brighter blue for AI
    
    // Background: Light = Soft Blue Tint | Dark = Deep Midnight Blue
    final Color cardBg = isDark ? const Color(0xFF101929) : const Color(0xFFEEF6FF);
    
    // Border: Subtle outline to define the AI section
    final Color borderColor = isDark ? const Color(0xFF1E2E45) : const Color(0xFFD6E4FF);
    
    // Text Colors
    final Color titleColor = isDark ? Colors.white : const Color(0xFF111111);
    final Color bodyColor = isDark ? Colors.grey[300]! : const Color(0xFF555555);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: kPrimaryBlue.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // AI Icon with Gradient
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kPrimaryBlue, const Color(0xFF00B0FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryBlue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome, // Sparkles for AI
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              
              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gixa AI Match",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryBlue,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "Why this matches you?",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Divider Line (Subtle)
          Container(
            height: 1,
            width: double.infinity,
            color: isDark ? Colors.white.withOpacity(0.05) : kPrimaryBlue.withOpacity(0.1),
          ),
          const SizedBox(height: 16),

          // Analysis Text
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                color: bodyColor,
                fontSize: 14,
                height: 1.6, // Better readability
              ),
              children: [
                const TextSpan(
                  text: "Based on your NEET mock score of ",
                ),
                TextSpan(
                  text: "245",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const TextSpan(
                  text: ", our AI predicts a ",
                ),
                TextSpan(
                  text: "95% probability",
                  style: GoogleFonts.poppins(
                    color: isDark ? const Color(0xFF64B5F6) : kPrimaryBlue, // Lighter blue in dark mode
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text: " of securing a seat in Mechanical or Chemical Engineering here.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}