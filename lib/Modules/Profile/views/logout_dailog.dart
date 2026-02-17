import 'package:Gixa/services/logout_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLogoutConfirmationDialog() {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: const _LogoutDialogUI(),
    ),
    barrierDismissible: false, // Force user to choose
    transitionDuration: const Duration(milliseconds: 300),
  );
}

class _LogoutDialogUI extends StatelessWidget {
  const _LogoutDialogUI();

  @override
  Widget build(BuildContext context) {
    // Theme detection
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Professional Color Palette
    final bgColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF111827);
    final bodyColor = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final dangerColor = const Color(0xFFDC2626); // Professional Red
    final dangerBg = const Color(0xFFFEF2F2);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Icon Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? dangerColor.withOpacity(0.15) : dangerBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.logout_rounded,
              color: dangerColor,
              size: 32,
            ),
          ),
          
          const SizedBox(height: 20),

          // 2. Title
          Text(
            "Log Out?",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          
          const SizedBox(height: 10),

          // 3. Subtitle / Content
          Text(
            "Are you sure you want to sign out? You'll need to login again to access your account.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: bodyColor,
            ),
          ),

          const SizedBox(height: 28),

          // 4. Action Buttons
          Row(
            children: [
              // Cancel Button
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: bodyColor,
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),

              // Logout Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    // 1. Close the Confirmation Dialog
                    Get.back();

                    // 2. Show a cleaner Loading Dialog
                    _showLoadingDialog(context, isDark);

                    // 3. Perform Logout
                    await SessionService.logout();
                    
                    // Note: If SessionService.logout() navigates away (e.g., Get.offAllNamed('/login')),
                    // you don't need to manually close the loading dialog.
                    // If it doesn't navigate, you might need Get.back() here after await.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dangerColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: dangerColor.withOpacity(0.4),
                  ),
                  child: const Text(
                    "Log Out",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Shows a small, clean loading box instead of a full screen raw spinner
  void _showLoadingDialog(BuildContext context, bool isDark) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
              const SizedBox(width: 20),
              Text(
                "Signing out...",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}