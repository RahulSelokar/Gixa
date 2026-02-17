class User {
  final int id;
  final String username;
  final String email;
  final String mobileNumber;
  final String firstName;
  final String lastName;
  final String fullName;
  final String profilePictureUrl;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.mobileNumber,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.profilePictureUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      mobileNumber: json['mobile_number'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fullName: json['full_name'],
      profilePictureUrl: json['profile_picture_url'] ?? '',
    );
  }
}
