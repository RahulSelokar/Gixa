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
  final List<GalleryImage> gallery; // ✅ NEW

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
  });

  factory CollegeDetail.fromJson(Map<String, dynamic> json) {
    return CollegeDetail(
      id: json['id'],
      collegeCode: json['college_code'] ?? '',
      name: json['college_name'],
      state: StateModel.fromJson(json['state']),
      instituteType: InstituteType.fromJson(json['institute_type']),
      yearEstablished: json['year_established'],
      hostelAvailable: json['hostel_available'],
      hostelFor: json['hostel_for'],
      coverImage: null, 
      courses: Courses.fromJson(json['courses']),
      website: json['college_website'] ?? '',
      videoUrl: json['college_video_url'] ?? '',
      about: json['about_us'] ?? '',
      address: json['address'] ?? '',
      contactName: json['contact_person_name'] ?? '',
      contactDesignation: json['contact_person_designation'] ?? '',
      contactEmail: json['contact_email'] ?? '',
      contactMobile: json['contact_mobile'] ?? '',
      gallery: (json['gallery'] as List? ?? [])
          .map((e) => GalleryImage.fromJson(e))
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
