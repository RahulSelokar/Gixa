import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/counselling_state_model.dart';
import '../widgets/shared_widgets.dart';

class DocumentsSection extends StatelessWidget {
  final List<String> documents;

  const DocumentsSection({required this.documents});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: documents.map((doc) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : GixaColors.violetLight,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : GixaColors.violet.withOpacity(0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (b) =>
                    GixaColors.primaryGradient.createShader(b),
                child: const Icon(
                  Icons.insert_drive_file_outlined,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                doc,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.grey.shade300
                      : const Color(0xFF3B2068),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}