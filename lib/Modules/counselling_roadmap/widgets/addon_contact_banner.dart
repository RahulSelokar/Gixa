import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/counselling_state_model.dart';
import '../widgets/shared_widgets.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:Gixa/Modules/addon_contact/controller/addon_contact_controller.dart';

class AddonContactBanner extends StatelessWidget {
  final bool isDark;

  const AddonContactBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final AddonContactController addonContactController = Get.isRegistered<AddonContactController>() 
        ? Get.find<AddonContactController>() 
        : Get.put(AddonContactController());

    return Obx(() {
      if (addonContactController.isLoading.value) {
        return Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1B1B2B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: CounsellingUi.border(isDark)),
          ),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      }

      final data = addonContactController.addonContactData.value;
      if (data == null || (data.addonContact.isEmpty && data.addonWhatsappLink.isEmpty)) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark 
                ? [const Color(0xFF2E1A47), const Color(0xFF1E1E2E)] 
                : [const Color(0xFFF3E8FF), const Color(0xFFFFFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF9B2FC8).withOpacity(0.4) : const Color(0xFF9B2FC8).withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9B2FC8).withOpacity(isDark ? 0.2 : 0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9B2FC8), Color(0xFF6B21A8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9B2FC8).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Premium Counsellor",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF4C1D95),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Connect directly with your personal expert.",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (data.addonWhatsappLink.isNotEmpty) ...[
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(data.addonWhatsappLink);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.chat_rounded, size: 18, color: Colors.white),
                label: const Text(
                  "Chat",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981), // Emerald Green
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shadowColor: const Color(0xFF10B981).withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100), // Pill shape
                  ),
                ),
              ),
            ] else if (data.addonContact.isNotEmpty) ...[
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse('tel:${data.addonContact}');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
                icon: const Icon(Icons.call_rounded, size: 18, color: Colors.white),
                label: const Text(
                  "Call",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6), // Blue
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shadowColor: const Color(0xFF3B82F6).withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100), // Pill shape
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}