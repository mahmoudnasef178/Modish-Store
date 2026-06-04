class LoginResponseModel {
  final String displayName;
  final String email;
  final String token;
  final String appUserId;
  final String role;

  LoginResponseModel({
    required this.displayName,
    required this.email,
    required this.token,
    required this.appUserId,
    required this.role,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      displayName: json['displayName'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      appUserId: json['appUserId'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
