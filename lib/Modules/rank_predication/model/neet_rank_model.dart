class NeetRankResponse {
  final bool success;
  final String message;
  final NeetRankData data;

  NeetRankResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NeetRankResponse.fromJson(Map<String, dynamic> json) {
    return NeetRankResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: NeetRankData.fromJson(json['data'] ?? {}),
    );
  }
}

class NeetRankData {
  final int enteredScore;
  final int matchedScore;
  final bool exactMatch;
  final int predictedAir;
  final String tentativeMessage;
  final RankRange predictedAirRange;
  final int sameScoreCandidates;

  NeetRankData({
    required this.enteredScore,
    required this.matchedScore,
    required this.exactMatch,
    required this.predictedAir,
    required this.tentativeMessage,
    required this.predictedAirRange,
    required this.sameScoreCandidates,
  });

  factory NeetRankData.fromJson(Map<String, dynamic> json) {
    return NeetRankData(
      enteredScore: json['entered_score'] ?? 0,
      matchedScore: json['matched_score'] ?? 0,
      exactMatch: json['exact_match'] ?? false,
      predictedAir: json['predicted_air'] ?? 0,
      tentativeMessage: json['tentative_message'] ?? '',
      predictedAirRange: RankRange.fromJson(json['predicted_air_range'] ?? {}),
      sameScoreCandidates: json['same_score_candidates'] ?? 0,
    );
  }
}

class RankRange {
  final int? fromRank;
  final int? toRank;

  RankRange({required this.fromRank, required this.toRank});

  factory RankRange.fromJson(Map<String, dynamic> json) {
    return RankRange(
      fromRank: _toNullableInt(json['from_rank']),
      toRank: _toNullableInt(json['to_rank']),
    );
  }
}

int? _toNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed);
  }
  return null;
}
