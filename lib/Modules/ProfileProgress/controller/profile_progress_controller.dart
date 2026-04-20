import 'package:Gixa/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../Profile/models/profile_model.dart';
import '../model/profile_section_model.dart';

class ProfileProgressController extends GetxController {
  final Rxn<ProfileModel> profile = Rxn<ProfileModel>();

  /// Called from ProfileController after API success
  void updateProfile(ProfileModel p) {
    profile.value = p;
  }

  // ───────── COMPLETION PERCENT ─────────
  int get totalSections => 5;

  int get completedSections {
    final p = profile.value;
    if (p == null) return 0;

    int count = 0;

    if (p.user.firstName.isNotEmpty && p.user.lastName.isNotEmpty) {
      count++;
    }

    if (p.neetScore != null || p.allIndiaRank != null) count++;

    if (p.documents.isNotEmpty) count++;

    if ((p.course != null && p.course!.isNotEmpty) ||
        (p.specialty != null && p.specialty!.isNotEmpty)) {
      count++;
    }

    if ((p.profilePictureUrl ?? '').isNotEmpty) {
      count++;
    }

    return count;
  }

  double get completionPercent => completedSections / totalSections;

  int get completionPercentInt => (completionPercent * 100).round();

  bool get isProfileComplete => completionPercent >= 1.0;

  // ───────── INCOMPLETE SECTION CARDS ─────────
  List<ProfileSectionCard> get incompleteSectionCards {
    final p = profile.value;
    if (p == null) return [];

    final List<ProfileSectionCard> cards = [];

    /// Profile Photo
    if (p.user.profilePictureUrl == null || p.user.profilePictureUrl!.isEmpty) {
      cards.add(
        ProfileSectionCard(
          title: "Profile Photo",
          description: "Add your profile picture",
          icon: Icons.person_outline,
          route: "/profile",
          image: "assets/images/profile.png",
          actionLabel: "Upload",
        ),
      );
    }

    /// Educational Details
    if (p.neetScore == null && p.allIndiaRank == null) {
      cards.add(
        ProfileSectionCard(
          title: "Educational Details",
          description: "Add exam score & rank",
          icon: Icons.school_outlined,
          route: "/education-details",
          image: "assets/images/education.png",
          actionLabel: "Add",
        ),
      );
    }

    /// Documents
    if (p.documents == null || p.documents.isEmpty) {
      cards.add(
        ProfileSectionCard(
          title: "Documents",
          description: "Upload required documents",
          icon: Icons.description_outlined,
          // route: "/documents",
          route: AppRoutes.updateDocs,
          image: "assets/images/documents.png",
          actionLabel: "Upload",
        ),
      );
    }

    /// Preferences
    if ((p.course == null || p.course!.isEmpty) &&
        (p.specialty == null || p.specialty!.isEmpty)) {
      cards.add(
        ProfileSectionCard(
          title: "Preferences",
          description: "Choose course & specialty",
          icon: Icons.tune,
          route: "/preferences",
          image: "assets/images/prefrences.png",
          actionLabel: "Select",
        ),
      );
    }

    return cards;
  }
}
