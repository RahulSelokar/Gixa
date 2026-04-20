import 'dart:io';

import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
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

  @override
  void onInit() {
    super.onInit();
    // Pre-fill from existing profile data
    try {
      final profileCtrl = Get.find<ProfileController>();
      final profile = profileCtrl.profile.value;
      if (profile != null) {
        loadFromProfile(profile);
      }
    } catch (_) {}
  }

  // ─────────────────────────────────────────────
  // SET PROFILE IMAGE
  // ─────────────────────────────────────────────
  void setProfileImage(File image) {
    profileImage.value = image;
  }

  // ─────────────────────────────────────────────
  // NORMALIZE DATE (handle DD-MM-YYYY, DD/MM/YYYY, ISO)
  // ─────────────────────────────────────────────
  String _normalizeDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final iso = DateTime.tryParse(raw);
    if (iso != null) return raw.split('T').first;
    final parts = raw.split(RegExp(r'[-/.]'));
    if (parts.length == 3 && parts[0].length <= 2) {
      final reordered =
          '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
      if (DateTime.tryParse(reordered) != null) return reordered;
    }
    return raw;
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
    dobCtrl.text = _normalizeDate(profile.dateOfBirth);
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
            ? DateTime.tryParse(_normalizeDate(dobCtrl.text))
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

      /// ✅ Refresh profile data & navigate back
      try {
        final profileCtrl = Get.find<ProfileController>();
        await profileCtrl.fetchProfile();
      } catch (_) {}
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
