enum UpdateType { news, offer, alert, promo }

class UpdateModel {
  final String id;
  final String title;
  final String description;
  final UpdateType type;
  final String? imageUrl;

  UpdateModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.imageUrl,
  });
}
