import 'package:Gixa/services/rank_predict_services.dart';
import 'package:Gixa/Modules/Profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/neet_rank_model.dart';
import 'package:Gixa/common/widgets/app_snackbar.dart';

class NeetRankController extends GetxController {
  final isLoading = false.obs;

  final scoreController = TextEditingController();
  final result = Rxn<NeetRankData>();

  late final ProfileController profileController;

  /// ðŸ”¥ Prevent overwriting user input
  bool isScoreInitialized = false;

  @override
  void onInit() {
    super.onInit();

    /// ðŸ”¥ Ensure ProfileController exists
    profileController = Get.find<ProfileController>();

    /// ðŸ”¥ Try immediately (if profile already loaded)
    _setScoreFromProfile(profileController.profile.value);

    print("PROFILE: ${profileController.profile.value}");
    print("SCORE: ${profileController.profile.value?.neetScore}");

    /// ðŸ”¥ Listen for future updates
    ever(profileController.profile, (profile) {
      _setScoreFromProfile(profile);
    });

    /// ðŸ”¥ If profile not loaded â†’ force load
    if (profileController.profile.value == null) {
      profileController.fetchProfile();
    }
  }

  /// ðŸ”¥ SET SCORE FROM PROFILE (SAFE)
  void _setScoreFromProfile(dynamic profile) {
    if (isScoreInitialized) return;

    final score = profile?.neetScore;

    if (score != null && score > 0) {
      scoreController.text = score.toString();
      isScoreInitialized = true;

      /// ðŸ”¥ auto predict
      predictRank(score);
    }
  }

  /// ðŸ”¥ MAIN FUNCTION
  Future<void> predictRank([int? enteredScore]) async {
    try {
      final score = enteredScore ?? int.tryParse(scoreController.text.trim());

      if (score == null) {
        AppSnackbar.show("Error", "Please enter your score");
        return;
      }

      if (score < 0 || score > 720) {
        AppSnackbar.show("Invalid", "Enter score between 0 - 720");
        return;
      }

      isLoading.value = true;

      final response = await NeetRankService.getRank(score);
      final model = NeetRankResponse.fromJson(response);

      result.value = model.data;

      /// âŒ DO NOT overwrite user input
      /// keep user editable
    } catch (e) {
      AppSnackbar.show("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ðŸ§¹ reset
  void reset() {
    result.value = null;
    scoreController.clear();
    isScoreInitialized = false;
  }

  @override
  void onClose() {
    scoreController.dispose();
    super.onClose();
  }
}

