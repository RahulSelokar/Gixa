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

  final String? stateName;
  final String? instituteTypeName;
  final String? nirfRank;

  final String city;
  final String district;

  final int? yearEstablished;
  final String? aboutUs;
  final String? address;

  final bool hostelAvailable;
  final String? hostelFor;

  final String? collegeWebsite;
  final String? collegeVideoUrl;

  final String? contactPersonName;
  final String? contactEmail;
  final String? contactMobile;

  final List<Seat> seats;
  final List<Cutoff> cutoffs;
  final List<dynamic> relevantCutoffs;

  final String admissionChances;

  CollegeComparison({
    required this.id,
    required this.collegeCode,
    required this.collegeName,
    this.stateName,
    this.instituteTypeName,
    this.nirfRank,
    required this.city,
    required this.district,
    this.yearEstablished,
    this.aboutUs,
    this.address,
    required this.hostelAvailable,
    this.hostelFor,
    this.collegeWebsite,
    this.collegeVideoUrl,
    this.contactPersonName,
    this.contactEmail,
    this.contactMobile,
    this.seats = const [],
    required this.cutoffs,
    required this.relevantCutoffs,
    required this.admissionChances,
  });

  /// 🔥 TOTAL SEATS CALCULATOR
  int get totalSeatsCount {
    if (seats.isEmpty) return 0;
    return seats.fold(0, (sum, seat) => sum + seat.totalSeats);
  }

  /// AIQ Seats
  int get aiqSeatsCount {
    if (seats.isEmpty) return 0;
    return seats.fold(0, (sum, seat) => sum + seat.aiqSeats);
  }

  /// State Quota Seats
  int get stateQuotaSeatsCount {
    if (seats.isEmpty) return 0;
    return seats.fold(0, (sum, seat) => sum + seat.stateQuotaSeats);
  }

  factory CollegeComparison.fromJson(Map<String, dynamic> json) {
    return CollegeComparison(
      id: json['id'] ?? 0,
      collegeCode: json['college_code'] ?? '',
      collegeName: json['college_name'] ?? '',
      stateName: json['state_name'],
      instituteTypeName: json['institute_type_name'],
      nirfRank: json['nirf_rank']?.toString(),
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      yearEstablished: json['year_established'],
      aboutUs: json['about_us'],
      address: json['address'],
      hostelAvailable: json['hostel_available'] ?? false,
      hostelFor: json['hostel_for'],
      collegeWebsite: json['college_website'],
      collegeVideoUrl: json['college_video_url'],
      contactPersonName: json['contact_person_name'],
      contactEmail: json['contact_email'],
      contactMobile: json['contact_mobile'],
      cutoffs: (json['cutoffs'] as List? ?? [])
          .map((e) => Cutoff.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      relevantCutoffs: json['relevant_cutoffs'] ?? [],
      admissionChances: json['admission_chances'] ?? "N/A",
      seats: (json['seats'] as List? ?? [])
          .map((e) => Seat.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class Seat {
  final String? course;
  final int totalSeats;
  final int aiqSeats;
  final int stateQuotaSeats;
  final int institutionalQuotaSeats;
  final int minorityQuotaSeats;
  final int nriQuotaSeats;

  Seat({
    this.course,
    required this.totalSeats,
    required this.aiqSeats,
    required this.stateQuotaSeats,
    required this.institutionalQuotaSeats,
    required this.minorityQuotaSeats,
    required this.nriQuotaSeats,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      course: json['course'],
      totalSeats: json['total_seats'] ?? 0,
      aiqSeats: json['aiq_seats'] ?? 0,
      stateQuotaSeats: json['state_quota_seats'] ?? 0,
      institutionalQuotaSeats: json['institutional_quota_seats'] ?? 0,
      minorityQuotaSeats: json['minority_quota_seats'] ?? 0,
      nriQuotaSeats: json['nri_quota_seats'] ?? 0,
    );
  }
}

class Cutoff {
  final int id;
  final String quotaName;
  final int totalSeats;
  final bool isActive;

  Cutoff({
    required this.id,
    required this.quotaName,
    required this.totalSeats,
    required this.isActive,
  });

  factory Cutoff.fromJson(Map<String, dynamic> json) {
    return Cutoff(
      id: json['id'] ?? 0,
      quotaName: json['quota_name'] ?? '',
      totalSeats: json['total_seats'] ?? 0,
      isActive: json['is_active'] ?? false,
    );
  }
}