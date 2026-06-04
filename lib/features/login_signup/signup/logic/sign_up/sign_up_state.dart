import 'package:graduation_project/features/login_signup/signup/data/model/signUp_response_model.dart';

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final SignupResponseModel response;
  SignupSuccess(this.response);
}

class SignupFailure extends SignupState {
  final String errorMessage;
  SignupFailure(this.errorMessage);
}

class SignupPasswordVisibilityChanged extends SignupState {
  final bool isPasswordVisible;
  SignupPasswordVisibilityChanged(this.isPasswordVisible);
}
