class CategoryModel {
  final int id;
  final String name;
  final int totalSeats;

  CategoryModel({
    required this.id,
    required this.name,
    required this.totalSeats,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0, 
      name: (json['category_name'] ?? '').trim(), // remove extra spaces
      totalSeats: json['total_seats'] ?? 0,
    );
  }
}