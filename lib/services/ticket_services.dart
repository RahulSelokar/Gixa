import 'package:Gixa/Modules/ticket/model/ticket_model.dart';
import 'package:Gixa/network/api_client.dart';
import 'package:Gixa/network/api_endpoints.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:io';

class TicketService {
  TicketService._();

  /// ================================
  /// ✅ CREATE TICKET
  /// ================================
  static Future<TicketResponseModel> createTicket({
    required int studentId,
    required String studentEmail,
    required String subject,
    required String description,
    File? attachment,
  }) async {
    Map<String, dynamic> fields = {
      "student_id": studentId,
      "student_email": studentEmail,
      "subject": subject,
      "description": description,
    };

    final response = attachment != null
        ? await ApiClient.postMultipart(
            ApiEndpoints.createTicket,
            file: attachment,
            fileFieldName: "attachment", // UPDATED FIELD NAME
            fields: fields,
          )
        : await ApiClient.postForm(ApiEndpoints.createTicket, fields);

    return TicketResponseModel.fromJson(response);
  }

  /// ================================
  /// ✅ GET ALL TICKETS
  /// ================================
  static Future<List<TicketModel>> getTickets({required int studentId}) async {
    final response = await ApiClient.get(
      ApiEndpoints.getTickets,
      queryParameters: {'student_id': studentId},
    );

    print("🔥 FULL TICKETS RESPONSE: $response");

    if (response['status'] == 'success') {
      final List ticketsList = response['data']['tickets'] ?? [];

      return ticketsList.map((e) => TicketModel.fromJson(e)).toList();
    }

    return [];
  }

  /// ================================
  /// ✅ SEND TICKET REPLY
  /// ================================
  static Future<Map<String, dynamic>> sendReply({
    required int ticketId,

    required int senderId,

    required String message,

    List<File> attachments = const [],
  }) async {
    try {
      final fields = {
        /// REQUIRED
        "ticket_id": ticketId.toString(),

        /// EDUTRACK USER ID
        "sender_id": senderId.toString(),

        "message": message,
      };

      print(
        "📤 SEND REPLY FIELDS => "
        "$fields",
      );

      print(
        "📎 ATTACHMENTS => "
        "${attachments.map((e) => e.path).toList()}",
      );

      /// WITH FILES
      if (attachments.isNotEmpty) {
        final response = await ApiClient.postMultipartFiles(
          ApiEndpoints.ticketReply,

          files: attachments,

          /// IMPORTANT
          fileFieldName: "attachments",

          fields: fields,
        );

        print(
          "✅ SEND REPLY RESPONSE => "
          "$response",
        );

        return response;
      }

      /// WITHOUT FILES
      final response = await ApiClient.postForm(
        ApiEndpoints.ticketReply,

        fields,
      );

      print(
        "✅ SEND REPLY RESPONSE => "
        "$response",
      );

      return response;
    } catch (e) {
      print("❌ SEND REPLY ERROR => $e");

      rethrow;
    }
  }

  /// ================================
  /// ✅ GET TICKET DETAILS
  /// ================================
  static Future<TicketDetailsModel> getTicketDetails(int ticketId) async {
    print("${ApiEndpoints.getTickets}$ticketId/");
    final response = await ApiClient.get(
      "${ApiEndpoints.getTickets}$ticketId/",
    );

    print("📥 TICKET DETAILS RESPONSE: $response");

    final data = response['data'];
    if (data is Map<String, dynamic> && data['tickets'] is List) {
      final tickets = List<Map<String, dynamic>>.from(
        (data['tickets'] as List).map(
          (e) => Map<String, dynamic>.from(e as Map),
        ),
      );
      final selectedTicket = tickets.firstWhere(
        (ticket) => ticket['id'] == ticketId,
        orElse: () => tickets.isNotEmpty ? tickets.first : <String, dynamic>{},
      );

      return TicketDetailsModel.fromJson({...response, 'data': selectedTicket});
    }

    return TicketDetailsModel.fromJson(response);
  }
}
