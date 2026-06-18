import 'package:dio/dio.dart';
import 'package:modish_store/features/login_signup/signup/data/model/signUp_request_model.dart';
import 'package:modish_store/features/login_signup/signup/data/model/signUp_response_model.dart';

class SignupRepository {
  final Dio _dio;
  SignupRepository(this._dio);

  static const String _url =
      'http://ecommercetest2.runasp.net/api/Account/Register';

  Future<SignupResponseModel> register(SignupRequestModel request) async {
    try {
      final response = await _dio.post(
        _url,
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return SignupResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ??
          e.response?.data['title'] ??
          'Registration failed';
      throw Exception(message);
    }
  }
}
