class TicketResponseModel {
  final int id;
  final String subject;
  final String description;
  final String status;

  TicketResponseModel({
    required this.id,
    required this.subject,
    required this.description,
    required this.status,
  });

  factory TicketResponseModel.fromJson(Map<String, dynamic> json) {
    return TicketResponseModel(
      id: json['id'] ?? 0,
      subject: json['subject'] ?? "",
      description: json['description'] ?? "",
      status: json['status'] ?? "Open",
    );
  }
}

class TicketModel {
  final int id;
  final String ticketNumber;
  final String subject;
  final String description;
  final String status;
  final String createdAt;

  TicketModel({
    required this.id,
    required this.ticketNumber,
    required this.subject,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] ?? 0,
      ticketNumber: json['ticket_number'] ?? "",
      subject: json['subject'] ?? "",
      description: json['description'] ?? "",
      status: json['status'] ?? "",
      createdAt: json['created_at'] ?? "",
    );
  }
}

class TicketReply {
  final int replyId;
  final String replyBy;
  final String message;
  final String createdAt;

  TicketReply({
    required this.replyId,
    required this.replyBy,
    required this.message,
    required this.createdAt,
  });

  factory TicketReply.fromJson(Map<String, dynamic> json) {
    return TicketReply(
      replyId: json['reply_id'],
      replyBy: json['reply_by'],
      message: json['message'],
      createdAt: json['created_at'],
    );
  }
}

class TicketDetailsModel {
  final String ticketNumber;
  final String subject;
  final String description;
  final String status;
  final String createdAt;
  final List<TicketReply> replies;

  TicketDetailsModel({
    required this.ticketNumber,
    required this.subject,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.replies,
  });

  factory TicketDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return TicketDetailsModel(
      ticketNumber: data['ticket_number'] ?? "",
      subject: (json['subject'] ?? "").toString().replaceAll('"', ''),
      description: (json['description'] ?? "").toString().replaceAll('"', ''),
      status: data['status'] ?? "",
      createdAt: data['created_at'] ?? "",
      replies: (data['replies'] ?? [])
          .map<TicketReply>((e) => TicketReply.fromJson(e))
          .toList(),
    );
  }
}
