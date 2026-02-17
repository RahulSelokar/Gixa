import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/otp_controller.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final controller = Get.find<OtpController>();
  final Color primaryColor = const Color(0xFF4F46E5);

  @override
  void initState() {
    super.initState();
    controller.otp.value = '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    // Theme Colors
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: primaryColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // ================== HEADER SECTION ==================
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: size.height * 0.35,
              child: SafeArea(
                child: Column(
                  children: [
                    // Back Button
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          height: 140,
                          width: 140,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Lottie.asset(
                            'assets/lottie/verify_otp.json',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ================== BOTTOM SHEET SECTION ==================
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      Text(
                        'Verification Code',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Subtitle with Phone Number
                      Obx(() => RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'We have sent the code verification to\n',
                          style: TextStyle(
                            fontSize: 14,
                            color: subTextColor,
                            height: 1.5,
                            fontFamily: theme.textTheme.bodyMedium?.fontFamily,
                          ),
                          children: [
                            TextSpan(
                              text: "+91 ${controller.mobileNumber.value}",
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      )),

                      const SizedBox(height: 40),

                      // OTP Input
                      OtpInputField(
                        isDark: isDark,
                        primaryColor: primaryColor,
                        onCompleted: (otp) {
                          controller.otp.value = otp;
                          controller.verifyOtp();
                        },
                      ),

                      const SizedBox(height: 32),

                      // Timer & Resend
                      _buildTimerSection(primaryColor, subTextColor),

                      const SizedBox(height: 40),

                      // Verify Button
                      _buildVerifyButton(),
                      
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 200 : 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerSection(Color primaryColor, Color? subTextColor) {
    return Obx(() {
      if (controller.canResendOtp.value) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive code?",
              style: TextStyle(color: subTextColor, fontSize: 14),
            ),
            TextButton(
              onPressed: () {
                controller.resendOtp();
                controller.otp.value = "";
                // Reset fields logic is handled inside controller or rebuilding widget
              },
              child: Text(
                'Resend Again',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer_outlined, size: 18, color: subTextColor),
            const SizedBox(width: 8),
            Text(
              'Resend code in ',
              style: TextStyle(color: subTextColor, fontSize: 14),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '00:${controller.secondsRemaining.value.toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      }
    });
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      height: 58,
      child: ElevatedButton(
        onPressed: controller.verifyOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: primaryColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Verify & Proceed',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ================= NEW OTP INPUT =================
class OtpInputField extends StatefulWidget {
  final Function(String) onCompleted;
  final bool isDark;
  final Color primaryColor;

  const OtpInputField({
    super.key,
    required this.onCompleted,
    required this.isDark,
    required this.primaryColor,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  // Using 6 controllers for 6 boxes
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    // 1. If text entered, move next
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last digit entered
        _focusNodes[index].unfocus();
        String otp = _controllers.map((e) => e.text).join();
        widget.onCompleted(otp);
      }
    }
    // 2. Backspace logic is usually handled by RawKeyboardListener or 
    // simply detection empty on change doesn't always work perfectly for backspace 
    // on empty fields in stock Flutter TextField without a package. 
    // However, keeping it simple for this snippet:
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 48, 
          height: 60,
          child: RawKeyboardListener(
            focusNode: FocusNode(), // Dummy node for listener
            onKey: (event) {
              if (event.runtimeType == RawKeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace &&
                  _controllers[index].text.isEmpty &&
                  index > 0) {
                // Handle backspace when field is empty to move back
                _focusNodes[index - 1].requestFocus();
                // Optionally clear the previous field here too if desired behavior
              }
            },
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.isDark ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                counterText: "",
                filled: true,
                fillColor: widget.isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                contentPadding: EdgeInsets.zero,
                // Default Border
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                // Focused Border
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.primaryColor, width: 2),
                ),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => _onChanged(value, index),
            ),
          ),
        );
      }),
    );
  }
}

// ================= DIALOG =================
void showAlreadyLoggedInDialog({
  required String message,
  VoidCallback? onForceLogout,
}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _ModernSessionDialog(
        message: message,
        onForceLogout: onForceLogout,
      ),
    ),
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 300),
  );
}

class _ModernSessionDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onForceLogout;

  const _ModernSessionDialog({required this.message, this.onForceLogout});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final bodyColor = isDark ? Colors.grey[400] : const Color(0xFF64748B);
    final dangerColor = const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: dangerColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.warning_amber_rounded, color: dangerColor, size: 32),
          ),
          const SizedBox(height: 20),
          Text(
            "Session Conflict",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: titleColor),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.5, color: bodyColor),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.w600, color: bodyColor)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    if (onForceLogout != null) onForceLogout!();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dangerColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Logout Others", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}