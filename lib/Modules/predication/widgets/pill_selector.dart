import 'package:flutter/material.dart';

class PillSelector extends StatelessWidget {
  final List<String> items;
  final List<String> values;
  final String selected;
  final Function(String) onTap;
  final bool isDark;

  const PillSelector({
    super.key,
    required this.items,
    required this.values,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(items.length, (i) {
        final sel = selected == values[i];
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(values[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: sel ? Colors.indigo : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  items[i],
                  style: TextStyle(
                      color: sel ? Colors.white : Colors.black),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}