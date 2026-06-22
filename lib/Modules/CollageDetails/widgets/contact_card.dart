import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';
import 'package:Gixa/Modules/CollageDetails/widgets/collage_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatelessWidget {
  final CollegeDetail college;

  const ContactCard({super.key, required this.college});

  @override
  Widget build(BuildContext context) {
    if (college.contactName.isEmpty &&
        college.contactEmail.isEmpty &&
        college.contactMobile.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = CollegeTheme.colors(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.softFill(colors.secondary),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.contact_phone_rounded,
                color: colors.secondary,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Contact Information",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.textMain,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: colors.surfaceGradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border),
            boxShadow: colors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (college.contactName.isNotEmpty) ...[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: colors.softFill(colors.pink),
                      child: Icon(
                        Icons.person_rounded,
                        color: colors.pink,
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
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: colors.textMain,
                            ),
                          ),
                          if (college.contactDesignation.isNotEmpty)
                            Text(
                              college.contactDesignation,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: colors.textSub,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (college.contactEmail.isNotEmpty ||
                    college.contactMobile.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: colors.subtleBorder,
                    ),
                  ),
              ],
              if (college.contactEmail.isNotEmpty)
                _ContactRow(
                  icon: Icons.email_rounded,
                  displayValue: college.contactEmail,
                  actionValue: college.contactEmail,
                  accentColor: colors.secondary,
                  colors: colors,
                ),
              if (college.contactEmail.isNotEmpty &&
                  college.contactMobile.isNotEmpty)
                const SizedBox(height: 12),
              if (college.contactMobile.isNotEmpty)
                _ContactRow(
                  icon: Icons.phone_rounded,
                  displayValue: college.contactMobile,
                  actionValue: college.contactMobile,
                  accentColor: colors.primary,
                  colors: colors,
                ),
              if (college.website != null && college.website.isNotEmpty) ...[
                const SizedBox(height: 12),
                _ContactRow(
                  icon: Icons.language_rounded,
                  displayValue: "Visit Website",
                  actionValue: college.website,
                  accentColor: colors.purple,
                  colors: colors,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String displayValue;
  final String actionValue;
  final Color accentColor;
  final CollegeThemeColors colors;

  const _ContactRow({
    required this.icon,
    required this.displayValue,
    required this.actionValue,
    required this.accentColor,
    required this.colors,
  });

  Future<void> _launchAction() async {
    if (icon == Icons.phone_rounded) {
      final uri = Uri(scheme: 'tel', path: actionValue);
      await launchUrl(uri);
    } else if (icon == Icons.email_rounded) {
      final uri = Uri(scheme: 'mailto', path: actionValue);
      await launchUrl(uri);
    } else if (icon == Icons.language_rounded) {
      final uri = Uri.parse(
        actionValue.startsWith("http") ? actionValue : "https://$actionValue",
      );
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchAction,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.softFill(accentColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: accentColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              displayValue,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
