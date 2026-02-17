class FavouriteCollege {
  final int id;
  final String name;
  final String website;
  final int yearEstablished;
  final bool hostelAvailable;
  final String hostelFor;

  FavouriteCollege({
    required this.id,
    required this.name,
    required this.website,
    required this.yearEstablished,
    required this.hostelAvailable,
    required this.hostelFor,
  });

  factory FavouriteCollege.fromJson(Map<String, dynamic> json) {
    return FavouriteCollege(
      id: json['id'],
      name: json['college_name'] ?? '',
      website: json['college_website'] ?? '',
      yearEstablished: json['year_established'] ?? 0,
      hostelAvailable: json['hostel_available'] ?? false,
      hostelFor: json['hostel_for'] ?? '',
    );
  }
}
