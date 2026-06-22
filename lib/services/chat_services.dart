import 'dart:io';

import 'package:Gixa/Modules/Chatbot/model/chatbot_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';

class ChatApi {
  static void _logRequest(String name, String endpoint, Object body) {
    try {
      print('ChatApi.$name -> $endpoint');
      print('ChatApi.$name request body: $body');
    } catch (_) {}
  }

  static Future<ChatStartResponse> startChat({
    required int userId,
    String language = "en",
  }) async {
    final body = {"user_id": userId, "language": language};
    _logRequest('startChat', ApiEndpoints.chatStart, body);

    final response = await ApiClient.post(ApiEndpoints.chatStart, body);

    // Debug: print raw backend response for inspection
    try {
      print('ChatApi.startChat - raw response: $response');
    } catch (_) {}

    try {
      final sessionId = response['session_id'];
      print('ChatApi.startChat - session_id: $sessionId');
    } catch (_) {}

    return ChatStartResponse.fromJson(response);
  }

  /// ADMISSION-SPECIFIC START
  static Future<ChatStartResponse> admissionStart({
    required String userId,
  }) async {
    final body = {"user_id": userId};
    _logRequest('admissionStart', ApiEndpoints.chatAdmission, body);

    final response = await ApiClient.post(ApiEndpoints.chatAdmission, body);

    // Debug: don't print in production
    try {
      final sessionId = response['session_id'];
      print('ChatApi.admissionStart - session_id: $sessionId');
    } catch (_) {}

    return ChatStartResponse.fromJson(response);
  }

  static Future<List<ChatMessage>> botResponse({
    required String userId,
    required String sessionId,
    required String selectedKey,
    String? selectedLabel,
  }) async {
    final body = {
      "user_id": userId,
      "session_id": sessionId,
      "selected_key": selectedKey,
      if (selectedLabel != null && selectedLabel.isNotEmpty)
        "selected_label": selectedLabel,
    };
    _logRequest('botResponse', ApiEndpoints.chatBotResponse, body);

    final response = await ApiClient.post(ApiEndpoints.chatBotResponse, body);

    // Debug: print raw backend response for inspection
    try {
      print('ChatApi.botResponse - raw response: $response');
    } catch (_) {}

    final List list = response['messages'] ?? [];

    return list.map((e) => ChatMessage.fromJson(e)).toList();
  }

  // SWITCH TO HUMAN COUNSELOR
  static Future<List<ChatMessage>> switchToHuman({
    required String sessionId,
    String? reason,
    String? selectedKey,
    String? selectedLabel,
  }) async {
    final body = {
      "session_id": sessionId,
      if (reason != null && reason.isNotEmpty) "reason": reason,
      if (selectedKey != null && selectedKey.isNotEmpty)
        "selected_key": selectedKey,
      if (selectedLabel != null && selectedLabel.isNotEmpty)
        "selected_label": selectedLabel,
    };
    _logRequest('switchToHuman', ApiEndpoints.chatSwitchToHuman, body);

    final response = await ApiClient.post(ApiEndpoints.chatSwitchToHuman, body);
    try {
      print('ChatApi.switchToHuman - raw response: $response');
    } catch (_) {}

    final List list = response['messages'] ?? [];
    return list.map((e) => ChatMessage.fromJson(e)).toList();
  }

  static Future<String?> sendMessage({
    required String sessionId,
    required String type,
    String? content,
    File? file,
  }) async {
    final body = {
      "session_id": sessionId,
      "sender": "user",
      "type": type,
      if (content != null) "content": content,
      if (file != null) "file": file.path,
    };
    _logRequest('sendMessage', ApiEndpoints.chatMessage, body);

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

    // Debug: print raw backend response for inspection
    try {
      print('ChatApi.sendMessage - raw response: $response');
    } catch (_) {}

    return response['message_id'];
  }

  static Future<List<ChatMessage>> fetchMessages({
    required String sessionId,
    String? lastMessageId,
  }) async {
    final endpoint = ApiEndpoints.chatMessages(
      sessionId: sessionId,
      lastMessageId: lastMessageId,
    );
    _logRequest('fetchMessages', endpoint, {
      "session_id": sessionId,
      if (lastMessageId != null) "last_message_id": lastMessageId,
    });

    final response = await ApiClient.get(endpoint);

    // Debug: print raw backend response for inspection
    try {
      print('ChatApi.fetchMessages - raw response: $response');
    } catch (_) {}

    final List list = response['messages'] ?? [];

    return list.map((e) => ChatMessage.fromJson(e)).toList();
  }

  // =========================================================
  // CHAT SESSIONS & HISTORY
  // =========================================================

  static Future<List<ChatSession>> fetchChatSessions({
    required String entryFlow,
  }) async {
    final endpoint = ApiEndpoints.chatSessions(entryFlow);
    _logRequest('fetchChatSessions', endpoint, {});

    final response = await ApiClient.get(endpoint);

    try {
      print('ChatApi.fetchChatSessions - raw response: $response');
    } catch (_) {}

    List list = [];
    if (response is List) {
      list = response;
    } else if (response is Map) {
      list =
          response['sessions'] ?? response['results'] ?? response['data'] ?? [];
      if (list.isEmpty &&
          response.containsKey('data') &&
          response['data'] is Map) {
        final dataMap = response['data'] as Map;
        list = dataMap['sessions'] ?? dataMap['results'] ?? [];
      }
    }

    return list.map((e) => ChatSession.fromJson(e)).toList();
  }

  static Future<List<ChatMessage>> fetchChatHistory({
    required String sessionId,
  }) async {
    final endpoint = ApiEndpoints.chatHistory(sessionId);
    _logRequest('fetchChatHistory', endpoint, {});

    final response = await ApiClient.get(endpoint);

    try {
      print('ChatApi.fetchChatHistory - raw response: $response');
    } catch (_) {}

    List list = [];
    if (response is List) {
      list = response;
    } else if (response is Map) {
      list =
          response['messages'] ?? response['results'] ?? response['data'] ?? [];
      if (list.isEmpty &&
          response.containsKey('data') &&
          response['data'] is Map) {
        final dataMap = response['data'] as Map;
        list = dataMap['messages'] ?? dataMap['results'] ?? [];
      }
    }

    return list.map((e) => ChatMessage.fromJson(e)).toList();
  }

  // =========================================================
  // CLEAR CHAT (USER SIDE)
  // =========================================================
  static Future<void> clearChat({required String sessionId}) async {
    final body = {"session_id": sessionId};
    _logRequest('clearChat', ApiEndpoints.chatClear, body);

    await ApiClient.post(ApiEndpoints.chatClear, body);
  }

  // =========================================================
  // CLOSE CHAT SESSION
  // =========================================================
  static Future<void> closeChat({required String sessionId}) async {
    final body = {"session_id": sessionId};
    _logRequest('closeChat', ApiEndpoints.chatClose, body);

    await ApiClient.post(ApiEndpoints.chatClose, body);
  }
}
