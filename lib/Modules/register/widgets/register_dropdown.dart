import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class RegisterDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String hint;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;

  const RegisterDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.hint,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    /// 🛡 Prevent crash if value is not in items
    final T? safeValue = items.contains(value) ? value : null;

    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        value: safeValue,

        /// 📝 HINT
        hint: Text(
          hint,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF94A3B8), // slate-400
          ),
        ),

        /// 📋 ITEMS
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              labelBuilder(item),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B), // slate-800
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),

        onChanged: onChanged,

        /// 🔘 BUTTON (FIELD)
        buttonStyleData: ButtonStyleData(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE2E8F0), // slate-200
              width: 1,
            ),
          ),
        ),

        /// 🔽 DROPDOWN MENU
        dropdownStyleData: DropdownStyleData(
          maxHeight: 260,
          elevation: 6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(8),
            thickness: WidgetStateProperty.all(4),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),

        /// 📌 ITEM STYLE
        menuItemStyleData: const MenuItemStyleData(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),

        /// 🔽 ICON
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 26,
            color: Color(0xFF64748B), // slate-500
          ),
        ),

        /// 🎯 ALIGNMENT
        dropdownSearchData: null, // no search (clean UX)
      ),
    );
  }
}
