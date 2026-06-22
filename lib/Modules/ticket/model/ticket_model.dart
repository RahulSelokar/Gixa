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

/// =======================================================
/// TICKET LIST MODEL
/// =======================================================

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

/// =======================================================
/// ATTACHMENT MODEL
/// =======================================================

class TicketAttachment {
  final int id;

  final String file;

  final String name;

  final String icon;

  TicketAttachment({
    required this.id,
    required this.file,
    required this.name,
    required this.icon,
  });

  factory TicketAttachment.fromJson(Map<String, dynamic> json) {
    return TicketAttachment(
      id: json['id'] ?? 0,

      file: json['file'] ?? "",

      name: json['name'] ?? "",

      icon: json['icon'] ?? "",
    );
  }
}

/// =======================================================
/// CHAT MESSAGE MODEL
/// =======================================================

class TicketMessage {
  final int id;

  final String sender;

  final String senderRole;

  final String message;

  final String createdAt;

  final List<TicketAttachment> attachments;

  TicketMessage({
    required this.id,
    required this.sender,
    required this.senderRole,
    required this.message,
    required this.createdAt,
    required this.attachments,
  });

  factory TicketMessage.fromJson(Map<String, dynamic> json) {
    return TicketMessage(
      id: json['id'] ?? 0,

      sender: json['sender'] ?? "",

      senderRole: json['sender_role'] ?? "",

      message: json['message'] ?? "",

      createdAt: json['created_at'] ?? "",

      attachments:
          (json['attachments'] as List?)
              ?.map((e) => TicketAttachment.fromJson(e))
              .toList() ??
          [],
    );
  }

  TicketMessage copyWith({
    int? id,
    String? sender,
    String? senderRole,
    String? message,
    String? createdAt,
    List<TicketAttachment>? attachments,
  }) {
    return TicketMessage(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      senderRole: senderRole ?? this.senderRole,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      attachments: attachments ?? this.attachments,
    );
  }
}

/// =======================================================
/// TICKET DETAILS MODEL
/// =======================================================

class TicketDetailsModel {
  final int ticketId;

  final String ticketNumber;

  final String subject;

  final String description;

  final String status;

  final String priority;

  final bool isReplied;

  final String createdAt;

  final String updatedAt;

  final String attachmentUrl;

  final List<TicketMessage> messages;

  TicketDetailsModel({
    required this.ticketId,
    required this.ticketNumber,
    required this.subject,
    required this.description,
    required this.status,
    required this.priority,
    required this.isReplied,
    required this.createdAt,
    required this.updatedAt,
    required this.attachmentUrl,
    required this.messages,
  });

  factory TicketDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? <String, dynamic>{};

    return TicketDetailsModel(
      ticketId: _toInt(data['ticket_id']) ?? 0,

      ticketNumber: (data['ticket_number'] ?? "").toString(),

      subject: (data['subject'] ?? "").toString(),

      description: (data['description'] ?? "").toString(),

      status: (data['status'] ?? "").toString(),

      priority: (data['priority'] ?? "").toString(),

      isReplied: data['is_replied'] ?? false,

      createdAt: (data['created_at'] ?? "").toString(),

      updatedAt: (data['updated_at'] ?? "").toString(),

      attachmentUrl: (data['attachment_url'] ?? "").toString(),

      messages:
          (data['messages'] as List?)
              ?.map((e) => TicketMessage.fromJson(e))
              .toList() ??
          [],
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }
}
