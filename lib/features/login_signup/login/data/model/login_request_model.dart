class LoginRequestModel {
  final String emailOrUserName;
  final String password;

  LoginRequestModel({required this.emailOrUserName, required this.password});

  Map<String, dynamic> toJson() {
    return {'emailOrUserName': emailOrUserName, 'password': password};
  }
}
