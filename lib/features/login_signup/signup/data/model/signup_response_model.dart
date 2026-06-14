class SignupResponseModel {
  final String displayName;
  final String email;
  final String token;
  final String appUserId;
  final String role;

  SignupResponseModel({
    required this.displayName,
    required this.email,
    required this.token,
    required this.appUserId,
    required this.role,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      displayName: json['displayName'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      appUserId: json['appUserId'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
