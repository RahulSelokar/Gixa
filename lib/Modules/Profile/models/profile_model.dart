import 'package:Gixa/Modules/Profile/models/document_model.dart';
import 'package:Gixa/Modules/register/model/register_response.dart';

class ProfileModel {
  final int id;
  final User user;

  final int? allIndiaRank;
  final int? neetScore;

  final String? tenthPercentage;
  final String? twelthPercentage;
  final String? twelthPcb;

  final String? category;
  final String? state;
  final String? course;
  final String? specialty;

  final String? caste;
  final String? nationality;
  final String? dateOfBirth;
  final String? address;

  final bool isProfileCompleted;
  final bool isVerified;

  final List<Document> documents;

  final String? profilePictureUrl; // ✅ ADD THIS

  ProfileModel({
    required this.id,
    required this.user,
    this.allIndiaRank,
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
    this.address,
    this.profilePictureUrl,
    required this.isProfileCompleted,
    required this.isVerified,
    required this.documents,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      user: User.fromJson(json['user']),

      // ✅ SAFE INT PARSING
      allIndiaRank: json['all_india_rank'] as int?,
      neetScore: json['neet_score'] as int?,

      // ✅ SAFE STRING CONVERSION
      tenthPercentage: json['tenth_percentage']?.toString(),
      twelthPercentage: json['twelth_percentage']?.toString(),
      twelthPcb: json['twelth_pcb']?.toString(),

      category: json['category']?.toString(),
      state: json['state']?.toString(),
      course: json['course']?.toString(),
      specialty: json['specialty']?.toString(),

      caste: json['caste']?.toString(),
      nationality: json['nationality']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      address: json['address']?.toString(),

      isProfileCompleted: json['is_profile_completed'] ?? false,
      isVerified: json['is_verified'] ?? false,

      documents: (json['documents'] as List<dynamic>? ?? [])
          .map((e) => Document.fromJson(e))
          .toList(),

      profilePictureUrl: json['user']?['profile_picture_url'],
    );
  }
}
