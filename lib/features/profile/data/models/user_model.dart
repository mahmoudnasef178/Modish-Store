class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String? phoneNumber;
  final List<String> roles;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    this.phoneNumber,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    displayName: json['userName'], // ✅ استخدم userName دايماً
    email: json['email'],
    phoneNumber: json['phoneNumber'],
    roles: List<String>.from(json['roles']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    'email': email,
    'phoneNumber': phoneNumber,
  };
}
