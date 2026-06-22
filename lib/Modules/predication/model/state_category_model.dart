class StateCategoryModel {
  final String state;
  final String stateDisplay;
  final List<String> availableCategories;
  final Map<String, String> availableCategoriesFullForms;
  final List<String> availableHorizontalCategories;
  final Map<String, String> availableHorizontalCategoriesFullForms;
  final List<String> availableCombinationKeys;
  final List<String> availableQuotas;

  StateCategoryModel({
    required this.state,
    required this.stateDisplay,
    required this.availableCategories,
    required this.availableCategoriesFullForms,
    required this.availableHorizontalCategories,
    required this.availableHorizontalCategoriesFullForms,
    required this.availableCombinationKeys,
    required this.availableQuotas,
  });

  factory StateCategoryModel.fromJson(Map<String, dynamic> json) {
    final categoryFullForms = (json['available_categories_full_forms'] as Map?)
            ?.map(
              (key, value) => MapEntry(
                key.toString(),
                value?.toString().trim() ?? '',
              ),
            ) ??
        <String, String>{};
    final horizontalFullForms =
        (json['available_horizontal_categories_full_forms'] as Map?)?.map(
              (key, value) => MapEntry(
                key.toString(),
                value?.toString().trim() ?? '',
              ),
            ) ??
            <String, String>{};

    return StateCategoryModel(
      state: json['state'] ?? '',
      stateDisplay: (json['state_display']?.toString().trim().isNotEmpty ??
              false)
          ? json['state_display'].toString().trim()
          : (json['state'] ?? ''),
      availableCategories: List<String>.from(
        json['available_categories'] ?? [],
      ),
      availableCategoriesFullForms: categoryFullForms,
      availableHorizontalCategories: List<String>.from(
        json['available_horizontal_categories'] ?? [],
      ),
      availableHorizontalCategoriesFullForms: horizontalFullForms,
      availableCombinationKeys: List<String>.from(
        json['available_combination_keys'] ?? [],
      ),
      availableQuotas: List<String>.from(json['available_quotas'] ?? []),
    );
  }
}
