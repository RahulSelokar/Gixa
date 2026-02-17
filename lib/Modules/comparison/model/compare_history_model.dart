class CompareHistoryResponse {
  final String status;
  final int count;
  final List<CompareHistoryItem> history;

  CompareHistoryResponse({
    required this.status,
    required this.count,
    required this.history,
  });

  factory CompareHistoryResponse.fromJson(Map<String, dynamic> json) {
    return CompareHistoryResponse(
      status: json['status'] ?? '',
      count: json['count'] ?? 0,
      history: (json['history'] as List<dynamic>? ?? [])
          .map((e) => CompareHistoryItem.fromJson(e))
          .toList(),
    );
  }
}

class CompareHistoryItem {
  final int id;
  final String createdDate;
  final int totalColleges;
  final List<HistoryCollege> colleges;

  CompareHistoryItem({
    required this.id,
    required this.createdDate,
    required this.totalColleges,
    required this.colleges,
  });

  factory CompareHistoryItem.fromJson(Map<String, dynamic> json) {
    return CompareHistoryItem(
      id: json['id'],
      createdDate: json['created_date'] ?? '',
      totalColleges: json['total_colleges'] ?? 0,
      colleges: (json['colleges'] as List<dynamic>? ?? [])
          .map((e) => HistoryCollege.fromJson(e))
          .toList(),
    );
  }
}

class HistoryCollege {
  final String collegeCode;
  final String collegeName;
  final String city;

  HistoryCollege({
    required this.collegeCode,
    required this.collegeName,
    required this.city,
  });

  factory HistoryCollege.fromJson(Map<String, dynamic> json) {
    return HistoryCollege(
      collegeCode: json['college_code'] ?? '',
      collegeName: json['college_name'] ?? '',
      city: json['city'] ?? '',
    );
  }
}
