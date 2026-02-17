class SaveCompareResponse {
  final String status;
  final String message;
  final int historyId;
  final int savedCollegesCount;

  SaveCompareResponse({
    required this.status,
    required this.message,
    required this.historyId,
    required this.savedCollegesCount,
  });

  factory SaveCompareResponse.fromJson(Map<String, dynamic> json) {
    return SaveCompareResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      historyId: json['history_id'] ?? 0,
      savedCollegesCount: json['saved_colleges_count'] ?? 0,
    );
  }
}
