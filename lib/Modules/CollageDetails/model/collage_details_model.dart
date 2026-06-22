import 'package:Gixa/Modules/seatMatrix/model/seat_matrix_model.dart';

import '../../Collage/model/collage_model.dart';

class CollegeDetail extends College {
  final String website;
  final String videoUrl;
  final String about;
  final String address;
  final String contactName;
  final String contactDesignation;
  final String contactEmail;
  final String contactMobile;
  final List<GalleryImage> gallery;
  final List<SeatMatrixModel> seatMatrix;

  CollegeDetail({
    required super.id,
    required super.collegeCode,
    required super.name,
    required super.state,
    required super.instituteType,
    required super.yearEstablished,
    required super.hostelAvailable,
    required super.hostelFor,
    required super.coverImage,
    required super.courses,
    required this.website,
    required this.videoUrl,
    required this.about,
    required this.address,
    required this.contactName,
    required this.contactDesignation,
    required this.contactEmail,
    required this.contactMobile,
    required this.gallery,
    required this.seatMatrix,
  });

  factory CollegeDetail.fromCollege(College college) {
    return CollegeDetail(
      id: college.id,
      collegeCode: college.collegeCode,
      name: college.name,
      state: college.state,
      instituteType: college.instituteType,
      yearEstablished: college.yearEstablished,
      hostelAvailable: college.hostelAvailable,
      hostelFor: college.hostelFor,
      coverImage: college.coverImage,
      courses: college.courses,
      website: '',
      videoUrl: '',
      about: '',
      address: '',
      contactName: '',
      contactDesignation: '',
      contactEmail: '',
      contactMobile: '',
      gallery: [],
      seatMatrix: [],
    );
  }

  factory CollegeDetail.fromJson(Map<String, dynamic> json) {
    return CollegeDetail(
      id: (json['id'] as num?)?.toInt() ?? 0,
      collegeCode: json['college_code']?.toString() ?? '',
      name: json['college_name']?.toString() ?? '',

      // ✅ SAFE nested parsing
      state: json['state'] != null
          ? StateModel.fromJson(json['state'])
          : StateModel.fromJson({}),

      instituteType: json['institute_type'] != null
          ? InstituteType.fromJson(json['institute_type'])
          : InstituteType.fromJson({}),

      yearEstablished: (json['year_established'] as num?)?.toInt(),
      hostelAvailable: json['hostel_available'] ?? false,
      hostelFor: json['hostel_for'],

      coverImage: null,

      courses: json['courses'] != null
          ? Courses.fromJson(json['courses'])
          : Courses.fromJson({}),

      website: json['college_website']?.toString() ?? '',
      videoUrl: json['college_video_url']?.toString() ?? '',
      about: json['about_us']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      contactName: json['contact_person_name']?.toString() ?? '',
      contactDesignation: json['contact_person_designation']?.toString() ?? '',
      contactEmail: json['contact_email']?.toString() ?? '',
      contactMobile: json['contact_mobile']?.toString() ?? '',

      gallery: (json['gallery'] as List? ?? [])
          .map((e) => GalleryImage.fromJson(e))
          .toList(),

      seatMatrix: (json['seat_matrix'] as List? ?? [])
          .map((e) => SeatMatrixModel.fromJson(e))
          .toList(),
    );
  }
}

class GalleryImage {
  final int id;
  final String imageUrl;

  GalleryImage({required this.id, required this.imageUrl});

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(id: json['id'], imageUrl: json['image_url']);
  }
}
