class PredicationQuotaModel {
  final String quotaName;

  PredicationQuotaModel({required this.quotaName});

  factory PredicationQuotaModel.fromJson(Map<String, dynamic> json) {
    return PredicationQuotaModel(quotaName: json["quota_name"] ?? "");
  }
}
