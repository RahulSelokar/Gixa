import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gixa/Modules/Assistance/controller/request_guidance_controller.dart';
import 'package:Gixa/Modules/Assistance/model/request_guidance_model.dart';

class RequestGuidanceDialog extends StatefulWidget {
  final int counselorId;
  final String counselorName;

  const RequestGuidanceDialog({
    super.key,
    required this.counselorId,
    required this.counselorName,
  });

  @override
  State<RequestGuidanceDialog> createState() => _RequestGuidanceDialogState();
}

class _RequestGuidanceDialogState extends State<RequestGuidanceDialog> {
  late final RequestGuidanceController controller;

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final messageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(RequestGuidanceController());
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    mobileCtrl.dispose();
    messageCtrl.dispose();
    Get.delete<RequestGuidanceController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ───────── HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "request_guidance_header".tr,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// ───────── COUNSELOR CARD
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: colorScheme.primary,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.counselorName,
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// ───────── FORM
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField("first_name".tr, firstNameCtrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField("last_name".tr, lastNameCtrl),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  "mobile_number".tr,
                  mobileCtrl,
                  keyboard: TextInputType.phone,
                ),

                const SizedBox(height: 16),

                _buildTextField("how_can_we_help".tr, messageCtrl, maxLines: 4),

                const SizedBox(height: 24),

                /// ───────── SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text("submit_request".tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ─────────────────────────────────────────────
  /// 🚀 HANDLE SUBMIT
  /// ─────────────────────────────────────────────
  void _handleSubmit() {
    controller.submit(
      RequestGuidanceRequest(
        counselorId: widget.counselorId,
        firstName: firstNameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        mobileNumber: mobileCtrl.text.trim(),
        message: messageCtrl.text.trim(),
      ),
    );
  }

  /// ─────────────────────────────────────────────
  /// 🧾 TEXT FIELD BUILDER
  /// ─────────────────────────────────────────────
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
