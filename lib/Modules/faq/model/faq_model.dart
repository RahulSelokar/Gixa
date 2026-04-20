class FaqItem {
  final int id;
  final String question;
  final String answer;
  final int order;
  final String createdAt;
  final String updatedAt;

  FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      order: json['order'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}