import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modish_store/features/login_signup/login/data/model/login_request_model.dart';
import 'package:modish_store/features/login_signup/login/data/repo/login_repo.dart';
import 'package:modish_store/features/login_signup/login/logic/login/login_state.dart';
import 'package:modish_store/core/secure_storage_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _repository;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  LoginCubit(this._repository) : super(LoginInitial());

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(LoginPasswordVisibilityChanged(_isPasswordVisible));
  }

  Future<void> login({
    required String emailOrUserName,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      final request = LoginRequestModel(
        emailOrUserName: emailOrUserName,
        password: password,
      );
      final response = await _repository.login(request);

      // Save token and userId securely
      await SecureStorageHelper.saveToken(response.token);
      await SecureStorageHelper.saveUserId(response.appUserId);

      // Save non-sensitive metadata in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', response.email);
      await prefs.setString('userId', response.appUserId);
      await prefs.setString('displayName', response.displayName);

      emit(LoginSuccess(response));
    } catch (e) {
      emit(LoginFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  static Future<bool> isLoggedIn() async {
    final token = await SecureStorageHelper.getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    await SecureStorageHelper.clearAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('userId');
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('displayName');
  }
}
