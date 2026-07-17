import 'package:Gixa/Modules/register/model/register_request.dart';
import 'package:Gixa/routes/app_start_controller.dart';
import 'package:Gixa/utils/device_utils.dart';
import 'package:Gixa/utils/fcm_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/register_controller.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  static const List<String> _genderOptions = ['M', 'F', 'Other'];

  final RegisterController controller = Get.put(RegisterController());
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  /// Text Controllers
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final nationalityCtrl = TextEditingController(text: 'Indian');

  /// Focus Nodes
  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final emailFocus = FocusNode();
  final neetScoreFocus = FocusNode();
  final airRankFocus = FocusNode();

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _focusToField(FocusNode focusNode) {
    FocusScope.of(Get.context!).requestFocus(focusNode);

    Scrollable.ensureVisible(
      focusNode.context!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.2,
    );
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

        return false;
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
                await appStart.logout();
              },
            ),
            title: Text(
              "Create Account",
              style: GoogleFonts.inter(
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
                controller: _scrollController,
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
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Please fill in your details to continue.",
                      style: GoogleFonts.inter(
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
                            focusNode: firstNameFocus,

                            icon: Icons.person_outline,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "First name is required";
                              }
                              if (v.length < 2) {
                                return "Minimum 2 characters";
                              }
                              if (!RegExp(r"^[a-zA-Z\s\-\.\']+$").hasMatch(v)) {
                                return "Enter a valid name";
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
                            focusNode: lastNameFocus,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Last name is required";
                              }
                              if (!RegExp(r"^[a-zA-Z\s\-\.\']+$").hasMatch(v)) {
                                return "Enter a valid name";
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
                      focusNode: emailFocus,
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

                    const SizedBox(height: 16),

                    _input(
                      context,
                      label: "Nationality",
                      controller: nationalityCtrl,
                      icon: Icons.flag_outlined,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Nationality is required";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _dropdown<String>(
                      context,
                      label: "Gender",
                      value: controller.selectedGender.value,
                      items: _genderOptions,
                      labelBuilder: _genderLabel,
                      onChanged: (v) => controller.selectedGender.value = v,
                      icon: Icons.wc_outlined,
                    ),

                    const SizedBox(height: 24),

                    /// ACADEMIC INFO
                    /// ACADEMIC INFO
                    _section("Academic Details", isDark),

                    /// NEET SCORE
                    _input(
                      context,
                      label: "NEET Score",
                      controller: controller.neetScoreCtrl,
                      icon: Icons.analytics_outlined,
                      keyboard: TextInputType.number,
                      focusNode: neetScoreFocus,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Score is required";
                        }

                        final score = int.tryParse(v);

                        if (score == null || score < 0 || score > 720) {
                          return "Enter valid score (0-720)";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // /// PREDICT BUTTON
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 48,
                    //   child: Obx(
                    //     () => OutlinedButton.icon(
                    //       onPressed: controller.isPredictingRank.value
                    //           ? null
                    //           : controller.predictRank,
                    //       icon: controller.isPredictingRank.value
                    //           ? const SizedBox(
                    //               width: 16,
                    //               height: 16,
                    //               child: CircularProgressIndicator(
                    //                 strokeWidth: 2,
                    //               ),
                    //             )
                    //           : const Icon(Icons.auto_awesome),

                    //       label: Text(
                    //         controller.isPredictingRank.value
                    //             ? "Predicting..."
                    //             : "Predict Rank",
                    //       ),

                    //       style: OutlinedButton.styleFrom(
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(14),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // const SizedBox(height: 12),

                    // /// HELPER INFO
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 14,
                    //     vertical: 12,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: isDark
                    //         ? const Color(0xFF1E2633)
                    //         : const Color(0xFFF4F8FF),
                    //     borderRadius: BorderRadius.circular(14),
                    //     border: Border.all(
                    //       color: primaryColor.withOpacity(0.12),
                    //     ),
                    //   ),
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Icon(
                    //         Icons.info_outline_rounded,
                    //         size: 18,
                    //         color: primaryColor,
                    //       ),

                    //       const SizedBox(width: 10),

                    //       Expanded(
                    //         child: Text(
                    //           "Use Predict Rank to auto-fill AIR from your NEET score, or enter AIR manually if you already know it.",
                    //           style: GoogleFonts.inter(
                    //             fontSize: 11,
                    //             height: 1.4,
                    //             fontWeight: FontWeight.w500,
                    //             color: isDark
                    //                 ? Colors.grey[300]
                    //                 : Colors.grey[700],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 16),

                    /// AIR
                    Obx(
                      () => _input(
                        context,
                        label: "All India Rank (AIR)",
                        controller: controller.airRankCtrl,
                        icon: Icons.emoji_events_outlined,
                        focusNode: airRankFocus,
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
                        suffixIcon: controller.isPredictingRank.value
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                    // Obx(() {
                    //   if (!controller.showAirPredictionNotice.value) {
                    //     return const SizedBox.shrink();
                    //   }

                    //   return Padding(
                    //     padding: const EdgeInsets.only(top: 10),
                    //     child: Container(
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 14,
                    //         vertical: 12,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: isDark
                    //             ? const Color(0xFF112033)
                    //             : const Color(0xFFEFF6FF),
                    //         borderRadius: BorderRadius.circular(14),
                    //         border: Border.all(
                    //           color: isDark
                    //               ? Colors.white.withOpacity(0.08)
                    //               : const Color(0xFFBFDBFE),
                    //         ),
                    //       ),
                    //       child: Row(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Icon(
                    //             Icons.info_outline_rounded,
                    //             size: 18,
                    //             color: isDark
                    //                 ? const Color(0xFF93C5FD)
                    //                 : const Color(0xFF2563EB),
                    //           ),
                    //           const SizedBox(width: 10),
                    //           Expanded(
                    //             child: Text(
                    //               "This is a tentative AIR prediction based on your NEET score and may vary from the official rank.",
                    //               style: GoogleFonts.inter(
                    //                 fontSize: 11,
                    //                 height: 1.4,
                    //                 fontWeight: FontWeight.w500,
                    //                 color: isDark
                    //                     ? Colors.grey[300]
                    //                     : Colors.grey[700],
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   );
                    // }),

                    /// 🔥 ADD THIS → NEET SCORE FIELD
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
                      onChanged: (v) {
                        if (v != null) {
                          controller.updateCategoriesByState(v);
                          controller.updateHorizontalReservationsByState(v);
                          print('State wise course for pg: State: ${controller.selectedState.value?.name}, Course: ${controller.selectedCourse.value?.name}');
                          
                          print("====== COURSES AVAILABLE AFTER STATE SELECTION: ${v.name} ======");
                          for (var c in controller.availableCourses) {
                            print("- ${c.name} (ID: ${c.id})");
                          }
                          print("==============================================================");
                        }
                      },
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

                    /// HORIZONTAL RESERVATIONS
                    Obx(() {
                      if (controller.horizontalReservations.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          Text(
                            "Special Reservation Eligibility",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Please answer the following reservation eligibility questions.",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 16),

                          ...controller.horizontalReservations.map((item) {
                            final isSelected =
                                controller.selectedHorizontalCategories[item
                                    .reservationCode] ??
                                false;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// TITLE
                                  Row(
                                    children: [
                                      Icon(
                                        _getReservationIcon(
                                          item.reservationCode,
                                        ),
                                        size: 15,
                                        color: primaryColor,
                                      ),

                                      const SizedBox(width: 8),

                                      Expanded(
                                        child: Text(
                                          "Do you belong to ${item.reservationName} category?",
                                          style: GoogleFonts.inter(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600,
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// DESCRIPTION
                                  if (item.description != null &&
                                      item.description!.isNotEmpty) ...[
                                    const SizedBox(height: 3),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 23),

                                      child: Text(
                                        item.description!,
                                        style: GoogleFonts.inter(
                                          fontSize: 10.5,
                                          color: Colors.grey,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 8),

                                  /// YES / NO
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),

                                    child: Row(
                                      children: [
                                        /// YES
                                        InkWell(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          onTap: () {
                                            controller.toggleHorizontalCategory(
                                              item.reservationCode,
                                              true,
                                            );
                                          },

                                          child: Row(
                                            children: [
                                              Icon(
                                                isSelected
                                                    ? Icons.radio_button_checked
                                                    : Icons.radio_button_off,
                                                size: 18,
                                                color: isSelected
                                                    ? primaryColor
                                                    : Colors.grey,
                                              ),

                                              const SizedBox(width: 5),

                                              Text(
                                                "Yes",
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: isSelected
                                                      ? primaryColor
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(width: 26),

                                        /// NO
                                        InkWell(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          onTap: () {
                                            controller.toggleHorizontalCategory(
                                              item.reservationCode,
                                              false,
                                            );
                                          },

                                          child: Row(
                                            children: [
                                              Icon(
                                                !isSelected
                                                    ? Icons.radio_button_checked
                                                    : Icons.radio_button_off,
                                                size: 18,
                                                color: !isSelected
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),

                                              const SizedBox(width: 5),

                                              Text(
                                                "No",
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: !isSelected
                                                      ? Colors.red
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      );
                    }),

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
                    if (controller.shouldShowCourseType) ...[
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
                    ],

                    /// COURSE
                    _dropdown<String>(
                      context,
                      label: "Course",
                      value: controller.selectedCourseName.value,
                      items: controller.uniqueCourseNames,
                      labelBuilder: (e) => e,
                      onChanged: (v) {
                        if (v != null) {
                          controller.onCourseNameSelected(v);
                        }
                      },
                      icon: Icons.school_outlined,
                    ),
                    const SizedBox(height: 16),

                    /// COURSE CATEGORY
                    if (controller.selectedCourseLevel.value == CourseLevel.pg &&
                        controller.availableCourseCategories.isNotEmpty) ...[
                      _dropdown<String>(
                        context,
                        label: "Course Category",
                        value: controller.selectedCourseCategory.value,
                        items: controller.availableCourseCategories,
                        labelBuilder: (e) => e,
                        onChanged: (v) {
                          if (v != null) {
                            controller.onCourseCategorySelected(v);
                          }
                        },
                        icon: Icons.category_outlined,
                      ),
                      const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 16),

                    /// SPECIALTY
                    if (controller.shouldShowSpecialty) ...[
                      _dropdown(
                        context,
                        label: "Specialty",
                        value: controller.selectedSpecialty.value,
                        items:
                            controller.selectedCourse.value?.specialties ?? [],
                        labelBuilder: (e) => e.name,
                        onChanged: (v) {
                          if (v != null) {
                            controller.selectedSpecialty.value = v;
                            print("====== BACKEND SPECIALTY SELECTED ======");
                            print("Name: ${v.name}");
                            print("ID: ${v.id}");
                            print("========================================");
                          }
                        },
                        icon: Icons.local_hospital_outlined,
                      ),
                    ],

                    const SizedBox(height: 10),

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

                          /// ðŸ”’ Disable button while loading
                          onPressed: controller.isLoading.value
                              ? null
                              : _submit,

                          /// ðŸ”„ Loader inside button
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
                                  style: GoogleFonts.inter(
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      /// FIRST NAME
      if (firstNameCtrl.text.trim().isEmpty) {
        _focusToField(firstNameFocus);

        AppSnackbar.show(
          "Validation",
          "First name is required",
          snackPosition: SnackPosition.TOP,
        );

        return;
      }

      /// LAST NAME
      if (lastNameCtrl.text.trim().isEmpty) {
        _focusToField(lastNameFocus);

        AppSnackbar.show(
          "Validation",
          "Last name is required",
          snackPosition: SnackPosition.TOP,
        );

        return;
      }

      /// EMAIL
      if (emailCtrl.text.trim().isEmpty) {
        _focusToField(emailFocus);

        AppSnackbar.show(
          "Validation",
          "Email is required",
          snackPosition: SnackPosition.TOP,
        );

        return;
      }
      if (!isValidEmail(emailCtrl.text.trim())) {
        _focusToField(emailFocus);
        AppSnackbar.show(
          "Validation",
          "Enter valid email address",
          snackPosition: SnackPosition.TOP,
        );

        return;
      }

      /// NEET SCORE
      if (controller.neetScoreCtrl.text.trim().isEmpty) {
        _focusToField(neetScoreFocus);
        AppSnackbar.show(
          "Validation",
          "NEET score is required",
          snackPosition: SnackPosition.TOP,
        );

        return;
      }

      /// AIR
      if (controller.airRankCtrl.text.trim().isEmpty) {
        _focusToField(airRankFocus);
        AppSnackbar.show(
          "Validation",
          "AIR rank is required",
          snackPosition: SnackPosition.TOP,
        );

        return;
      }

      /// DROPDOWNS
      if (controller.selectedGender.value == null) {
        AppSnackbar.show(
          "Validation",
          "Please select gender",
          snackPosition: SnackPosition.TOP,
        );

        return;
      }

      return;
    }

    if (!controller.isDropdownValid) {
      AppSnackbar.show(
        "Incomplete",
        "Please select all options",
        snackPosition: SnackPosition.TOP,
      );
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
      allIndiaRank: int.parse(controller.airRankCtrl.text),
      neetScore: int.parse(controller.neetScoreCtrl.text),
      tenthPercentage: 0,
      twelthPercentage: 0,
      twelthPcb: 0,
      category: controller.selectedCategory.value!.id,
      state: controller.selectedState.value!.id,
      course: controller.selectedCourse.value!.id,
      specialty: controller.shouldShowSpecialty
          ? controller.selectedSpecialty.value?.id
          : null,
      gender: controller.selectedGender.value!,
      caste: controller.selectedCategory.value!.name,
      nationality: nationalityCtrl.text.trim(),
      dateOfBirth: '',
      address: "",
      physicalDisability: controller.selectedHorizontalCategories.values
          .contains(true),

      disabilityDetails: controller.selectedHorizontalCategories.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .join(","),
      deviceId: await DeviceUtils.getDeviceId(),
      fcmToken: await FcmUtils.getFcmToken(),
    );

    controller.register(request);
  }

  Widget _section(String title, bool isDark) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title.toUpperCase(),
      style: GoogleFonts.inter(
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

  static String _genderLabel(String value) {
    switch (value) {
      case 'M':
        return 'Male';
      case 'F':
        return 'Female';
      case 'Other':
        return 'Other';
      default:
        return value;
    }
  }

  IconData _getReservationIcon(String code) {
    switch (code.toUpperCase()) {
      case "PWD":
        return Icons.accessible_rounded;

      case "WOMEN":
        return Icons.female_rounded;

      case "DEFENCE":
        return Icons.shield_outlined;

      case "ORPHAN":
        return Icons.child_care_rounded;

      default:
        return Icons.verified_user_outlined;
    }
  }

  Widget _input(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffixIcon,
    FocusNode? focusNode,
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
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF3F4F6),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
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
  bool requiredField = true,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final safeValue = items.contains(value) ? value : null;

  final fillColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F8);
  final borderRadius = BorderRadius.circular(12);

  return DropdownButtonFormField2<T>(
    value: safeValue,
    isExpanded: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (v) {
      if (!requiredField) return null;
      if (v == null) return "$label is required";
      return null;
    },
    items: items.map((e) {
      return DropdownMenuItem<T>(
        value: e,
        child: Text(
          labelBuilder(e),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
      );
    }).toList(),
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: requiredField ? "$label *" : label,
      labelStyle: TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.grey[500] : Colors.grey[500],
      ),
      floatingLabelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
      ),
      prefixIcon: Icon(
        icon,
        size: 17,
        color: isDark ? Colors.grey[500] : Colors.grey[500],
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 0),
      isDense: true,
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      errorStyle: const TextStyle(fontSize: 10.5, height: 1.2),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: Colors.red, width: 0.8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF2E2E2E) : const Color(0xFFE8E8E8),
          width: 0.8,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: isDark ? Colors.white! : const Color(0xFF1A1A1A),
          width: 1.5,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF2E2E2E) : const Color(0xFFE8E8E8),
          width: 10,
        ),
      ),
    ),
    buttonStyleData: const ButtonStyleData(
      padding: EdgeInsets.only(right: 4),
      height: 30, // â† was 56, now compact 44
    ),
    iconStyleData: IconStyleData(
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: isDark ? Colors.grey[500] : Colors.grey[500],
      ),
      iconSize: 18, // â† was 22
    ),
    dropdownStyleData: DropdownStyleData(
      maxHeight: 200,
      offset: const Offset(0, -4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF2E2E2E) : const Color(0xFFE8E8E8),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    ),
    menuItemStyleData: const MenuItemStyleData(
      height: 30, // â† was 48
      padding: EdgeInsets.symmetric(horizontal: 14),
    ),
  );
}
