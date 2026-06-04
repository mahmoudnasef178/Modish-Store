import 'package:dio/dio.dart';
import 'package:graduation_project/features/HomePage/data/models/Favorite/favorite_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRepository {
  final Dio _dio = Dio();
  static const String _baseUrl =
      'https://gradutionapi-production.up.railway.app/api/v1/Favorite';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // ✅ لازم تخزن الـ userId وقت الـ login
  }

  Future<Options> _authOptions() async {
    final token = await _getToken();
    return Options(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<FavoriteResponseModel> getFavorites() async {
    try {
      final userId = await _getUserId();
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {'userId': userId}, // ✅ بعت الـ userId كـ query
        options: await _authOptions(),
      );
      print('GET FAVORITES RESPONSE: ${response.data}');
      return FavoriteResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      print('GET FAVORITES ERROR: ${e.response?.statusCode}');
      print('GET FAVORITES ERROR DATA: ${e.response?.data}');
      throw Exception('Failed to load favorites');
    }
  }

  Future<void> addToFavorite(String productId) async {
    try {
      final userId = await _getUserId();
      print('ADD FAVORITE REQUEST: user=$userId, productId=$productId');
      final response = await _dio.post(
        '$_baseUrl/AddItems',
        data: {'user': userId, 'productId': productId},
        options: await _authOptions(),
      );
      print('ADD FAVORITE RESPONSE: ${response.data}');
    } on DioException catch (e) {
      print('ADD FAVORITE ERROR STATUS: ${e.response?.statusCode}');
      print('ADD FAVORITE ERROR DATA: ${e.response?.data}');
      final message =
          e.response?.data['message'] ??
          e.response?.data['title'] ??
          'Failed to add to favorites';
      throw Exception(message);
    }
  }

  Future<void> removeFromFavorite(String productId) async {
    try {
      final userId = await _getUserId();
      // ✅ DELETE /Favorite/items/:productId بـ { userId } في الـ body
      await _dio.delete(
        '$_baseUrl/items/$productId',
        data: {'userId': userId},
        options: await _authOptions(),
      );
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ??
          e.response?.data['title'] ??
          'Failed to remove from favorites';
      throw Exception(message);
    }
  }
}
