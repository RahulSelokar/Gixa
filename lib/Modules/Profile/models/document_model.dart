class Document {
  final int? id;
  final String? name;
  final String? fileUrl;

  Document({
    this.id,
    this.name,
    this.fileUrl,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      name: json['name'],
      fileUrl: json['file_url'],
    );
  }
}
