import 'package:dio/dio.dart';
import 'package:graduation_project/features/login_signup/login/data/model/login_request_model.dart';
import 'package:graduation_project/features/login_signup/login/data/model/login_response_model.dart';

class LoginRepository {
  final Dio _dio = Dio();

  static const String _url =
      'http://ecommercetest2.runasp.net/api/Account/Login';

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _dio.post(
        _url,
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ??
          e.response?.data['title'] ??
          'Login failed';
      throw Exception(message);
    }
  }
}
