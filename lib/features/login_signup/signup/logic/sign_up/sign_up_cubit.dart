import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/login_signup/signup/data/model/signUp_request_model.dart';
import 'package:graduation_project/features/login_signup/signup/data/repo/signUp_repo.dart';
import 'package:graduation_project/features/login_signup/signup/logic/sign_up/sign_up_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupRepository _repository;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  SignupCubit(this._repository) : super(SignupInitial());

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(SignupPasswordVisibilityChanged(_isPasswordVisible));
  }

  Future<void> register({
    required String email,
    required String userName,
    required String password,
    required String confirmPassword,
  }) async {
    emit(SignupLoading());
    try {
      final request = SignupRequestModel(
        email: email,
        userName: userName,
        password: password,
        confirmPassword: confirmPassword,
      );
      final response = await _repository.register(request);
      emit(SignupSuccess(response));
    } catch (e) {
      emit(SignupFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
