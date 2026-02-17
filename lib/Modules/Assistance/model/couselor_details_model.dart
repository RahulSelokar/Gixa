class CounselorDetailResponse {
  final bool success;
  final CounselorDetail counselor;

  CounselorDetailResponse({
    required this.success,
    required this.counselor,
  });

  factory CounselorDetailResponse.fromJson(Map<String, dynamic> json) {
    return CounselorDetailResponse(
      success: json['success'] ?? false,
      counselor: CounselorDetail.fromJson(json['counselor']),
    );
  }
}

class CounselorDetail {
  final int id;
  final String name;
  final String profileImage;
  final int experienceYears;
  final double rating;
  final int totalReviews;
  final String bio;
  final List<String> education;
  final List<String> specializations;
  final List<String> examExpertise;
  final List<String> languages;
  final List<String> counselingStyle;
  final Availability availability;

  CounselorDetail({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.experienceYears,
    required this.rating,
    required this.totalReviews,
    required this.bio,
    required this.education,
    required this.specializations,
    required this.examExpertise,
    required this.languages,
    required this.counselingStyle,
    required this.availability,
  });

  factory CounselorDetail.fromJson(Map<String, dynamic> json) {
    return CounselorDetail(
      id: json['id'],
      name: json['name'] ?? '',
      profileImage: json['profile_image'] ?? '',
      experienceYears: json['experience_years'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      bio: json['bio'] ?? '',
      education: List<String>.from(json['education'] ?? []),
      specializations: List<String>.from(json['specializations'] ?? []),
      examExpertise: List<String>.from(json['exam_expertise'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      counselingStyle: List<String>.from(json['counseling_style'] ?? []),
      availability: Availability.fromJson(json['availability'] ?? {}),
    );
  }
}

class Availability {
  final bool chat;
  final bool call;
  final bool video;

  Availability({
    required this.chat,
    required this.call,
    required this.video,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      chat: json['chat'] ?? false,
      call: json['call'] ?? false,
      video: json['video'] ?? false,
    );
  }
}
