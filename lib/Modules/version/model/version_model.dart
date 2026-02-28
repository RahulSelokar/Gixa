class VersionModel {
  final bool updateRequired;
  final String updateType;
  final String latestVersion;
  final String releaseNotes;
  final String storeUrl;

  VersionModel({
    required this.updateRequired,
    required this.updateType,
    required this.latestVersion,
    required this.releaseNotes,
    required this.storeUrl,
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(
      updateRequired: json['update_required'] ?? false,
      updateType: json['update_type'] ?? '',
      latestVersion: json['latest_version'] ?? '',
      releaseNotes: json['release_notes'] ?? '',
      storeUrl: json['store_url'] ?? '',
    );
  }
}