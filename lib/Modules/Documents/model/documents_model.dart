class DocumentModel {
  final int id;
  final String documentType;
  final String documentName;
  final String fileUrl;
  final DateTime? uploadedAt;

  DocumentModel({
    required this.id,
    required this.documentType,
    required this.documentName,
    required this.fileUrl,
    this.uploadedAt,
  });

  /// 🔹 From API JSON
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] ?? 0,
      documentType: json['document_type'] ?? '',
      documentName: json['document_name'] ?? '',
      fileUrl: json['file'] ??
          json['file_url'] ??
          '',
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.tryParse(json['uploaded_at'])
          : null,
    );
  }

  /// 🔹 CopyWith (REQUIRED FOR UPDATE)
  DocumentModel copyWith({
    int? id,
    String? documentType,
    String? documentName,
    String? fileUrl,
    DateTime? uploadedAt,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      documentType: documentType ?? this.documentType,
      documentName: documentName ?? this.documentName,
      fileUrl: fileUrl ?? this.fileUrl,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }

  /// 🔹 To JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "document_type": documentType,
      "document_name": documentName,
      "file": fileUrl,
      "uploaded_at": uploadedAt?.toIso8601String(),
    };
  }
}
