class AirComparisonModel {
  final UserData user;
  final GraphData graph;
  final Insight insight;
  final Meta meta;

  AirComparisonModel({
    required this.user,
    required this.graph,
    required this.insight,
    required this.meta,
  });

  factory AirComparisonModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return AirComparisonModel( 
      user: UserData.fromJson(data['user']),
      graph: GraphData.fromJson(data['graph']),
      insight: Insight.fromJson(data['insight']),
      meta: Meta.fromJson(data['meta']),
    );
  }
}

class UserData {
  final int air;
  final String state;
  final String category;
  final String course;
  final String quota;

  UserData({
    required this.air,
    required this.state,
    required this.category,
    required this.course,
    required this.quota,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      air: json['air'],
      state: json['state'],
      category: json['category'],
      course: json['course'],
      quota: json['quota'],
    );
  }
}

class GraphData {
  final List<int> years;
  final List<int> closingLine;
  final List<int> userAirLine;

  GraphData({
    required this.years,
    required this.closingLine,
    required this.userAirLine,
  });

  factory GraphData.fromJson(Map<String, dynamic> json) {
    return GraphData(
      years: List<int>.from(json['years']),
      closingLine: List<int>.from(json['closing_line']),
      userAirLine: List<int>.from(json['user_air_line']),
    );
  }
}

class Insight {
  final int closestYear;
  final String message;

  Insight({
    required this.closestYear,
    required this.message,
  });

  factory Insight.fromJson(Map<String, dynamic> json) {
    return Insight(
      closestYear: json['closest_year'],
      message: json['message'],
    );
  }
}

class Meta {
  final int totalYears;
  final bool isSingleYear;

  Meta({
    required this.totalYears,
    required this.isSingleYear,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      totalYears: json['total_years'],
      isSingleYear: json['is_single_year'],
    );
  }
}