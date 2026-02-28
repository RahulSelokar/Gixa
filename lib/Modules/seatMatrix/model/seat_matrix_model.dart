class SeatMatrixModel {
  final int collegeId;
  final String collegeName;
  final String state;
  final String instituteType;
  final int year;
  final String courseName;
  final String courseLevel;
  final String quota;
  final String counsellingRound;
  final int totalSeats;
  final List<CategorySeat> categories;

  SeatMatrixModel({
    required this.collegeId,
    required this.collegeName,
    required this.state,
    required this.instituteType,
    required this.year,
    required this.courseName,
    required this.courseLevel,
    required this.quota,
    required this.counsellingRound,
    required this.totalSeats,
    required this.categories,
  });

  factory SeatMatrixModel.fromJson(Map<String, dynamic> json) {
    return SeatMatrixModel(
      collegeId: json['college_id'] ?? 0,
      collegeName: json['college_name'] ?? '',
      state: json['state'] ?? '',
      instituteType: json['institute_type'] ?? '',
      year: json['year'] ?? 0,
      courseName: json['course_name'] ?? '',
      courseLevel: json['course_level'] ?? '',
      quota: json['quota'] ?? '',
      counsellingRound: json['counselling_round'] ?? '',
      totalSeats: json['total_seats'] ?? 0,
      categories: (json['categories'] as List? ?? [])
          .map((e) => CategorySeat.fromJson(e))
          .toList(),
    );
  }
}

class CategorySeat {
  final String category;
  final int seats;

  CategorySeat({
    required this.category,
    required this.seats,
  });

  factory CategorySeat.fromJson(Map<String, dynamic> json) {
    return CategorySeat(
      category: json['category'] ?? '',
      seats: json['seats'] ?? 0,
    );
  }
}