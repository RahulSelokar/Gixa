class RegisterStudentRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String username;
  final String mobileNumber;

  final int allIndiaRank;
  final int neetScore;

  final double tenthPercentage;
  final double twelthPercentage;
  final double twelthPcb;

  final int category;
  final int state;
  final int course;
  final int? specialty;

  final String gender;
  final String caste;
  final String nationality;
  final String dateOfBirth;
  final String address;

  final bool physicalDisability;
  final String? disabilityDetails;

  final String? deviceId;
  final String? fcmToken;

  RegisterStudentRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.mobileNumber,
    required this.allIndiaRank,
    required this.neetScore,
    required this.tenthPercentage,
    required this.twelthPercentage,
    required this.twelthPcb,
    required this.category,
    required this.state,
    required this.course,
    this.specialty,
    required this.gender,
    required this.caste,
    required this.nationality,
    required this.dateOfBirth,
    required this.address,

    /// ⭐ NEW
    required this.physicalDisability,
    this.disabilityDetails,

    this.deviceId,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": mobileNumber,
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
      "mobile_number": mobileNumber,

      "all_india_rank": allIndiaRank,
      "neet_score": neetScore,

      "tenth_percentage": tenthPercentage,
      "twelth_percentage": twelthPercentage,
      "twelth_pcb": twelthPcb,

      "category": category,
      "state": state,
      "course": course,

      if (specialty != null)
        "specialty": specialty,

      "gender": gender,
      "caste": caste,
      "nationality": nationality,
      "date_of_birth": dateOfBirth,
      "address": address,

      /// ⭐ PWD
      "physical_disability": physicalDisability,

      if (disabilityDetails != null)
        "disability_details": disabilityDetails,

      "profile_picture": "",

      if (deviceId != null && deviceId!.isNotEmpty)
        "device_id": deviceId,
      if (fcmToken != null && fcmToken!.isNotEmpty)
        "fcm_token": fcmToken,
    };
  }
}