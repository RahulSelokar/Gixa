class UserModel {
  final String id;
  final String? phone;
  final String? name;
  final String? email;

  UserModel({
    required this.id,
    this.phone,
    this.name,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      phone: json['phone'],
      name: json['name'],
      email: json['email'],
    );
  }
}
