class RequestGuidanceRequest {
  final int? counselorId;
  final int? subscriptionPlanId;
  final String subscriptionPlanName;
  final String subscriptionPlanCode;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String message;
  final String? email;

  RequestGuidanceRequest({
    this.counselorId,
    this.subscriptionPlanId,
    this.subscriptionPlanName = '',
    this.subscriptionPlanCode = '',
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.message,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (counselorId != null) "counselor_id": counselorId,
      if (subscriptionPlanId != null)
        "subscription_plan_id": subscriptionPlanId,
      if (subscriptionPlanName.trim().isNotEmpty)
        "subscription_plan_name": subscriptionPlanName.trim(),
      if (subscriptionPlanCode.trim().isNotEmpty)
        "subscription_plan_code": subscriptionPlanCode.trim(),
      "first_name": firstName,
      "last_name": lastName,
      "mobile_number": mobileNumber,
      "message": message,
      "email": email,
    };
  }
}

class GuidanceRequestCounselor {
  final int id;
  final String name;
  final String publicName;
  final String email;
  final String? mobileNumber;
  final String profileImage;
  final String primarySpecialization;
  final int experienceYears;
  final double rating;
  final String availability;

  GuidanceRequestCounselor({
    required this.id,
    required this.name,
    required this.publicName,
    required this.email,
    required this.mobileNumber,
    required this.profileImage,
    required this.primarySpecialization,
    required this.experienceYears,
    required this.rating,
    required this.availability,
  });

  factory GuidanceRequestCounselor.fromJson(Map<String, dynamic> json) {
    return GuidanceRequestCounselor(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
      publicName: json['public_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      mobileNumber: json['mobile_number']?.toString(),
      profileImage: json['profile_image']?.toString() ?? '',
      primarySpecialization: json['primary_specialization']?.toString() ?? '',
      experienceYears: _toInt(json['experience_years']),
      rating: _toDouble(json['rating']),
      availability: json['availability']?.toString() ?? 'busy',
    );
  }
}

class GuidanceRequestItem {
  final int requestId;
  final String status;
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNumber;
  final int? subscriptionPlanId;
  final String subscriptionPlanName;
  final String subscriptionPlanCode;
  final String message;
  final String? counselorMessage;
  final String? acceptedAt;
  final String createdAt;
  final String updatedAt;
  final bool isCounselorAssigned;
  final GuidanceRequestCounselor? counselor;

  GuidanceRequestItem({
    required this.requestId,
    required this.status,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNumber,
    required this.subscriptionPlanId,
    required this.subscriptionPlanName,
    required this.subscriptionPlanCode,
    required this.message,
    required this.counselorMessage,
    required this.acceptedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.isCounselorAssigned,
    required this.counselor,
  });

  factory GuidanceRequestItem.fromJson(Map<String, dynamic> json) {
    final counselorJson = json['counselor'];

    return GuidanceRequestItem(
      requestId: _toInt(json['request_id']),
      status: json['status']?.toString() ?? 'pending',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      mobileNumber: json['mobile_number']?.toString() ?? '',
      subscriptionPlanId: _toNullableInt(
        json['subscription_plan_id'] ?? json['plan_id'],
      ),
      subscriptionPlanName:
          json['subscription_plan_name']?.toString() ??
          json['plan_name']?.toString() ??
          '',
      subscriptionPlanCode:
          json['subscription_plan_code']?.toString() ??
          json['plan_code']?.toString() ??
          '',
      message: json['message']?.toString() ?? '',
      counselorMessage: json['counselor_message']?.toString(),
      acceptedAt: json['accepted_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      isCounselorAssigned: json['is_counselor_assigned'] == true,
      counselor: counselorJson is Map<String, dynamic>
          ? GuidanceRequestCounselor.fromJson(counselorJson)
          : null,
    );
  }

  bool get isAccepted => status.toLowerCase() == 'accepted';

  String get fullName {
    return '$firstName $lastName'.trim();
  }

  String get statusLabel {
    final normalized = status.trim().toLowerCase();
    if (normalized.isEmpty) return 'Pending';

    return normalized
        .split('_')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
  }
}

class RequestGuidanceResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? errors;

  RequestGuidanceResponse({
    required this.success,
    required this.message,
    this.errors,
  });

  factory RequestGuidanceResponse.fromJson(Map<String, dynamic> json) {
    print("PARSED ERRORS: ${json['errors']}");

    return RequestGuidanceResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      errors: json['errors'] is Map<String, dynamic>
          ? json['errors'] as Map<String, dynamic>
          : null,
    );
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

int? _toNullableInt(dynamic value) {
  if (value == null) return null;
  final parsed = _toInt(value);
  return parsed == 0 ? null : parsed;
}
