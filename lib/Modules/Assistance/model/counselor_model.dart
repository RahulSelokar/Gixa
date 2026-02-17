class CounselorListResponse {
  final List<Counselor> counselors;

  CounselorListResponse({required this.counselors});

  factory CounselorListResponse.fromJson(Map<String, dynamic> json) {
    return CounselorListResponse(
      counselors: (json['counselors'] as List)
          .map((e) => Counselor.fromJson(e))
          .toList(),
    );
  }
}

class Counselor {
  final int id;
  final String name;
  final String profileImage;
  final String specialization;
  final int experienceYears;
  final List<String> languages;
  final double rating;
  final int totalReviews;
  final String availability; // available | busy

  Counselor({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.specialization,
    required this.experienceYears,
    required this.languages,
    required this.rating,
    required this.totalReviews,
    required this.availability,
  });

  factory Counselor.fromJson(Map<String, dynamic> json) {
    return Counselor(
      id: json['id'],
      name: json['name'] ?? "",
      profileImage: json['profile_image'] ?? "",
      specialization: json['primary_specialization'] ?? "",
      experienceYears: json['experience_years'] ?? 0,
      languages: List<String>.from(json['languages'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      availability: json['availability'] ?? "busy",
    );
  }
}
