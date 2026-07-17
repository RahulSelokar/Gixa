import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSessionExpiredDialog({String? message}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _SessionExpiredDialogUI(message: message),
    ),
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 300),
  );
}

class _SessionExpiredDialogUI extends StatelessWidget {
  final String? message;

  const _SessionExpiredDialogUI({this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    
    final primaryColor = colorScheme.primary;

    // Determine if it's the specific "another device" message or generic
    bool isAnotherDevice = message != null && 
        (message!.toLowerCase().contains('another device') || 
         message!.toLowerCase().contains('already active') ||
         message!.toLowerCase().contains('invalidated') ||
         message!.toLowerCase().contains('logged in'));
         
    String displayMessage = isAnotherDevice 
        ? 'Your account is logged in on another device. You have been logged out here.' 
        : (message ?? 'Your session has expired. Please login again.');
        
    String title = isAnotherDevice ? 'Security Alert' : 'Session Expired';

    return Container(
      width: size.width * 0.85,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: theme.dialogBackgroundColor, // Fallback color
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/genie_logout_popup.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: theme.dialogBackgroundColor,
                    child: Center(
                      child: Icon(
                        isAnotherDevice ? Icons.security_rounded : Icons.timer_off_rounded,
                        size: 80,
                        color: isDark ? Colors.amber : Colors.amber.shade700,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // 2. Dark Overlay for readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.8),
                      Colors.black.withValues(alpha: 0.95),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
            
            // 3. Foreground Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 80), // Push content slightly down so image face/top is visible
                  
                  // Title
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white, // Forced white because of dark overlay
                      letterSpacing: -0.5,
                    ),
                  ),
                  
                  const SizedBox(height: 12),

                  // Subtitle / Content
                  Text(
                    displayMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Log In Again",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
