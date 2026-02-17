import 'package:Gixa/Modules/CollageDetails/model/collage_details_model.dart';

class College {
  final String collegeCode;
  final int id;
  final String name;
  final StateModel state;
  final InstituteType instituteType;
  final int? yearEstablished;
  final bool hostelAvailable;
  final String? hostelFor;
  final Courses courses;
  final String? coverImage;

  College({
    required this.collegeCode,
    required this.id,
    required this.name,
    required this.state,
    required this.instituteType,
    required this.yearEstablished,
    required this.hostelAvailable,
    required this.hostelFor,
    required this.courses,
    required this.coverImage,
  });

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      collegeCode: json['college_code'].toString(),
      id: json['id'],
      name: json['college_name'],
      state: StateModel.fromJson(json['state']),
      instituteType: InstituteType.fromJson(json['institute_type']),
      yearEstablished: json['year_established'], 
      hostelAvailable: json['hostel_available'],
      hostelFor: json['hostel_for'],
      coverImage:
          json['cover_image'] is String &&
              json['cover_image'].toString().isNotEmpty
          ? json['cover_image']
          : null,
      courses: Courses.fromJson(json['courses']),
    );
  }
  String? get displayImage {
    if (coverImage != null && coverImage!.isNotEmpty) {
      return coverImage;
    }

    if (this is CollegeDetail) {
      final detail = this as CollegeDetail;
      if (detail.gallery.isNotEmpty) {
        return detail.gallery.first.imageUrl;
      }
    }

    return null;
  }
}

class StateModel {
  final int id;
  final String name;

  StateModel({required this.id, required this.name});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(id: json['id'], name: json['state_name']);
  }
}

class InstituteType {
  final int id;
  final String name;

  InstituteType({required this.id, required this.name});

  factory InstituteType.fromJson(Map<String, dynamic> json) {
    return InstituteType(id: json['id'], name: json['institute_type']);
  }
}

class Courses {
  final List<UgCourse> ug;
  final List<PgCourse> pg;

  Courses({required this.ug, required this.pg});

  factory Courses.fromJson(Map<String, dynamic> json) {
    return Courses(
      ug: (json['UG'] as List).map((e) => UgCourse.fromJson(e)).toList(),
      pg: (json['PG'] as List).map((e) => PgCourse.fromJson(e)).toList(),
    );
  }
}

class UgCourse {
  final int id;
  final String name;

  UgCourse({required this.id, required this.name});

  factory UgCourse.fromJson(Map<String, dynamic> json) {
    return UgCourse(id: json['id'], name: json['course_name']);
  }
}

class PgCourse {
  final int courseId;
  final String courseName;
  final int specialtyId;
  final String specialtyName;
  final String specialtyType;

  PgCourse({
    required this.courseId,
    required this.courseName,
    required this.specialtyId,
    required this.specialtyName,
    required this.specialtyType,
  });

  factory PgCourse.fromJson(Map<String, dynamic> json) {
    return PgCourse(
      courseId: json['course_id'],
      courseName: json['course_name'],
      specialtyId: json['specialty_id'],
      specialtyName: json['specialty_name'],
      specialtyType: json['specialty_type'],
    );
  }
}
