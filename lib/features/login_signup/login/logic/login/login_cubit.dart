import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/login_signup/login/data/model/login_request_model.dart';
import 'package:graduation_project/features/login_signup/login/data/repo/login_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_state.dart';

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

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.token);
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', response.email);
      await prefs.setString('userId', response.appUserId);
      await prefs.setString(
        'displayName',
        response.displayName,
      ); // ✅ ضيف السطر ده

      emit(LoginSuccess(response));
    } catch (e) {
      emit(LoginFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email'); // ✅ الجديد
    await prefs.remove('userId'); // ✅ الجديد
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('displayName');
  }
}
