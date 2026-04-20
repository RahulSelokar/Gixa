class QuotaModel {
  final int id;
  final String quotaName;
  final String? abbreviation;

  QuotaModel({
    required this.id,
    required this.quotaName,
    this.abbreviation,
  });

  factory QuotaModel.fromJson(Map<String, dynamic> json) {
    return QuotaModel(
      id: json['id'] ?? 0,
      quotaName: json['quota_name'] ?? '',
      abbreviation: json['Abbreviation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quota_name': quotaName,
      'Abbreviation': abbreviation,
    };
  }
}