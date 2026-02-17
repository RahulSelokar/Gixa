import 'package:Gixa/Modules/Profile/models/profile_model.dart';

class CollegeCompareResponse {
  final String status;
  final ProfileModel? studentProfile;
  final int totalColleges;
  final List<CollegeComparison> comparison;

  CollegeCompareResponse({
    required this.status,
    required this.studentProfile,
    required this.totalColleges,
    required this.comparison,
  });

  factory CollegeCompareResponse.fromJson(Map<String, dynamic> json) {
    return CollegeCompareResponse(
      status: json['status'] ?? '',
      studentProfile: json['student_profile'] != null
          ? ProfileModel.fromJson(
              Map<String, dynamic>.from(json['student_profile']),
            )
          : null,
      totalColleges: json['total_colleges'] ?? 0,
      comparison: (json['comparison'] as List? ?? [])
          .map((e) => CollegeComparison.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class CollegeComparison {
  final int id;
  final String collegeCode;
  final String collegeName;
  final String? nirfRank;
  final String city;
  final String district;
  final int? yearEstablished;
  final String? aboutUs;
  final String address;
  final bool hostelAvailable;
  final String? hostelFor;
  final String? collegeWebsite;
  final String? collegeVideoUrl;
  final String admissionChances;

  CollegeComparison({
    required this.id,
    required this.collegeCode,
    required this.collegeName,
    this.nirfRank,
    required this.city,
    required this.district,
    this.yearEstablished,
    this.aboutUs,
    required this.address,
    required this.hostelAvailable,
    this.hostelFor,
    this.collegeWebsite,
    this.collegeVideoUrl,
    required this.admissionChances,
  });

  factory CollegeComparison.fromJson(Map<String, dynamic> json) {
    return CollegeComparison(
      id: json['id'],
      collegeCode: json['college_code'] ?? '',
      collegeName: json['college_name'] ?? '',
      nirfRank: json['nirf_rank']?.toString(),
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      yearEstablished: json['year_established'],
      aboutUs: json['about_us'],
      address: json['address'] ?? '',
      hostelAvailable: json['hostel_available'] ?? false,
      hostelFor: json['hostel_for'],
      collegeWebsite: json['college_website'],
      collegeVideoUrl: json['college_video_url'],
      admissionChances: json['admission_chances'] ?? 'N/A',
    );
  }
}
