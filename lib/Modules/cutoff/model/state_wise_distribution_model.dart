class StateWiseDistributionModel {
  final bool success;
  final String message;
  final StateWiseData? data;

  StateWiseDistributionModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory StateWiseDistributionModel.fromJson(Map<String, dynamic> json) {
    return StateWiseDistributionModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? StateWiseData.fromJson(json['data']) : null,
    );
  }
}

class StateWiseData {
  final String student;
  final String studentMobile;
  final String studentEmail;
  final int studentRank;
  final String course;
  final int year;
  final int totalStates;
  final int totalEligibleColleges;
  final List<ChartData> chartData;

  StateWiseData({
    required this.student,
    required this.studentMobile,
    required this.studentEmail,
    required this.studentRank,
    required this.course,
    required this.year,
    required this.totalStates,
    required this.totalEligibleColleges,
    required this.chartData,
  });

  factory StateWiseData.fromJson(Map<String, dynamic> json) {
    return StateWiseData(
      student: json['student'] ?? '',
      studentMobile: json['student_mobile'] ?? '',
      studentEmail: json['student_email'] ?? '',
      studentRank: json['student_rank'] ?? 0,
      course: json['course'] ?? '',
      year: json['year'] ?? 0,
      totalStates: json['total_states'] ?? 0,
      totalEligibleColleges: json['total_eligible_colleges'] ?? 0,
      chartData: (json['chart_data'] as List<dynamic>?)
              ?.map((e) => ChartData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ChartData {
  final int stateId;
  final String stateName;
  final int count;

  ChartData({
    required this.stateId,
    required this.stateName,
    required this.count,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      stateId: json['state_id'] ?? 0,
      stateName: json['state_name'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}
