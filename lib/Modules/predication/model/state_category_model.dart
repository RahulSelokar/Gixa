class StateCategoryModel {
  final String state;
  final List<String> availableCategories;
  final List<String> availableHorizontalCategories;
  final List<String> availableCombinationKeys;
  final List<String> availableQuotas;

  StateCategoryModel({
    required this.state,
    required this.availableCategories,
    required this.availableHorizontalCategories,
    required this.availableCombinationKeys,
    required this.availableQuotas,
  });

  factory StateCategoryModel.fromJson(Map<String, dynamic> json) {
    return StateCategoryModel(
      state: json['state'] ?? '',
      availableCategories: List<String>.from(
        json['available_categories'] ?? [],
      ),
      availableHorizontalCategories: List<String>.from(
        json['available_horizontal_categories'] ?? [],
      ),
      availableCombinationKeys: List<String>.from(
        json['available_combination_keys'] ?? [],
      ),
      availableQuotas: List<String>.from(json['available_quotas'] ?? []),
    );
  }
}
