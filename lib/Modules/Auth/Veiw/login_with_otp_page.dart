import 'package:Gixa/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';

import '../controllers/otp_controller.dart';

class LoginWithOtpPage extends StatelessWidget {
  LoginWithOtpPage({super.key});

  final controller = Get.put(OtpController());
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Modern Indigo Primary Color
  final Color primaryColor = const Color(0xFF4F46E5);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    // Theme Colors
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final borderColor = isDark ? Colors.white12 : Colors.grey[200];

    return Scaffold(
      backgroundColor: primaryColor, 
      resizeToAvoidBottomInset: true, 
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // ================== HEADER SECTION ==================
            // Contains Lottie and Title
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: size.height * 0.35,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Align(
                    //   alignment: Alignment.topLeft,
                    //   child: IconButton(
                    //     icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    //     onPressed: () => Get.back(),
                    //   ),
                    // ),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          height: 160,
                          child: Lottie.asset('assets/lottie/otp.json'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ================== BOTTOM SHEET SECTION ==================
            // Contains the Form
            Positioned(
              top: size.height * 0.32,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your mobile number to receive a verification code.',
                          style: TextStyle(
                            fontSize: 15,
                            color: subTextColor,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Input Field
                        _buildPhoneInput(
                          context,
                          isDark,
                          surfaceColor,
                          textColor,
                          borderColor,
                        ),

                        const SizedBox(height: 32),

                        // Action Button
                        _buildLoginButton(),

                        const SizedBox(height: 32),

                        // Divider
                        _buildDivider(isDark, subTextColor),

                        const SizedBox(height: 32),

                        // Google Button
                        _buildGoogleButton(isDark, borderColor, textColor),

                        const SizedBox(height: 40),

                        // Footer
                        _buildTermsText(subTextColor),
                        
                        // Extra padding for keyboard
                        SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 200 : 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================== WIDGETS ==================

  Widget _buildPhoneInput(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color? borderColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Mobile Number",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
            letterSpacing: 1.2,
          ),
          decoration: InputDecoration(
            hintText: '00000 00000',
            hintStyle: TextStyle(color: Colors.grey[400], letterSpacing: 1.2),
            filled: true,
            fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            counterText: '',
            prefixIcon: Container(
              width: 60,
              alignment: Alignment.center,
              child: Text(
                "+91",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.grey[300] : Colors.black87,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor ?? Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor ?? Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Mobile number required';
            if (value.length != 10) return 'Enter 10-digit number';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Obx(() => SizedBox(
      height: 58,
      child: ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  await controller.sendOtp(phoneController.text);
                  Get.toNamed(
                    AppRoutes.verifyOtp,
                    arguments: {'mobileNumber': phoneController.text},
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          elevation: 5,
          shadowColor: primaryColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get OTP',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                ],
              ),
      ),
    ));
  }

  Widget _buildDivider(bool isDark, Color? subTextColor) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDark ? Colors.white12 : Colors.grey[200],
            thickness: 1.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Or continue with",
            style: TextStyle(
              color: subTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDark ? Colors.white12 : Colors.grey[200],
            thickness: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton(bool isDark, Color? borderColor, Color textColor) {
    return SizedBox(
      height: 58,
      child: OutlinedButton(
        onPressed: () {
          print("Google Login Pressed");
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? Colors.transparent : Colors.white,
          side: BorderSide(color: borderColor ?? Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ensure you have this asset
            Image.asset(
              'assets/icons/google.png',
              height: 24,
              width: 24,
              errorBuilder: (ctx, err, stack) => Icon(Icons.g_mobiledata, size: 28, color: textColor),
            ),
            const SizedBox(width: 12),
            Text(
              "Google",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsText(Color? subTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text.rich(
        TextSpan(
          text: "By continuing, you agree to our ",
          style: TextStyle(fontSize: 12, color: subTextColor, height: 1.5),
          children: [
            TextSpan(
              text: "Terms of Service",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const TextSpan(text: " and "),
            TextSpan(
              text: "Privacy Policy",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}