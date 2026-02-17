import 'dart:io';

import 'package:Gixa/Modules/Chatbot/model/chatbot_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class ChatApi {
  // =========================================================
  // START CHAT (WELCOME + BOT MESSAGES)
  // =========================================================
  static Future<ChatStartResponse> startChat({
    required int userId,
    String language = "en",
  }) async {
    final response = await ApiClient.post(ApiEndpoints.chatStart, {
      "user_id": userId,
      "language": language,
    });

    return ChatStartResponse.fromJson(response);
  }

  // =========================================================
  // BOT STATIC RESPONSE (QUICK REPLIES)
  // =========================================================
  static Future<List<ChatMessage>> botResponse({
    required String sessionId,
    required String selectedKey,
  }) async {
    final response = await ApiClient.post(ApiEndpoints.chatBotResponse, {
      "session_id": sessionId,
      "selected_key": selectedKey,
    });

    final List list = response['messages'] ?? [];

    return list.map((e) => ChatMessage.fromJson(e)).toList();
  }

  // SWITCH TO HUMAN COUNSELOR
  static Future<List<ChatMessage>> switchToHuman({
    required String sessionId,
    String? reason,
  }) async {
    final response = await ApiClient.post(ApiEndpoints.chatSwitchToHuman, {
      "session_id": sessionId,
      if (reason != null && reason.isNotEmpty) "reason": reason,
    });

    final List list = response['messages'] ?? [];
    return list.map((e) => ChatMessage.fromJson(e)).toList();
  }

  // SEND MESSAGE (TEXT / IMAGE / VIDEO)
  static Future<String?> sendMessage({
    required String sessionId,
    required String type,
    String? content,
    File? file,
  }) async {
    final response = file == null
        ? await ApiClient.post(ApiEndpoints.chatMessage, {
            "session_id": sessionId,
            "sender": "user",
            "type": type,
            if (content != null) "content": content,
          })
        : await ApiClient.postMultipart(
            ApiEndpoints.chatMessage,
            file: file,
            fileFieldName: "file",
            fields: {"session_id": sessionId, "sender": "user", "type": type},
          );

    return response?['message_id'];
  }

  // =========================================================
  // GET CHAT MESSAGES (HISTORY + POLLING)
  // =========================================================
  static Future<List<ChatMessage>> fetchMessages({
    required String sessionId,
    String? lastMessageId,
  }) async {
    final response = await ApiClient.get(
      ApiEndpoints.chatMessages(
        sessionId: sessionId,
        lastMessageId: lastMessageId,
      ),
    );

    final List list = response['messages'] ?? [];

    return list.map((e) => ChatMessage.fromJson(e)).toList();
  }

  // =========================================================
  // CLEAR CHAT (USER SIDE)
  // =========================================================
  static Future<void> clearChat({required String sessionId}) async {
    await ApiClient.post(ApiEndpoints.chatClear, {"session_id": sessionId});
  }

  // =========================================================
  // CLOSE CHAT SESSION
  // =========================================================
  static Future<void> closeChat({required String sessionId}) async {
    await ApiClient.post(ApiEndpoints.chatClose, {"session_id": sessionId});
  }
}
