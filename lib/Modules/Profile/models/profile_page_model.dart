class ProfileModel {
  final String phone;
  final String name;
  final String email;
  final String role;
  final String course;
  final String exam;
  final int neetScore;
  final int airRank;
  final String? profileImage;

  ProfileModel({
    required this.phone,
    required this.name,
    required this.email,
    required this.role,
    required this.course,
    required this.exam,
    required this.neetScore,
    required this.airRank,
    this.profileImage,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      phone: json['phone'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      course: json['course'],
      exam: json['exam'],
      neetScore: json['neet_score'],
      airRank: json['air_rank'],
      profileImage: json['profile_image'],
    );
  }
}
