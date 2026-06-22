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
  final int totalCategorySeats;
  final int aiqSeats;
  final int stateQuotaSeats;

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
    required this.aiqSeats,
    required this.stateQuotaSeats,
    required this.categories,
    required this.totalCategorySeats,
  });

  factory SeatMatrixModel.fromJson(Map<String, dynamic> json) {
    // Extract categories from state_quota
    List<CategorySeat> categoryList = [];

    if (json['state_quota'] != null &&
        json['state_quota']['categories'] != null) {
      categoryList = (json['state_quota']['categories'] as List)
          .map((e) => CategorySeat.fromJson(e))
          .toList();
    }

    return SeatMatrixModel(
      collegeId: int.tryParse(json['college_code']?.toString() ?? '0') ?? 0,
      collegeName: json['college_name']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      instituteType: json['institute_type']?.toString() ?? '',
      year: (json['year'] as num?)?.toInt() ?? 0,
      courseName: json['course_name']?.toString() ?? '',
      courseLevel: json['course_level']?.toString() ?? '',
      quota: json['quota']?.toString() ?? '',
      counsellingRound: json['counselling_round']?.toString() ?? '',
      totalSeats: (json['total_seats'] as num?)?.toInt() ?? 0,
      aiqSeats: (json['aiq_seats'] as num?)?.toInt() ?? 0,
      stateQuotaSeats: (json['state_quota_seats'] as num?)?.toInt() ?? 0,
      categories: categoryList,
      totalCategorySeats:
          (json['state_quota']?['total_category_seats'] as num?)?.toInt() ?? 0,
    );
  }
}

class CategorySeat {
  final String category;
  final int seats;

  CategorySeat({required this.category, required this.seats});

  factory CategorySeat.fromJson(Map<String, dynamic> json) {
    return CategorySeat(
      category: (json['category_name'] ?? '').toString().trim(),
      seats: (json['total_seats'] as num?)?.toInt() ?? 0,
    );
  }
}
