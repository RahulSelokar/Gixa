class NotificationSettingsModel {
  Map<String, bool> email;
  Map<String, bool> push;

  NotificationSettingsModel({
    required this.email,
    required this.push,
  });

  factory NotificationSettingsModel.fromJson(
      Map<String, dynamic> json) {
    return NotificationSettingsModel(
      email: Map<String, bool>.from(json['EMAIL']),
      push: Map<String, bool>.from(json['PUSH']),
    );
  }
}
