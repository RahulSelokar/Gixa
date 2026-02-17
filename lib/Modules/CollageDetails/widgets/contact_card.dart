import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactCard extends StatelessWidget {
  final CollegeDetail college;
  // Using a slightly more vibrant blue for accents
  final Color kPrimaryBlue = const Color(0xFF1565C0); 

  const ContactCard({
    super.key,
    required this.college,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Efficient Early Return
    if (college.contactName.isEmpty && 
        college.contactEmail.isEmpty && 
        college.contactMobile.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- Theme Palette ---
    final Color cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color titleColor = isDark ? Colors.white : const Color(0xFF111111);
    final Color borderColor = isDark ? const Color(0xFF333333) : Colors.grey.shade200;
    final Color iconBgBase = isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kPrimaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.contact_phone_rounded, color: kPrimaryBlue, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              "Contact Information",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Main Contact Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: isDark ? [] : [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Person / Authority Section
              if (college.contactName.isNotEmpty) ...[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                      child: Icon(
                        Icons.person_rounded,
                        color: isDark ? Colors.grey[400] : Colors.grey[500],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            college.contactName,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: titleColor,
                            ),
                          ),
                          if (college.contactDesignation.isNotEmpty)
                            Text(
                              college.contactDesignation,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Divider if contact methods exist
                if (college.contactEmail.isNotEmpty || college.contactMobile.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
                    ),
                  ),
              ],

              // 2. Communication Channels
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    if (college.contactEmail.isNotEmpty)
                      _ContactRow(
                        icon: Icons.email_rounded,
                        value: college.contactEmail,
                        accentColor: kPrimaryBlue, // Blue for Email
                        isDark: isDark,
                        iconBg: iconBgBase,
                      ),
                    
                    if (college.contactEmail.isNotEmpty && college.contactMobile.isNotEmpty)
                      const SizedBox(height: 12),
                
                    if (college.contactMobile.isNotEmpty)
                      _ContactRow(
                        icon: Icons.phone_rounded,
                        value: college.contactMobile,
                        accentColor: const Color(0xFF10B981), // Green for Phone
                        isDark: isDark,
                        iconBg: iconBgBase,
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color accentColor;
  final bool isDark;
  final Color iconBg;

  const _ContactRow({
    required this.icon,
    required this.value,
    required this.accentColor,
    required this.isDark,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? accentColor.withOpacity(0.15) : accentColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: accentColor,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: SelectableText( // Made selectable so users can copy
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              // If it's email/phone, color it slightly to indicate it's important
              color: isDark ? Colors.grey[200] : Colors.grey[800], 
            ),
          ),
        ),
      ],
    );
  }
}