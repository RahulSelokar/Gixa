class PredictionResponse {
  final bool success;
  final PredictionData data;

  PredictionResponse({
    required this.success,
    required this.data,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      success: json['success'] ?? false,
      data: PredictionData.fromJson(json['data'] ?? {}),
    );
  }
}

class PredictionData {
  final List<CollegeModel> safeColleges;
  final List<CollegeModel> moderateColleges;
  final List<CollegeModel> ambitiousColleges;
  final List<CollegeModel> noCutoffColleges;
  final int totalCount;
  final int? predictionId;
  final InputSummary inputSummary;

  PredictionData({
    required this.safeColleges,
    required this.moderateColleges,
    required this.ambitiousColleges,
    required this.noCutoffColleges,
    required this.totalCount,
    this.predictionId,
    required this.inputSummary,
  });

  factory PredictionData.fromJson(Map<String, dynamic> json) {
    return PredictionData(
      safeColleges: (json['safe_colleges'] as List? ?? [])
          .map((e) => CollegeModel.fromJson(e))
          .toList(),
      moderateColleges: (json['moderate_colleges'] as List? ?? [])
          .map((e) => CollegeModel.fromJson(e))
          .toList(),
      ambitiousColleges: (json['ambitious_colleges'] as List? ?? [])
          .map((e) => CollegeModel.fromJson(e))
          .toList(),
      noCutoffColleges: (json['no_cutoff_colleges'] as List? ?? [])
          .map((e) => CollegeModel.fromJson(e))
          .toList(),
      totalCount: json['total_count'] ?? 0,
      predictionId: json['prediction_id'],
      inputSummary: InputSummary.fromJson(json['input_summary'] ?? {}),
    );
  }
}

class CollegeModel {
  final int collegeId;
  final String collegeCode;
  final String collegeName;
  final String state;
  final String city;
  final String instituteType;
  final int? nirfRank;
  final String courseName;
  final String? specialtyName;
  final String courseLevel;
  final String quotaName;
  final String counsellingRound;
  final int totalSeats;
  final int? categorySeats;
  final int? cutoffAirFirst;
  final int? cutoffAirLast;
  final int? cutoffMarksFirst;
  final int? cutoffMarksLast;
  final String predictionBand;
  final double chancePercentage;
  final bool hostelAvailable;
  final String? hostelFor;
  final String? collegeWebsite;
  final bool isFavourite;

  CollegeModel({
    required this.collegeId,
    required this.collegeCode,
    required this.collegeName,
    required this.state,
    required this.city,
    required this.instituteType,
    this.nirfRank,
    required this.courseName,
    this.specialtyName,
    required this.courseLevel,
    required this.quotaName,
    required this.counsellingRound,
    required this.totalSeats,
    this.categorySeats,
    this.cutoffAirFirst,
    this.cutoffAirLast,
    this.cutoffMarksFirst,
    this.cutoffMarksLast,
    required this.predictionBand,
    required this.chancePercentage,
    required this.hostelAvailable,
    this.hostelFor,
    this.collegeWebsite,
    required this.isFavourite,
  });

  factory CollegeModel.fromJson(Map<String, dynamic> json) {
    return CollegeModel(
      collegeId: json['college_id'] ?? 0,
      collegeCode: json['college_code'] ?? "",
      collegeName: json['college_name'] ?? "",
      state: json['state'] ?? "",
      city: json['city'] ?? "",
      instituteType: json['institute_type'] ?? "",
      nirfRank: json['nirf_rank'],
      courseName: json['course_name'] ?? "",
      specialtyName: json['specialty_name'],
      courseLevel: json['course_level'] ?? "",
      quotaName: json['quota_name'] ?? "",
      counsellingRound: json['counselling_round'] ?? "",
      totalSeats: json['total_seats'] ?? 0,
      categorySeats: json['category_seats'],
      cutoffAirFirst: json['cutoff_air_first'],
      cutoffAirLast: json['cutoff_air_last'],
      cutoffMarksFirst: json['cutoff_marks_first'],
      cutoffMarksLast: json['cutoff_marks_last'],
      predictionBand: json['prediction_band'] ?? "",
      chancePercentage:
          (json['chance_percentage'] ?? 0).toDouble(),
      hostelAvailable: json['hostel_available'] ?? false,
      hostelFor: json['hostel_for'],
      collegeWebsite: json['college_website'],
      isFavourite: json['is_favourite'] ?? false,
    );
  }
}

class InputSummary {
  final int allIndiaRank;
  final String category;
  final String course;
  final int year;
  final String state;
  final String quota;
  final String counsellingRound;

  InputSummary({
    required this.allIndiaRank,
    required this.category,
    required this.course,
    required this.year,
    required this.state,
    required this.quota,
    required this.counsellingRound,
  });

  factory InputSummary.fromJson(Map<String, dynamic> json) {
    return InputSummary(
      allIndiaRank: json['all_india_rank'] ?? 0,
      category: json['category'] ?? "",
      course: json['course'] ?? "",
      year: json['year'] ?? 0,
      state: json['state'] ?? "",
      quota: json['quota'] ?? "",
      counsellingRound: json['counselling_round'] ?? "",
    );
  }
}