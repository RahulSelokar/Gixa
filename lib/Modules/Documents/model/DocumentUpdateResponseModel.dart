class DocumentUpdateResponseModel {
  final String message;
  final int documentId;
  final String documentType;

  DocumentUpdateResponseModel({
    required this.message,
    required this.documentId,
    required this.documentType,
  });

  factory DocumentUpdateResponseModel.fromJson(
      Map<String, dynamic> json) {
    return DocumentUpdateResponseModel(
      message: json['message'] ?? '',
      documentId: json['document_id'] ?? 0,
      documentType: json['document_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'document_id': documentId,
      'document_type': documentType,
    };
  }
}
