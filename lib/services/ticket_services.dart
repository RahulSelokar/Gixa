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
    File? mediaFile,
  }) async {
    Map<String, dynamic> fields = {
      "student_id": studentId,
      "student_email": studentEmail,
      "subject": subject,
      "description": description,
    };

    final response = mediaFile != null
        ? await ApiClient.postMultipart(
            ApiEndpoints.createTicket,
            file: mediaFile,
            fileFieldName: "media", // IMPORTANT
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
  /// ✅ GET TICKET DETAILS
  /// ================================
  static Future<TicketDetailsModel> getTicketDetails(int ticketId) async {
    print("${ApiEndpoints.getTickets}$ticketId/");
    final response = await ApiClient.get(
      "${ApiEndpoints.getTickets}$ticketId/",
    );

    print("📥 TICKET DETAILS RESPONSE: $response");

    return TicketDetailsModel.fromJson(response);
  }
}
