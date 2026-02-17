// ===============================
// CHAT START RESPONSE
// ===============================

class ChatStartResponse {
  final String sessionId;
  final String mode;
  final List<ChatMessage> messages;

  ChatStartResponse({
    required this.sessionId,
    required this.mode,
    required this.messages,
  });

  factory ChatStartResponse.fromJson(Map<String, dynamic> json) {
    return ChatStartResponse(
      sessionId: json['session_id'].toString(),
      mode: json['mode'] ?? "bot",
      messages: (json['messages'] as List)
          .map((e) => ChatMessage.fromJson(e))
          .toList(),
    );
  }
}

// ===============================
// CHAT HISTORY RESPONSE
// ===============================

class ChatHistoryResponse {
  final List<ChatMessage> messages;
  final int currentPage;
  final int totalPages;

  ChatHistoryResponse({
    required this.messages,
    required this.currentPage,
    required this.totalPages,
  });

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ChatHistoryResponse(
      messages: (json['messages'] as List)
          .map((e) => ChatMessage.fromJson(e))
          .toList(),
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
    );
  }
}

// ===============================
// CHAT MESSAGE MODEL
// ===============================

class ChatMessage {
  final String id;
  final String sender; // bot | user | agent
  final String type;   // text | image | video | options
  final String? content;
  final String? mediaUrl;
  final List<ChatOption>? options;
  final String createdAt;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.type,
    this.content,
    this.mediaUrl,
    this.options,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'].toString(),
      sender: json['sender'] ?? "",
      type: json['type'] ?? "text",
      content: json['content'],
      mediaUrl: json['media_url'],
      options: json['options'] != null
          ? (json['options'] as List)
              .map((e) => ChatOption.fromJson(e))
              .toList()
          : null,
      createdAt: json['created_at'] ?? "",
    );
  }
}

// ===============================
// CHAT OPTION (QUICK REPLY)
// ===============================

class ChatOption {
  final String key;
  final String label;

  ChatOption({
    required this.key,
    required this.label,
  });

  factory ChatOption.fromJson(Map<String, dynamic> json) {
    return ChatOption(
      key: json['key'].toString(),
      label: json['label'] ?? "",
    );
  }
}

// ===============================
// COMMON API RESPONSE (OPTIONAL)
// ===============================

class ChatCommonResponse {
  final String status;
  final String message;

  ChatCommonResponse({
    required this.status,
    required this.message,
  });

  factory ChatCommonResponse.fromJson(Map<String, dynamic> json) {
    return ChatCommonResponse(
      status: json['status'] ?? "",
      message: json['message'] ?? "",
    );
  }
}
