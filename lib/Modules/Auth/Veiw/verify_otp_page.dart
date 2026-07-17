import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:Gixa/common/app_colors.dart';
import 'package:Gixa/utils/constants/colors.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../controllers/otp_controller.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final controller = Get.find<OtpController>();

  // Theme
  final Color primaryColor = kHomeAccentColor;
  final Color textDark = const Color(0xFF1A1A2E);
  final Color textGrey = const Color(0xFF9E9EA7);
  final Color borderColor = UColors.border;
  final GlobalKey<_OtpInputFieldState> otpKey = GlobalKey();

  Worker? _otpLogger;

  String _formatCountdown(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller.otp.value = '';
    listenOtp();

    if (controller.otpFromBackend.value.isNotEmpty) {
      debugPrint('Received OTP: ${controller.otpFromBackend.value}');
    }

    _otpLogger = ever<String>(controller.otpFromBackend, (receivedOtp) {
      if (receivedOtp.isNotEmpty) {
        debugPrint('Received OTP: $receivedOtp');
      }
    });
  }

  Future<void> listenOtp() async {
    await SmsAutoFill().listenForCode;

    SmsAutoFill().code.listen((code) {
      if (code != null && code.length == 6) {
        controller.otp.value = code;

        // 🔥 Fill UI fields
        _fillOtpFields(code);

        // 🔥 Auto verify
        controller.verifyOtp();
      }
    });
  }

  void _fillOtpFields(String otp) {
    otpKey.currentState?.fillOtp(otp);
  }

  @override
  void dispose() {
    _otpLogger?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            _buildBackgroundGlow(),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildBackButton(),
                    const SizedBox(height: 36),
                    _buildIllustration(size),
                    const SizedBox(height: 24),
                    _buildStatusTag(),
                    const SizedBox(height: 16),
                    Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: UColors.primaryDark,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'Enter the code sent to ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textGrey,
                                  height: 1.6,
                                ),
                                children: [
                                  TextSpan(
                                    text: '+91 ${controller.mobileNumber.value}',
                                    style: TextStyle(
                                      color: UColors.primaryDark,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: UColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.edit_rounded,
                                    size: 14,
                                    color: UColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: UColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: UColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: UColors.secondary.withOpacity(0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Obx(
                            () => OtpInputField(
                              key: otpKey,
                              primaryColor: primaryColor,
                              textDark: textDark,
                              resetTrigger:
                                  controller.otpInputResetTrigger.value,
                              onCompleted: (otp) {
                                controller.otp.value = otp;
                                controller.verifyOtp();
                              },
                            ),
                          ),
                          const SizedBox(height: 28),
                          _buildTimerSection(),
                          const SizedBox(height: 28),
                          _buildVerifyButton(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== WIDGETS =====================

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: UColors.softSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: UColors.border),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 17,
          color: textDark,
        ),
      ),
    );
  }

  Widget _buildIllustration(Size size) {
    return Center(
      child: Container(
        height: size.width * 0.58,
        width: size.width * 0.58,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              UColors.secondary.withOpacity(0.10),
              UColors.primaryLight.withOpacity(0.10),
              UColors.primary.withOpacity(0.10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          border: Border.all(color: UColors.border),
        ),
        child: Center(
          child: SizedBox(
            height: size.width * 0.48,
            width: size.width * 0.48,
            child: Lottie.asset('assets/lottie/verify_otp.json'),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundGlow() {
    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -30,
          child: Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              color: UColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 120,
          right: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: UColors.secondary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: UColors.softAccent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: UColors.primaryLight.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.verified_user_rounded,
            size: 16,
            color: UColors.primaryLight,
          ),
          SizedBox(width: 8),
          Text(
            'Secure verification',
            style: TextStyle(
              color: UColors.primaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSection() {
    return Obx(() {
      if (controller.canResendOtp.value) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive the OTP? ",
                style: TextStyle(fontSize: 13, color: textGrey),
              ),
              GestureDetector(
                onTap: () => controller.resendOtp(),
                child: Text(
                  'Resend',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer_outlined, size: 16, color: textGrey),
              const SizedBox(width: 6),
              Text(
                'Resend code in ',
                style: TextStyle(fontSize: 13, color: textGrey),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: UColors.softSurface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: UColors.border),
                ),
                child: Text(
                  _formatCountdown(controller.secondsRemaining.value),
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: controller.verifyOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: kHomeBrandGradient,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: UColors.primaryDark, width: 1),
          ),
          child: const Center(
            child: Text(
              'Submit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= OTP INPUT FIELD =================

class OtpInputField extends StatefulWidget {
  final Function(String) onCompleted;
  final Color primaryColor;
  final Color textDark;
  final int resetTrigger;

  const OtpInputField({
    super.key,
    required this.onCompleted,
    required this.primaryColor,
    required this.textDark,
    required this.resetTrigger,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void didUpdateWidget(covariant OtpInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resetTrigger != widget.resetTrigger) {
      _clearFields();
    }
  }

  void fillOtp(String otp) {
    for (int i = 0; i < otp.length && i < _controllers.length; i++) {
      _controllers[i].text = otp[i];
    }

    final fullOtp = _controllers.map((e) => e.text).join();
    widget.onCompleted(fullOtp);
  }

  void _clearFields() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var n in _focusNodes) n.dispose();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        final otp = _controllers.map((e) => e.text).join();
        widget.onCompleted(otp);
      }
    }
    if (value.isEmpty && index > 0) {
      _controllers[index - 1].text = '';
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 46,
          height: 56,
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) {
              if (event.runtimeType == RawKeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace) {
                if (_controllers[index].text.isEmpty && index > 0) {
                  _controllers[index - 1].text = '';
                  _focusNodes[index - 1].requestFocus();
                }
              }
            },
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: widget.textDark,
              ),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: UColors.softSurface,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: UColors.border, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: UColors.border,
                    width: 1.5,
                  ),
                ),
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

// ================= SESSION CONFLICT DIALOG =================

void showAlreadyLoggedInDialog({
  required String message,
  VoidCallback? onForceLogout,
}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final dangerColor = const Color(0xFFEF4444);
    final titleColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF9E9EA7);
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final cancelBgColor = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF5F5F8);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 90,
            width: 90,
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: dangerColor.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
              image: const DecorationImage(
                image: AssetImage('assets/images/genie_doctor_logout.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            "Session Conflict",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: titleColor,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: bodyColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    backgroundColor: cancelBgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: bodyColor,
                      fontSize: 14,
                    ),
                  ),
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
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Logout Others",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
