import 'package:Gixa/common/langauge/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LangaugePage extends StatelessWidget {
  LangaugePage({super.key});

  final LanguageController languageController = Get.put(LanguageController());
  final Map<String, String> languages = const {
    'en': 'English',
    'hi': 'हिंदी',
    'mr': 'मराठी',
    'te': 'తెలుగు',
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF121212) : Colors.white;
    final surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final border = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor =
        isDark ? Colors.grey[400]! : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('settings'.tr),
        backgroundColor: bg,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _sectionTitle('general'.tr),

          // =========================
          // LANGUAGE DROPDOWN
          // =========================
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
            ),
            child: Obx(() {
              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value:
                      languageController.locale.value.languageCode,
                  isExpanded: true,
                  icon: Icon(Icons.language, color: textColor),
                  dropdownColor: surface,
                  style: GoogleFonts.poppins(color: textColor),

                  items: languages.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),

                  onChanged: (value) {
                    if (value == null) return;

                    // ✅ INSTANT APP-WIDE UPDATE
                    languageController.changeLanguage(value);
                  },
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          // =========================
          // INFO TEXT
          // =========================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'language_change_hint'.tr,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: subtitleColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // SECTION TITLE
  // =========================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }
}
