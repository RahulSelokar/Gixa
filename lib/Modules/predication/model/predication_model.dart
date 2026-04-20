// ===============================
// PredictionResponse
// ===============================

class PredictionResponse {
  final bool success;
  final PredictionData data;

  PredictionResponse({required this.success, required this.data});

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      success: json["success"] ?? false,
      data: PredictionData.fromApiResponse(json),
    );
  }
}

// ===============================
// PredictionData
// ===============================

class PredictionData {
  final bool noChanceInHomeState;
  final int totalCount;
  final int? predictionId;
  final InputSummary inputSummary;
  final List<CollegeModel> collegeList;
  final String? message;

  PredictionData({
    required this.noChanceInHomeState,
    required this.totalCount,
    this.predictionId,
    required this.inputSummary,
    required this.collegeList,
    this.message,
  });

  /// 🔥 MAIN FACTORY (handles BOTH responses)
  factory PredictionData.fromApiResponse(Map<String, dynamic> json) {
    /// ❌ NO COLLEGE CASE (IMPORTANT - FIRST CHECK)
    if (json["success"] == false && json["data"] == null) {
      return PredictionData(
        noChanceInHomeState: true,
        totalCount: 0,
        predictionId: null,
        inputSummary: InputSummary.empty(),
        collegeList: [],
        message: json["message"],
      );
    }

    /// ✅ SUCCESS CASE (Govt Colleges)
    if (json["success"] == true) {
      final List list = json["data"] ?? [];

      return PredictionData(
        noChanceInHomeState: false,
        totalCount: json["total_colleges"] ?? list.length,
        predictionId: null,
        inputSummary: InputSummary.empty(),
        collegeList: list.map((e) => CollegeModel.fromApiJson(e)).toList(),
        message: json["message"],
      );
    }

    /// ⚠️ PRIVATE SUGGESTION CASE
    if (json["suggestion_type"] == "private_college") {
      final List list = json["data"] ?? [];

      return PredictionData(
        noChanceInHomeState: true,
        totalCount: list.length,
        predictionId: null,
        inputSummary: InputSummary.empty(),
        collegeList: list
            .map((e) => CollegeModel.fromSuggestionJson(e))
            .toList(),
        message: json["message"],
      );
    }

    /// ❌ DEFAULT
    return PredictionData(
      noChanceInHomeState: true,
      totalCount: 0,
      predictionId: null,
      inputSummary: InputSummary.empty(),
      collegeList: [],
      message: json["message"],
    );
  }
}

// ===============================
// CollegeModel
// ===============================

class CollegeModel {
  final int id;
  final String collegeCode;
  final String collegeName;

  final String state;
  final String city;

  final String instituteType;
  final int? nirfRank;

  final String courseName;
  final String? specialtyName;
  final String courseLevel;

  final String admissionCategory;
  final String collegeType;

  final String quotaCode;
  final String quotaName;

  final String counsellingRound;

  final int totalSeats;
  final int? categorySeats;

  final int? cutoffAirFirst;
  final int? cutoffAirLast;

  final int? cutoffMarksFirst;
  final int? cutoffMarksLast;

  final bool hostelAvailable;
  final String? hostelFor;

  final String? collegeWebsite;

  final bool isFavourite;

  CollegeModel({
    required this.id,
    required this.collegeCode,
    required this.collegeName,
    required this.state,
    required this.city,
    required this.instituteType,
    this.nirfRank,
    required this.courseName,
    this.specialtyName,
    required this.courseLevel,
    required this.admissionCategory,
    required this.collegeType,
    required this.quotaCode,
    required this.quotaName,
    required this.counsellingRound,
    required this.totalSeats,
    this.categorySeats,
    this.cutoffAirFirst,
    this.cutoffAirLast,
    this.cutoffMarksFirst,
    this.cutoffMarksLast,
    required this.hostelAvailable,
    this.hostelFor,
    this.collegeWebsite,
    required this.isFavourite,
  });

