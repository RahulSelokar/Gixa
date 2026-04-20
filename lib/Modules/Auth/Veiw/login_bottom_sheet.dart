import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Gixa/routes/app_routes.dart';

class LoginBottomSheet extends StatelessWidget {
  const LoginBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const Icon(Icons.lock_outline, size: 60),
            const SizedBox(height: 10),

            const Text(
              "Login Required",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Please login to continue using this feature",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // close bottom sheet
                  Get.toNamed(AppRoutes.loginWithOtp);
                },
                child: const Text("Login / Register"),
              ),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Maybe Later"),
            ),
          ],
        ),
      ),
    );
  }
}