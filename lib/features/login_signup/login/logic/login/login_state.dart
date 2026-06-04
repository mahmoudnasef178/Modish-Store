import 'package:graduation_project/features/login_signup/login/data/model/login_response_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponseModel response;
  LoginSuccess(this.response);
}

class LoginFailure extends LoginState {
  final String errorMessage;
  LoginFailure(this.errorMessage);
}

class LoginPasswordVisibilityChanged extends LoginState {
  final bool isPasswordVisible;
  LoginPasswordVisibilityChanged(this.isPasswordVisible);
}
