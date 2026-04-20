class RoundModel {
  final int id;
  final String roundName;
  final int order;
  final String type;
  final bool isActive;

  RoundModel({
    required this.id,
    required this.roundName,
    required this.order,
    required this.type,
    required this.isActive,
  });

  factory RoundModel.fromJson(Map<String, dynamic> json) {
    return RoundModel(
      id: json['id'],
      roundName: json['round_name'],
      order: json['round_order'],
      type: json['round_type'],
      isActive: json['is_active'],
    );
  }
}