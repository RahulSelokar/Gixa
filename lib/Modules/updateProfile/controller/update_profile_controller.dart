import 'dart:io';

import 'package:Gixa/Modules/Profile/models/profile_model.dart';
import 'package:Gixa/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Gixa/Modules/updateProfile/model/update_profile.dart';
import 'package:Gixa/services/update_profile_services.dart';

class UpdateProfileController extends GetxController {
  /// 🔄 UI State
  final RxBool isLoading = false.obs;
  final RxBool isProfileCompleted = false.obs;

  /// ───────── TEXT CONTROLLERS ─────────
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController neetCtrl = TextEditingController();
  final TextEditingController tenthCtrl = TextEditingController();
  final TextEditingController twelthCtrl = TextEditingController();
  final TextEditingController twelthPcbCtrl = TextEditingController();
  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController casteCtrl = TextEditingController();
  final TextEditingController nationalityCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();

  /// 📸 Profile image
  final Rx<File?> profileImage = Rx<File?>(null);

  // ─────────────────────────────────────────────
  // SET PROFILE IMAGE
  // ─────────────────────────────────────────────
  void setProfileImage(File image) {
    profileImage.value = image;
  }

  // ─────────────────────────────────────────────
  // PREFILL DATA FROM PROFILE API
  // ─────────────────────────────────────────────
  void loadFromProfile(ProfileModel profile) {
    firstNameCtrl.text = profile.user.firstName;
    lastNameCtrl.text = profile.user.lastName;
    neetCtrl.text = profile.neetScore?.toString() ?? '';
    tenthCtrl.text = profile.tenthPercentage ?? '';
    twelthCtrl.text = profile.twelthPercentage ?? '';
    twelthPcbCtrl.text = profile.twelthPcb ?? '';
    casteCtrl.text = profile.caste ?? '';
    nationalityCtrl.text = profile.nationality ?? '';
    dobCtrl.text = profile.dateOfBirth ?? '';
    addressCtrl.text = profile.address ?? '';
  }

  // ─────────────────────────────────────────────
  // UPDATE PROFILE (SEND ALL FIELDS)
  // ─────────────────────────────────────────────
  Future<void> updateProfile() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final UpdateProfileRequest request = UpdateProfileRequest(
        firstName: firstNameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        neetScore: int.tryParse(neetCtrl.text) ?? 0,
        tenthPercentage: double.tryParse(tenthCtrl.text) ?? 0,
        twelthPercentage: double.tryParse(twelthCtrl.text) ?? 0,
        twelthPcb: double.tryParse(twelthPcbCtrl.text),
        caste: casteCtrl.text.trim(),
        nationality: nationalityCtrl.text.trim(),
        dateOfBirth: dobCtrl.text.isNotEmpty
            ? DateTime.tryParse(dobCtrl.text)
            : null,
        state: 3, // TODO: dropdown
        course: 3, // TODO: dropdown
        address: addressCtrl.text.trim(),
        profilePicture: profileImage.value,
      );

      final UpdateProfileResponse response =
          await UpdateProfileService.updateProfile(request);

      isProfileCompleted.value = response.isProfileCompleted;

      Get.snackbar(
        'Success',
        response.message,
        snackPosition: SnackPosition.BOTTOM,
      );

      /// ✅ Navigate back & refresh profile page
      Get.offNamed(AppRoutes.profile);
    } catch (e) {
      Get.snackbar(
        'Update Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // CLEANUP
  // ─────────────────────────────────────────────
  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    neetCtrl.dispose();
    tenthCtrl.dispose();
    twelthCtrl.dispose();
    twelthPcbCtrl.dispose();
    casteCtrl.dispose();
    nationalityCtrl.dispose();
    dobCtrl.dispose();
    addressCtrl.dispose();
    super.onClose();
  }
}