  // ===================================
  // ✅ GOVT / NORMAL RESPONSE
  // ===================================
  factory CollegeModel.fromApiJson(Map<String, dynamic> json) {
    final college = json["college"] ?? {};

    return CollegeModel(
      id: (college["college_id"] as num?)?.toInt() ?? 0,
      collegeCode: college["college_code"]?.toString() ?? "",
      collegeName: college["college_name"]?.toString() ?? "",

      state: college["state"]?.toString() ?? "",
      city: college["city"]?.toString() ?? "",

      instituteType: college["institute_type"]?.toString() ?? "",
      nirfRank: null,

      courseName: json["course"]?.toString() ?? "",
      specialtyName: null,
      courseLevel: "UG",

      admissionCategory: json["category"]?.toString() ?? "",
      collegeType: "Medical",

      quotaCode: "",
      quotaName: json["quota"]?.toString() ?? "",

      counsellingRound: json["round"]?.toString() ?? "",

      totalSeats: 0,
      categorySeats: null,

      cutoffAirFirst: (json["opening_rank"] as num?)?.toInt(),
      cutoffAirLast: (json["closing_rank"] as num?)?.toInt(),

      cutoffMarksFirst: null,
      cutoffMarksLast: null,

      hostelAvailable: false,
      hostelFor: null,

      collegeWebsite: null,

      isFavourite: false,
    );
  }

  // ===================================
  // 🔥 FIXED PRIVATE SUGGESTION
  // ===================================
  factory CollegeModel.fromSuggestionJson(Map<String, dynamic> json) {
    final college = json["college"] ?? {};

    return CollegeModel(
      // ✅🔥 MOST IMPORTANT FIX
      id: (college["college_id"] as num?)?.toInt() ?? 0,

      collegeCode: college["college_code"]?.toString() ?? "",
      collegeName: college["college_name"]?.toString() ?? "",

      state: college["state"]?.toString() ?? "",
      city: college["city"]?.toString() ?? "",

      instituteType: college["institute_type"]?.toString() ?? "Private",
      nirfRank: null,

      courseName: json["course"]?.toString() ?? "",
      specialtyName: null,
      courseLevel: "UG",

      admissionCategory: json["category"]?.toString() ?? "",
      collegeType: "Medical",

      quotaCode: "",
      quotaName: json["quota"]?.toString() ?? "",

      counsellingRound: json["round"]?.toString() ?? "",

      totalSeats: 0,
      categorySeats: null,

      cutoffAirFirst: (json["opening_rank"] as num?)?.toInt(),
      cutoffAirLast: (json["closing_rank"] as num?)?.toInt(),

      cutoffMarksFirst: null,
      cutoffMarksLast: null,

      hostelAvailable: false,
      hostelFor: null,

      collegeWebsite: null,

      isFavourite: false,
    );
  }

  CollegeModel copyWith({bool? isFavourite}) {
    return CollegeModel(
      id: id,
      collegeCode: collegeCode,
      collegeName: collegeName,
      state: state,
      city: city,
      instituteType: instituteType,
      nirfRank: nirfRank,
      courseName: courseName,
      specialtyName: specialtyName,
      courseLevel: courseLevel,
      admissionCategory: admissionCategory,
      collegeType: collegeType,
      quotaCode: quotaCode,
      quotaName: quotaName,
      counsellingRound: counsellingRound,
      totalSeats: totalSeats,
      categorySeats: categorySeats,
      cutoffAirFirst: cutoffAirFirst,
      cutoffAirLast: cutoffAirLast,
      cutoffMarksFirst: cutoffMarksFirst,
      cutoffMarksLast: cutoffMarksLast,
      hostelAvailable: hostelAvailable,
      hostelFor: hostelFor,
      collegeWebsite: collegeWebsite,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}

// ===============================
// InputSummary
// ===============================

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
      allIndiaRank: json["all_india_rank"] ?? 0,
      category: json["category"] ?? "",
      course: json["course"] ?? "",
      year: json["year"] ?? 0,
      state: json["state"] ?? "",
      quota: json["quota"] ?? "",
      counsellingRound: json["counselling_round"] ?? "",
    );
  }

  /// 🔥 EMPTY (for your API)
  factory InputSummary.empty() {
    return InputSummary(
      allIndiaRank: 0,
      category: "",
      course: "",
      year: 0,
      state: "",
      quota: "",
      counsellingRound: "",
    );
  }
}
