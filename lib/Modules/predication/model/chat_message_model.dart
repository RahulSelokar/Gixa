class ChatMessageModel {
  final String message;
  final bool isBot;
  final List<String>? options;
  final String? questionKey;

  ChatMessageModel({
    required this.message,
    required this.isBot,
    this.options,
    this.questionKey,
  });
}