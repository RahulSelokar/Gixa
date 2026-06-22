import 'dart:io';

class UpdateProfileRequest {
  // ───── REQUIRED BASIC INFO ─────
  final String firstName;
  final String lastName;
  final String address;
  final String? email;

  // ───── ACADEMIC DETAILS ─────
  final int? air;
  final int? neetScore;
  final double? tenthPercentage;
  final double? twelthPercentage;
  final double? twelthPcb;

  // ───── PROFILE PREFERENCES ─────
  final int? category;
  final int? state;
  final int? course;
  final String? specialty;

  // ───── PERSONAL DETAILS ─────
  final String? caste;
  final String? nationality;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? fcmToken;

  /// 📸 Profile picture (multipart only)
  final File? profilePicture;

  UpdateProfileRequest({
    required this.firstName,
    required this.lastName,
    required this.address,
    this.email,

    this.air,
    this.neetScore,
    this.tenthPercentage,
    this.twelthPercentage,
    this.twelthPcb,

    this.category,
    this.state,
    this.course,
    this.specialty,

    this.caste,
    this.nationality,
    this.gender,
    this.dateOfBirth,
    this.fcmToken,

    this.profilePicture,
  });

  /// ─────────────────────────────────────────────
  /// ✅ JSON BODY (NON-FILE FIELDS ONLY)
  /// Null values are automatically removed
  /// ─────────────────────────────────────────────
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "first_name": firstName,
      "last_name": lastName,
      "address": address,
      "email": email,

      /// 🔥 ADD THIS LINE
      "all_india_rank": air,

      "neet_score": neetScore,
      "tenth_percentage": tenthPercentage,
      "twelth_percentage": twelthPercentage,
      "twelth_pcb": twelthPcb,

      "category": category,
      "state": state,
      "course": course,
      "specialty": specialty,

      "caste": caste,
      "nationality": nationality,
      "gender": gender,

      "date_of_birth": dateOfBirth != null
          ? dateOfBirth!.toIso8601String().split('T').first
          : null,

      "fcm_token": fcmToken,
    };

    data.removeWhere((key, value) => value == null);

    return data;
  }
}

/// ===============================
/// 🔹 UPDATE PROFILE RESPONSE
/// ===============================
class UpdateProfileResponse {
  final String message;
  final bool isProfileCompleted;
  final String? profilePictureUrl;

  UpdateProfileResponse({
    required this.message,
    required this.isProfileCompleted,
    this.profilePictureUrl,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      message: json['message'] ?? '',
      isProfileCompleted: json['is_profile_completed'] ?? false,
      profilePictureUrl: json['profile_picture_url'],
    );
  }
}
