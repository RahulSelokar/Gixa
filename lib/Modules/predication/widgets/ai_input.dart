import 'package:flutter/material.dart';

class AiInput extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final Function(String) onChanged;
  final bool isDark;
  final TextInputType keyboard;

  const AiInput({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.onChanged,
    required this.isDark,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}