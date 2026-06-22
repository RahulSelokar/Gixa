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
  final String type; // text | image | video | options
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
    final rawOptions = json['options'];

    return ChatMessage(
      id: json['id'].toString(),
      sender: json['sender'] ?? "",
      type: json['type'] ?? "text",
      content: json['content'],
      mediaUrl: json['media_url'],
      options: rawOptions is List
          ? rawOptions.map((e) => ChatOption.fromJson(e)).toList()
          : rawOptions is Map<String, dynamic>
          ? _parseOptionsMap(rawOptions)
          : null,
      createdAt: json['created_at'] ?? "",
    );
  }

  static List<ChatOption>? _parseOptionsMap(Map<String, dynamic> json) {
    final nested = json['options'] ?? json['data'] ?? json['items'];
    if (nested is List) {
      return nested.map((e) => ChatOption.fromJson(e)).toList();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'type': type,
      'content': content,
      'media_url': mediaUrl,
      'options': options?.map((option) => option.toJson()).toList(),
      'created_at': createdAt,
    };
  }
}

// ===============================
// CHAT OPTION (QUICK REPLY)
// ===============================

class ChatOption {
  final String key;
  final String label;

  ChatOption({required this.key, required this.label});

  factory ChatOption.fromJson(Map<String, dynamic> json) {
    final resolvedKey =
        (json['key'] ?? json['option_key'] ?? json['next_node_key'] ?? '')
            .toString();
    final resolvedLabel =
        (json['label'] ?? json['title'] ?? json['text'] ?? json['name'] ?? '')
            .toString();

    return ChatOption(key: resolvedKey, label: resolvedLabel);
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'label': label};
  }
}

// ===============================
// COMMON API RESPONSE (OPTIONAL)
// ===============================

class ChatCommonResponse {
  final String status;
  final String message;

  ChatCommonResponse({required this.status, required this.message});

  factory ChatCommonResponse.fromJson(Map<String, dynamic> json) {
    return ChatCommonResponse(
      status: json['status'] ?? "",
      message: json['message'] ?? "",
    );
  }
}

// ===============================
// CHAT SESSION
// ===============================

class ChatSession {
  final String sessionId;
  final String title;
  final String createdAt;

  ChatSession({
    required this.sessionId,
    required this.title,
    required this.createdAt,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    String parsedTitle = json['title']?.toString() ?? '';
    if (parsedTitle.isEmpty) {
      final String sid = (json['session_id'] ?? json['id'] ?? '').toString();
      if (sid.isNotEmpty) {
        // Show something like "Chat 8829ef" instead of full ID
        parsedTitle = 'Chat ${sid.length > 6 ? sid.substring(sid.length - 6) : sid}';
      } else {
        parsedTitle = 'New Conversation';
      }
    }

    return ChatSession(
      sessionId: (json['session_id'] ?? json['id'] ?? '').toString(),
      title: parsedTitle,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  String get formattedDate {
    if (createdAt.isEmpty) return 'Recent';
    try {
      final parsed = DateTime.parse(createdAt).toLocal();
      // Returns format like "Oct 12, 10:30 AM"
      return '${_monthAbbr(parsed.month)} ${parsed.day}, ${parsed.hour > 12 ? parsed.hour - 12 : (parsed.hour == 0 ? 12 : parsed.hour)}:${parsed.minute.toString().padLeft(2, '0')} ${parsed.hour >= 12 ? 'PM' : 'AM'}';
    } catch (_) {
      return createdAt.split('T').first;
    }
  }

  static String _monthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }
}
