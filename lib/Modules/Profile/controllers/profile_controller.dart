import 'dart:io';
import 'package:Gixa/services/update_profile_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Gixa/network/app_exception.dart';
import 'package:Gixa/services/profile_services.dart';
import 'package:Gixa/services/token_services.dart';
import 'package:Gixa/Modules/updateProfile/model/update_profile.dart';
import '../models/profile_model.dart';
import '../../ProfileProgress/controller/profile_progress_controller.dart';

class ProfileController extends GetxController {
  /// ───────── STATE ─────────
  final RxBool isLoading = false.obs;
  final RxBool isEditMode = false.obs;

  final Rxn<ProfileModel> profile = Rxn<ProfileModel>();

  File? selectedProfileImage;

  late final ProfileProgressController progressController;

  /// ───────── EDIT CONTROLLERS ─────────
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final tenthCtrl = TextEditingController();
  final twelthCtrl = TextEditingController();
  final pcbCtrl = TextEditingController();
  final nationalityCtrl = TextEditingController();
  final neetCtrl = TextEditingController();

  // /// ───────── INIT ─────────
  // @override
  // void onInit() {
  //   super.onInit();
  //   progressController = Get.put(ProfileProgressController());
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  //   _safeFetchProfile();
  // }

  /// ───────── SAFE FETCH ─────────
  Future<void> _safeFetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final hasToken = await TokenService.hasValidToken();
    if (!hasToken) return;
    await fetchProfile();
  }

  /// ───────── FETCH PROFILE ─────────
  Future<void> fetchProfile() async {
    if (isLoading.value) return;

    final hasToken = await TokenService.hasValidToken();
    if (!hasToken) return;

    isLoading.value = true;

    try {
      print("🚀 PROFILE API CALLED");

      final result = await ProfileService.getProfile();

      print("✅ PROFILE LOADED SUCCESSFULLY");

      profile.value = result;
      _fillControllers(result);
    } catch (e) {
      print("❌ PROFILE ERROR → $e");
      Get.snackbar("Profile Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ───────── ENABLE EDIT ─────────
  void enableEdit() {
    final p = profile.value;
    if (p == null) return;

    firstNameCtrl.text = p.user.firstName ?? '';
    lastNameCtrl.text = p.user.lastName ?? '';
    addressCtrl.text = p.address ?? '';
    dobCtrl.text = p.dateOfBirth ?? '';
    tenthCtrl.text = p.tenthPercentage?.toString() ?? '';
    twelthCtrl.text = p.twelthPercentage?.toString() ?? '';
    pcbCtrl.text = p.twelthPcb?.toString() ?? '';
    nationalityCtrl.text = p.nationality ?? '';

    isEditMode.value = true;
  }

  void _fillControllers(ProfileModel p) {
    firstNameCtrl.text = p.user.firstName ?? '';
    lastNameCtrl.text = p.user.lastName ?? '';
    addressCtrl.text = p.address ?? '';
    dobCtrl.text = p.dateOfBirth ?? '';
    tenthCtrl.text = p.tenthPercentage ?? '';
    twelthCtrl.text = p.twelthPercentage ?? '';
    pcbCtrl.text = p.twelthPcb ?? '';
    nationalityCtrl.text = p.nationality ?? '';
    neetCtrl.text = p.neetScore?.toString() ?? '';
  }

  void cancelEdit() {
    isEditMode.value = false;
    selectedProfileImage = null;
  }

  void setProfileImage(File file) {
    selectedProfileImage = file;
  }

  Future<void> refreshProfile() async {
    await fetchProfile();
  }

  /// ───────── SAVE PROFILE ─────────
  Future<void> saveProfile() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final request = UpdateProfileRequest(
        firstName: firstNameCtrl.text,
        lastName: lastNameCtrl.text,
        address: addressCtrl.text,
        tenthPercentage: double.tryParse(tenthCtrl.text),
        twelthPercentage: double.tryParse(twelthCtrl.text),
        twelthPcb: double.tryParse(pcbCtrl.text),
        neetScore: int.tryParse(neetCtrl.text),
        nationality: nationalityCtrl.text.isEmpty ? null : nationalityCtrl.text,
        dateOfBirth: dobCtrl.text.isNotEmpty
            ? DateTime.tryParse(dobCtrl.text)
            : null,
        profilePicture: selectedProfileImage,
      );

      await UpdateProfileService.updateProfile(request);

      // 🔥 Fetch fresh data after upload
      await fetchProfile();

      // Clear preview after fetch
      selectedProfileImage = null;
      isEditMode.value = false;

      Get.snackbar(
        "Success",
        "Profile updated successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } on AppException catch (e) {
      Get.snackbar("Update Failed", e.message);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ───────── SAFE GETTERS ─────────
  String get email => profile.value?.user.email ?? '';

  String get mobile => profile.value?.user.mobileNumber ?? '';

  String get fullName {
    final first = profile.value?.user.firstName ?? '';
    final last = profile.value?.user.lastName ?? '';
    return '$first $last'.trim();
  }

  // ✅ FIXED IMAGE GETTER
  String get profileImage => profile.value?.profilePictureUrl ?? '';

  bool get isProfileCompleted => profile.value?.isProfileCompleted ?? false;

  bool get isVerified => profile.value?.isVerified ?? false;

  /// ───────── CLEANUP ─────────
  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    addressCtrl.dispose();
    dobCtrl.dispose();
    tenthCtrl.dispose();
    twelthCtrl.dispose();
    pcbCtrl.dispose();
    nationalityCtrl.dispose();
    super.onClose();
  }
}
