class SubscriptionStateResponse {
  final bool status;
  final String message;
  final SubscriptionStateData data;

  SubscriptionStateResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SubscriptionStateResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionStateResponse(
      status: json['status'] ?? false,
      message: json['message']?.toString() ?? '',
      data: SubscriptionStateData.fromJson(json['data'] ?? {}),
    );
  }
}

class SubscriptionStateData {
  final int subscriptionId;
  final int planId;
  final String planName;
  final int? allowedStateCount;
  final int selectedStateCount;
  final List<StateItem> availableStates;
  final List<StateItem> selectedStates;

  SubscriptionStateData({
    required this.subscriptionId,
    required this.planId,
    required this.planName,
    required this.allowedStateCount,
    required this.selectedStateCount,
    required this.availableStates,
    required this.selectedStates,
  });

  factory SubscriptionStateData.fromJson(Map<String, dynamic> json) {
    return SubscriptionStateData(
      /// 🔥 SAFE INT PARSE
      subscriptionId:
          int.tryParse(json['subscription_id']?.toString() ?? '') ?? 0,

      planId: int.tryParse(json['plan_id']?.toString() ?? '') ?? 0,

      /// 🔥 SAFE STRING
      planName: json['plan_name']?.toString() ?? "",

      /// 🔥 NULLABLE SAFE
      allowedStateCount: json['allowed_state_count'] != null
          ? int.tryParse(json['allowed_state_count'].toString())
          : null,

      selectedStateCount:
          int.tryParse(json['selected_state_count']?.toString() ?? '') ?? 0,

      /// 🔥 SAFE LIST PARSE
      availableStates: (json['available_states'] as List?)
              ?.map((e) => StateItem.fromJson(e ?? {}))
              .toList() ??
          [],

      selectedStates: (json['selected_states'] as List?)
              ?.map((e) => StateItem.fromJson(e ?? {}))
              .toList() ??
          [],
    );
  }
}

class StateItem {
  final int id;
  final String name;

  StateItem({
    required this.id,
    required this.name,
  });

  factory StateItem.fromJson(Map<String, dynamic> json) {
    return StateItem(
      /// 🔥 MOST IMPORTANT FIX
      id: int.tryParse(
              (json['id'] ?? json['state_id'])?.toString() ?? '') ??
          -1,

      /// 🔥 HANDLE BOTH KEYS
      name: (json['name'] ?? json['state_name'])?.toString() ?? "Unknown",
    );
  }
}