import 'package:flutter/material.dart';

class VerifiedMobileInput extends StatelessWidget {
  final String mobileNumber;

  const VerifiedMobileInput({
    super.key,
    required this.mobileNumber,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: "+91 $mobileNumber",
      readOnly: true,
      enabled: false,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF065F46), // Dark green text
      ),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

        /// 📱 PHONE ICON
        prefixIcon: const Icon(
          Icons.phone_android_rounded,
          color: Color(0xFF16A34A),
        ),

        /// ✅ GREEN TICK ONLY
        suffixIcon: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF16A34A),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            size: 20,
            color: Colors.white,
          ),
        ),

        filled: true,
        fillColor: const Color(0xFFF0FDF4),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF86EFAC),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}
