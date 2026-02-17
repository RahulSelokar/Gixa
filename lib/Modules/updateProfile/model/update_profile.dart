import 'dart:io';

/// ===============================
/// 🔹 UPDATE PROFILE REQUEST
/// ===============================
class UpdateProfileRequest {
  // ───── REQUIRED BASIC INFO ─────
  final String firstName;
  final String lastName;
  final String address;

  // ───── ACADEMIC DETAILS ─────
  final int? neetScore;
  final double? tenthPercentage;
  final double? twelthPercentage;
  final double? twelthPcb;

  // ───── PROFILE PREFERENCES ─────
  final String? category;
  final int? state;
  final int? course;
  final String? specialty;

  // ───── PERSONAL DETAILS ─────
  final String? caste;
  final String? nationality;
  final DateTime? dateOfBirth;

  /// 📸 Profile picture (multipart only)
  final File? profilePicture;

  UpdateProfileRequest({
    required this.firstName,
    required this.lastName,
    required this.address,

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
    this.dateOfBirth,

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

      /// Backend expects YYYY-MM-DD
      "date_of_birth":
          dateOfBirth != null
              ? dateOfBirth!.toIso8601String().split('T').first
              : null,
    };

    // 🔥 Remove null values (PATCH-style update)
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
