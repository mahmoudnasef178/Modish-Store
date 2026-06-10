import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/core/secure_storage_helper.dart';
import 'package:graduation_project/features/HomePage/data/models/Favorite/favorite_model.dart';

class FavoriteRepository {
  final Dio _dio;
  FavoriteRepository(this._dio);
  static const String _baseUrl =
      'https://gradutionapi-production.up.railway.app/api/v1/Favorite';

  Future<String?> _getToken() async {
    return SecureStorageHelper.getToken();
  }

  Future<String?> _getUserId() async {
    return SecureStorageHelper.getUserId();
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
        queryParameters: {'userId': userId},
        options: await _authOptions(),
      );
      debugPrint('GET FAVORITES RESPONSE: ${response.data}');
      return FavoriteResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('GET FAVORITES ERROR: ${e.response?.statusCode}');
      debugPrint('GET FAVORITES ERROR DATA: ${e.response?.data}');
      throw Exception('Failed to load favorites');
    }
  }

  Future<void> addToFavorite(String productId) async {
    try {
      final userId = await _getUserId();
      debugPrint('ADD FAVORITE REQUEST: user=$userId, productId=$productId');
      final response = await _dio.post(
        '$_baseUrl/AddItems',
        data: {'user': userId, 'productId': productId},
        options: await _authOptions(),
      );
      debugPrint('ADD FAVORITE RESPONSE: ${response.data}');
    } on DioException catch (e) {
      debugPrint('ADD FAVORITE ERROR STATUS: ${e.response?.statusCode}');
      debugPrint('ADD FAVORITE ERROR DATA: ${e.response?.data}');
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
