import 'dart:io';

import 'package:Gixa/Modules/Documents/view/documents_view.dart';
import 'package:Gixa/Modules/Documents/view/update_doc_page.dart';
import 'package:Gixa/Modules/updateProfile/controller/update_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({super.key});

  final _formKey = GlobalKey<FormState>();
  final UpdateProfileController controller =
      Get.find<UpdateProfileController>();

  final Color kPrimaryBlue = const Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final headerColor = isDark ? Colors.white : const Color(0xFF111111);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: headerColor,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: Text(
            'Edit Profile',
            style: GoogleFonts.poppins(
              color: headerColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),

        /// ───────── BODY ─────────
        body: Obx(
          () => Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ───── PROFILE IMAGE ─────
                      Center(
                        child: GestureDetector(
                          onTap: _pickProfileImage,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: kPrimaryBlue.withOpacity(0.1),
                                backgroundImage:
                                    controller.profileImage.value != null
                                    ? FileImage(controller.profileImage.value!)
                                    : null,
                                child: controller.profileImage.value == null
                                    ? Icon(
                                        Icons.person,
                                        size: 50,
                                        color: kPrimaryBlue,
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: kPrimaryBlue,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: bgColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// ───── PERSONAL DETAILS ─────
                      _sectionHeader("Personal Details", isDark),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _input(
                              context,
                              controller: controller.firstNameCtrl,
                              label: 'First Name',
                              validatorMsg: 'Required',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _input(
                              context,
                              controller: controller.lastNameCtrl,
                              label: 'Last Name',
                              validatorMsg: 'Required',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _input(
                        context,
                        controller: controller.addressCtrl,
                        label: 'Address',
                        maxLines: 3,
                        validatorMsg: 'Required',
                      ),

                      const SizedBox(height: 16),

                      /// DOB (DATE PICKER)
                      GestureDetector(
                        onTap: () => _pickDob(context),
                        child: AbsorbPointer(
                          child: _input(
                            context,
                            controller: controller.dobCtrl,
                            label: 'Date of Birth',
                            validatorMsg: 'Required',
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// ───── ACADEMIC DETAILS ─────
                      _sectionHeader("Academic Records", isDark),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _input(
                              context,
                              controller: controller.tenthCtrl,
                              label: '10th Percentage',
                              keyboardType: TextInputType.number,
                              suffix: "%",
                              validatorMsg: 'Required',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _input(
                              context,
                              controller: controller.twelthCtrl,
                              label: '12th Percentage',
                              keyboardType: TextInputType.number,
                              suffix: "%",
                              validatorMsg: 'Required',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _input(
                        context,
                        controller: controller.twelthPcbCtrl,
                        label: '12th PCB Percentage',
                        keyboardType: TextInputType.number,
                        suffix: "%",
                      ),

                      const SizedBox(height: 16),

                      _input(
                        context,
                        controller: controller.neetCtrl,
                        label: 'NEET Score',
                        keyboardType: TextInputType.number,
                        validatorMsg: 'Required',
                      ),

                      const SizedBox(height: 30),

                      /// ───── OTHER DETAILS ─────
                      _sectionHeader("Other Details", isDark),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _input(
                              context,
                              controller: controller.casteCtrl,
                              label: 'Caste',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _input(
                              context,
                              controller: controller.nationalityCtrl,
                              label: 'Nationality',
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30),

                      // _buildActionTile(
                      //   context,
                      //   title: "Upload Documents",
                      //   subtitle: "10th, 12th, Neet Score card, etc.",
                      //   icon: Icons.folder_open_rounded,
                      //   onTap: () {
                      //     Get.to(() => StudentDocumentsUnifiedPage());
                      //   },
                      // ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              /// ───── LOADING OVERLAY ─────
              if (controller.isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),

        /// ───────── SAVE BUTTON ─────────
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _onSavePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.folder_open_rounded,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  /// ───────── SAVE ─────────
  void _onSavePressed() {
    if (controller.isLoading.value) return;
    if (!_formKey.currentState!.validate()) return;

    controller.updateProfile();
  }

  /// ───────── IMAGE PICKER ─────────
  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      controller.setProfileImage(File(file.path));
    }
  }

  /// ───────── DOB PICKER ─────────
  Future<void> _pickDob(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      controller.dobCtrl.text = picked.toIso8601String().split('T').first;
    }
  }

  /// ───────── UI HELPERS ─────────
  Widget _sectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.grey[300] : Colors.grey[800],
      ),
    );
  }

  Widget _input(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    String? validatorMsg,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? suffix,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validatorMsg == null
          ? null
          : (v) => v == null || v.isEmpty ? validatorMsg : null,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
