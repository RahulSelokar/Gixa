import 'package:Gixa/Modules/CollageDetails/controller/collage_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CollegeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CollegeDetailController controller;
  
  const CollegeAppBar({
    super.key,
    required this.controller,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- Theme Palette ---
    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF111111);
    final Color iconColor = isDark ? Colors.grey[300]! : const Color(0xFF333333);
    final Color borderColor = isDark ? const Color(0xFF333333) : Colors.grey.shade200;
    
    // Brand Color
    final Color kPrimaryBlue = const Color(0xFF1565C0);

    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      scrolledUnderElevation: 0, // Prevents color change on scroll in Material 3
      
      // Handle Status Bar Icons (White icons on Dark mode, Black on Light)
      systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      
      // Bottom Border for separation
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: borderColor,
          height: 1.0,
        ),
      ),

      // Leading: Back Button
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: iconColor, size: 20),
        onPressed: () => Get.back(),
        tooltip: "Back",
      ),

      // Title: Brand + College Name
      centerTitle: true,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Brand Label (Small)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: kPrimaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "GIXA AI VERIFIED",
              style: GoogleFonts.poppins(
                color: kPrimaryBlue,
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 2),
          
          // College Name (Reactive)
          Obx(() {
            final name = controller.college.value?.name ?? "College Details";
            return Text(
              name,
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }),
        ],
      ),

      // Actions: Share
      // actions: [
      //   IconButton(
      //     icon: Icon(Icons.share_outlined, color: iconColor, size: 22),
      //     onPressed: () {
      //       // TODO: Implement share functionality
      //     },
      //     tooltip: "Share College",
      //   ),
      //   const SizedBox(width: 8),
      // ],
    );
  }
}