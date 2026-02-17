class StudentDocumentModel {
  final int id;
  final String documentType;
  final String documentName;
  final String fileUrl;
  // final bool? isVerified;
  final DateTime uploadedAt;

  StudentDocumentModel({
    required this.id,
    required this.documentType,
    required this.documentName,
    required this.fileUrl,
    // this.isVerified,
    required this.uploadedAt,
  });

  factory StudentDocumentModel.fromJson(Map<String, dynamic> json) {
    return StudentDocumentModel(
      id: json['id'],
      documentType: json['document_type'],
      documentName: json['document_name'],
      fileUrl: json['file_url'],
      // isVerified: json['is_verified'] ?? false,
      uploadedAt: DateTime.parse(json['uploaded_at']),
    );
  }

  bool get isImage =>
      fileUrl.endsWith('.png') ||
      fileUrl.endsWith('.jpg') ||
      fileUrl.endsWith('.jpeg');

  bool get isPdf => fileUrl.endsWith('.pdf');
}
