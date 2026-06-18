import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modish_store/core/secure_storage_helper.dart';
import 'package:modish_store/features/login_signup/signup/data/model/signUp_request_model.dart';
import 'package:modish_store/features/login_signup/signup/data/repo/signUp_repo.dart';
import 'package:modish_store/features/login_signup/signup/logic/sign_up/sign_up_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      // Save token and userId securely
      await SecureStorageHelper.saveToken(response.token);
      await SecureStorageHelper.saveUserId(response.appUserId);

      // Save non-sensitive metadata in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', response.email);
      await prefs.setString('userId', response.appUserId);
      await prefs.setString('displayName', response.displayName);

      emit(SignupSuccess(response));
    } catch (e) {
      emit(SignupFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
