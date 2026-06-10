import 'package:dio/dio.dart';
import 'package:graduation_project/core/secure_storage_helper.dart';
import 'package:graduation_project/features/Cart/data/models/cart_model.dart';

class CartRepository {
  final Dio _dio;
  CartRepository(this._dio);
  static const String _baseUrl =
      'https://gradutionapi-production.up.railway.app/api/v1';

  Future<String?> _getUserId() async {
    return SecureStorageHelper.getUserId();
  }

  Future<CartModel> getCart() async {
    final userId = await _getUserId();
    if (userId == null) throw Exception('User not logged in');
    try {
      final response = await _dio.get('$_baseUrl/cart/$userId');
      return CartModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return CartModel.empty(userId);
      throw Exception('Failed to load cart');
    }
  }

  Future<CartModel> addToCart({
    required String productId,
    required double price,
  }) async {
    final userId = await _getUserId();
    if (userId == null) throw Exception('User not logged in');
    try {
      final response = await _dio.post(
        '$_baseUrl/cart/AddItems',
        data: {'user': userId, 'productId': productId, 'price': price},
      );
      return CartModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to add to cart');
    }
  }

  Future<CartModel> removeFromCart(String productId) async {
    final userId = await _getUserId();
    if (userId == null) throw Exception('User not logged in');
    try {
      final response = await _dio.delete(
        '$_baseUrl/cart/items/$productId',
        data: {'userId': userId},
      );
      return CartModel.fromJson(response.data);
    } on DioException {
      throw Exception('Failed to remove from cart');
    }
  }

  Future<CartModel> updateQuantity({
    required String productId,
    required int quantity,
  }) async {
    final userId = await _getUserId();
    if (userId == null) throw Exception('User not logged in');
    try {
      final response = await _dio.put(
        '$_baseUrl/cart/items/$productId',
        data: {'userId': userId, 'quantity': quantity},
      );
      return CartModel.fromJson(response.data);
    } on DioException {
      throw Exception('Failed to update quantity');
    }
  }

  Future<void> clearCart() async {
    final userId = await _getUserId();
    if (userId == null) throw Exception('User not logged in');
    try {
      await _dio.delete('$_baseUrl/cart/$userId');
    } on DioException {
      throw Exception('Failed to clear cart');
    }
  }
}
