class SignupRequestModel {
  final String email;
  final String userName;
  final String password;
  final String confirmPassword;

  SignupRequestModel({
    required this.email,
    required this.userName,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'userName': userName,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
