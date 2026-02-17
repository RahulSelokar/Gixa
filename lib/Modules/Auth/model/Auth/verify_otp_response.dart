class VerifyOtpResponse {
  final String message;
  final bool isRegistered;
  final String? nextStep;
  final String? accessToken;
  final String? refreshToken;

  final String? errorCode;
  final Student? student;

  VerifyOtpResponse({
    required this.message,
    required this.isRegistered,
    this.nextStep,
    this.accessToken,
    this.refreshToken,
    this.errorCode,
    this.student,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      message: json['message'] ?? '',
      isRegistered: json['is_registered'] ?? false,
      nextStep: json['next_step'],

      // ✅ FIX: READ FROM token OBJECT
      accessToken: json['token']?['access'],
      refreshToken: json['token']?['refresh'],

      errorCode: json['error_code'],
      student: json['student'] != null
          ? Student.fromJson(json['student'])
          : null,
    );
  }
  bool get isSuccess => accessToken != null;
  bool get isAlreadyLoggedInOtherDevice =>
      errorCode == 'ALREADY_LOGGED_IN_OTHER_DEVICE';
}

class Student {
  final int id;
  final String mobileNumber;
  final String firstName;
  final String lastName;
  final String? email;
  final bool isProfileCompleted;

  Student({
    required this.id,
    required this.mobileNumber,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.isProfileCompleted,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      mobileNumber: json['mobile_number'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'],
      isProfileCompleted: json['is_profile_completed'] ?? false,
    );
  }
}
