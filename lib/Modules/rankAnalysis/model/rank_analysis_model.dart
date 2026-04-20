class RankAnalysisResponse {
  final bool success;
  final RankAnalysisModel data;

  RankAnalysisResponse({required this.success, required this.data});

  factory RankAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return RankAnalysisResponse(
      success: json['success'],
      data: RankAnalysisModel.fromJson(json['data']),
    );
  }
}

class RankAnalysisModel {
  final College college;
  final RankComparison rankComparison;
  final Analysis analysis;
  final List<CutoffTrend> cutoffTrend;
  final List<YearWiseCutoff> yearWiseCutoff;
  final List<CategoryCutoff> categoryCutoff;

  RankAnalysisModel({
    required this.college,
    required this.rankComparison,
    required this.analysis,
    required this.cutoffTrend,
    required this.yearWiseCutoff,
    required this.categoryCutoff,
  });

  factory RankAnalysisModel.fromJson(Map<String, dynamic> json) {
    return RankAnalysisModel(
      college: College.fromJson(json['college']),
      rankComparison: RankComparison.fromJson(json['rank_comparison']),
      analysis: Analysis.fromJson(json['analysis']),

      cutoffTrend: (json['cutoff_trend'] as List)
          .map((e) => CutoffTrend.fromJson(e))
          .toList(),

      yearWiseCutoff: (json['year_wise_cutoff'] as List)
          .map((e) => YearWiseCutoff.fromJson(e))
          .toList(),

      categoryCutoff: (json['category_cutoff'] as List)
          .map((e) => CategoryCutoff.fromJson(e))
          .toList(),
    );
  }
}

class College {
  final String collegeCode;
  final String collegeName;
  final String course;

  College({
    required this.collegeCode,
    required this.collegeName,
    required this.course,
  });

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      collegeCode: json['college_code']?.toString() ?? "",
      collegeName: json['college_name']?.toString() ?? "",
      course: json['course']?.toString() ?? "",
    );
  }
}

class RankComparison {
  final int userRank;
  final int lastYearCutoff;
  final int difference;
  final String chance;

  RankComparison({
    required this.userRank,
    required this.lastYearCutoff,
    required this.difference,
    required this.chance,
  });

  factory RankComparison.fromJson(Map<String, dynamic> json) {
    return RankComparison(
      userRank: json['user_rank'] ?? 0,
      lastYearCutoff: json['last_year_cutoff'] ?? 0,
      difference: json['difference'] ?? 0,
      chance: json['chance']?.toString() ?? "",
    );
  }
}

class Analysis {
  final String message;
  final String suggestionLevel;

  Analysis({required this.message, required this.suggestionLevel});

  factory Analysis.fromJson(Map<String, dynamic> json) {
    return Analysis(
      message: json['message']?.toString() ?? "",
      suggestionLevel: json['suggestion_level']?.toString() ?? "",
    );
  }
}

class CutoffTrend {
  final int year;
  final int closingRank;

  CutoffTrend({required this.year, required this.closingRank});

  factory CutoffTrend.fromJson(Map<String, dynamic> json) {
    return CutoffTrend(
      year: json['year'] ?? 0,
      closingRank: json['closing_rank'] ?? 0,
    );
  }
}

class YearWiseCutoff {
  final int year;
  final List<RoundCutoff> rounds;

  YearWiseCutoff({required this.year, required this.rounds});

  factory YearWiseCutoff.fromJson(Map<String, dynamic> json) {
    return YearWiseCutoff(
      year: json['year'],
      rounds: (json['rounds'] as List)
          .map((e) => RoundCutoff.fromJson(e))
          .toList(),
    );
  }
}

class RoundCutoff {
  final String round;
  final int closingRank;

  RoundCutoff({required this.round, required this.closingRank});

  factory RoundCutoff.fromJson(Map<String, dynamic> json) {
    return RoundCutoff(
      round: json['round']?.toString() ?? "-",
      closingRank: json['closing_rank'] ?? 0,
    );
  }
}

class CategoryCutoff {
  final String category;
  final int closingRank;

  CategoryCutoff({required this.category, required this.closingRank});

  factory CategoryCutoff.fromJson(Map<String, dynamic> json) {
    return CategoryCutoff(
      category: json['category']?.toString() ?? "",
      closingRank: json['closing_rank'] ?? 0,
    );
  }
}
