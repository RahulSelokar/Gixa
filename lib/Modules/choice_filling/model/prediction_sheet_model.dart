class PredictionSheetModel {
  final int id;
  final String fileName;
  final String fileUrl;
  final DateTime? createdAt;
  final bool isSent;
  final DateTime? sentAt;

  PredictionSheetModel({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    this.createdAt,
    required this.isSent,
    this.sentAt,
  });

  factory PredictionSheetModel.fromJson(Map<String, dynamic> json) {
    return PredictionSheetModel(
      id: json['id'] ?? 0,
      fileName: json['file_name'] ?? '',
      fileUrl: json['file_url'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      isSent: json['is_sent'] ?? false,
      sentAt: json['sent_at'] != null
          ? DateTime.tryParse(json['sent_at'])
          : null,
    );
  }
}