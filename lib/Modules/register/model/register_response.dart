class RegisterStudentResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  RegisterStudentResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory RegisterStudentResponse.fromJson(Map<String, dynamic> json) {
    return RegisterStudentResponse(
      accessToken: json['token']['access'].toString(),
      refreshToken: json['token']['refresh'].toString(),
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String username;
  final String email;
  final String mobileNumber;
  final String firstName;
  final String lastName;
  final String profilePictureUrl;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.mobileNumber,
    required this.firstName,
    required this.lastName,
    required this.profilePictureUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'].toString(),        // ✅ FIX
      email: json['email'] ?? '',
      mobileNumber: json['mobile_number'].toString(), // ✅ FIX
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      profilePictureUrl: json['profile_picture']?.toString() ?? '',
    );
  }
}
