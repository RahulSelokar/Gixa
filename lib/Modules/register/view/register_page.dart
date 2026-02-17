import 'package:Gixa/Modules/register/model/register_request.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:Gixa/routes/app_start_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/register_controller.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final RegisterController controller = Get.put(RegisterController());
  final _formKey = GlobalKey<FormState>();

  /// Text Controllers
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final airCtrl = TextEditingController();

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final mobileNumber = Get.arguments?['mobileNumber'] ?? 'Unknown';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
    final primaryColor = Theme.of(context).primaryColor;

    return WillPopScope(
      onWillPop: () async {
        final appStart = Get.find<AppStartController>();
        await appStart.logout();

        Get.offAllNamed(AppRoutes.loginWithOtp);

        return true;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: backgroundColor,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black,
              ),
              onPressed: () async {
                final appStart = Get.find<AppStartController>();
                // await appStart.clearRegistration();
                await appStart.logout();

                // 🔥 force login screen
                Get.offAllNamed(AppRoutes.loginWithOtp);
              },
            ),
            title: Text(
              "Create Account",
              style: GoogleFonts.poppins(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: Obx(() {
            if (controller.isMasterLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Text(
                      "Let's get you started",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Please fill in your details to continue.",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// VERIFIED MOBILE
                    _section("Account Linked", isDark),
                    _verifiedMobile(mobileNumber, isDark, primaryColor),

                    const SizedBox(height: 24),

                    /// PERSONAL INFO
                    _section("Personal Information", isDark),
                    Row(
                      children: [
                        Expanded(
                          child: _input(
                            context,
                            label: "First Name",
                            controller: firstNameCtrl,
                            icon: Icons.person_outline,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "First name is required";
                              }
                              if (v.length < 2) {
                                return "Minimum 2 characters";
                              }
                              if (!RegExp(r'^[a-zA-Z]+$').hasMatch(v)) {
                                return "Only letters allowed";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _input(
                            context,
                            label: "Last Name",
                            controller: lastNameCtrl,
                            icon: Icons.person_outline,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Last name is required";
                              }
                              if (!RegExp(r'^[a-zA-Z]+$').hasMatch(v)) {
                                return "Only letters allowed";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _input(
                      context,
                      label: "Email Address",
                      controller: emailCtrl,
                      icon: Icons.email_outlined,
                      keyboard: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Email is required";
                        }
                        if (!isValidEmail(v)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    /// ACADEMIC INFO
                    _section("Academic Details", isDark),
                    _input(
                      context,
                      label: "All India Rank (AIR)",
                      controller: airCtrl,
                      icon: Icons.emoji_events_outlined,
                      keyboard: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(7),
                      ],
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "AIR is required";
                        }
                        final rank = int.tryParse(v);
                        if (rank == null || rank <= 0) {
                          return "Enter a valid AIR";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    /// PREFERENCES
                    _section("Preferences", isDark),

                    /// STATE
                    _dropdown(
                      context,
                      label: "State",
                      value: controller.selectedState.value,
                      items: controller.states,
                      labelBuilder: (e) => e.name,
                      onChanged: (v) => controller.selectedState.value = v,
                      icon: Icons.map_outlined,
                    ),
                    const SizedBox(height: 16),

                    /// CATEGORY
                    _dropdown(
                      context,
                      label: "Category",
                      value: controller.selectedCategory.value,
                      items: controller.categories,
                      labelBuilder: (e) => e.name,
                      onChanged: (v) => controller.selectedCategory.value = v,
                      icon: Icons.category_outlined,
                    ),
                    const SizedBox(height: 16),

                    /// COURSE LEVEL
                    _dropdown<CourseLevel>(
                      context,
                      label: "Course Level",
                      value: controller.selectedCourseLevel.value,
                      items: CourseLevel.values,
                      labelBuilder: (e) => e.name.toUpperCase(),
                      onChanged: (v) {
                        if (v != null) controller.onCourseLevelSelected(v);
                      },
                      icon: Icons.layers_outlined,
                    ),
                    const SizedBox(height: 16),

                    /// COURSE TYPE
                    _dropdown<CourseType>(
                      context,
                      label: "Course Type",
                      value: controller.selectedCourseType.value,
                      items: CourseType.values,
                      labelBuilder: (e) {
                        switch (e) {
                          case CourseType.clinical:
                            return "Clinical";
                          case CourseType.nonClinical:
                            return "Non Clinical";
                          case CourseType.paraClinical:
                            return "Para Clinical";
                        }
                      },
                      onChanged: (v) {
                        if (v != null) controller.onCourseTypeSelected(v);
                      },
                      icon: Icons.medical_services_outlined,
                    ),
                    const SizedBox(height: 16),

                    /// COURSE
                    _dropdown(
                      context,
                      label: "Course",
                      value: controller.selectedCourse.value,
                      items: controller.coursesByType,
                      labelBuilder: (e) => e.name,
                      onChanged: (v) {
                        if (v != null) controller.onCourseSelected(v);
                      },
                      icon: Icons.school_outlined,
                    ),
                    const SizedBox(height: 16),

                    /// SPECIALTY
                    _dropdown(
                      context,
                      label: "Specialty",
                      value: controller.selectedSpecialty.value,
                      items: controller.selectedCourse.value?.specialties ?? [],
                      labelBuilder: (e) => e.name,
                      onChanged: (v) => controller.selectedSpecialty.value = v,
                      icon: Icons.local_hospital_outlined,
                    ),

                    const SizedBox(height: 40),

                    /// SUBMIT
                    /// SUBMIT
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),

                          /// 🔒 Disable button while loading
                          onPressed: controller.isLoading.value
                              ? null
                              : _submit,

                          /// 🔄 Loader inside button
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  "Complete Registration",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ───────────────── HELPERS ─────────────────
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (!controller.isDropdownValid) {
      Get.snackbar("Incomplete", "Please select all options");
      return;
    }

    final mobile = Get.arguments?['mobileNumber'] ?? '';

    final request = RegisterStudentRequest(
      username: mobile,
      password: mobile,
      email: emailCtrl.text.trim(),
      firstName: firstNameCtrl.text.trim(),
      lastName: lastNameCtrl.text.trim(),
      mobileNumber: mobile,
      allIndiaRank: int.parse(airCtrl.text),
      neetScore: 0,
      tenthPercentage: 0,
      twelthPercentage: 0,
      twelthPcb: 0,
      category: controller.selectedCategory.value!.id,
      state: controller.selectedState.value!.id,
      course: controller.selectedCourse.value!.id,
      specialty: controller.selectedSpecialty.value!.id,
      caste: "NA",
      nationality: "Indian",
      dateOfBirth: "2000-01-01",
      address: "NA",
    );

    controller.register(request);
  }

  Widget _section(String title, bool isDark) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    ),
  );

  Widget _verifiedMobile(String mobile, bool isDark, Color primary) =>
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified, color: Colors.green),
            const SizedBox(width: 12),
            Text("+91 $mobile"),
            const Spacer(),
            Icon(Icons.check_circle, color: primary),
          ],
        ),
      );

  Widget _input(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      inputFormatters: inputFormatters,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF3F4F6),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

Widget _dropdown<T>(
  BuildContext context, {
  required String label,
  required T? value,
  required List<T> items,
  required String Function(T) labelBuilder,
  required ValueChanged<T?> onChanged,
  required IconData icon,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return DropdownButtonFormField<T>(
    initialValue: value,
    items: items
        .map((e) => DropdownMenuItem(value: e, child: Text(labelBuilder(e))))
        .toList(),
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF3F4F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
