class NotificationSettingsModel {
  bool pushNotifications;
  bool emailNotifications;
  bool smsNotifications;
  bool predictionUpdates;
  bool chatMessages;
  bool paymentAlerts;
  bool announcements;

  NotificationSettingsModel({
    required this.pushNotifications,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.predictionUpdates,
    required this.chatMessages,
    required this.paymentAlerts,
    required this.announcements,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      pushNotifications: json['push_notifications'] ?? false,
      emailNotifications: json['email_notifications'] ?? false,
      smsNotifications: json['sms_notifications'] ?? false,
      predictionUpdates: json['prediction_updates'] ?? false,
      chatMessages: json['chat_messages'] ?? false,
      paymentAlerts: json['payment_alerts'] ?? false,
      announcements: json['announcements'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "push_notifications": pushNotifications,
      "email_notifications": emailNotifications,
      "sms_notifications": smsNotifications,
      "prediction_updates": predictionUpdates,
      "chat_messages": chatMessages,
      "payment_alerts": paymentAlerts,
      "announcements": announcements,
    };
  }
}
