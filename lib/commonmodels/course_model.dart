import 'specialty_model.dart';

class CourseModel {
  final int id;
  final String name;
  final List<SpecialtyModel> specialties;

  CourseModel({
    required this.id,
    required this.name,
    required this.specialties,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      name: json['course_name'],
      specialties: (json['specialties'] as List)
          .map((e) => SpecialtyModel.fromJson(e))
          .toList(),
    );
  }
}
