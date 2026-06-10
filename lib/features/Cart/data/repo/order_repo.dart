import 'package:dio/dio.dart';

class OrderRepository {
  final Dio _dio;
  OrderRepository(this._dio);
  static const String _baseUrl = 'https://gradutionapi-production.up.railway.app/api/v1';

  Future<Map<String, dynamic>> placeOrder({
    required String address,
    required String city,
    required String zip,
    required String phone,
    required String country,
    required String userId,
    required String displayName,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    // Check API availability with a quick timeout (as done in the original code)
    try {
      await _dio.get(
        '$_baseUrl/products',
        options: Options(sendTimeout: const Duration(seconds: 5)),
      );
    } catch (_) {}

    try {
      final response = await _dio.post(
        '$_baseUrl/Order/BasketOrder',
        data: {
          'orderItems': orderItems,
          'shippingAddress1': address,
          'city': city,
          'zip': zip,
          'phone': phone,
          'country': country,
          'status': 'Pending',
          'user': userId,
          'firstName': displayName,
          'lastName': '',
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to place order');
    }
  }

  Future<void> sendOrderEmail({
    required String userEmail,
    required String orderId,
    required String itemsText,
    required double totalPrice,
  }) async {
    try {
      await _dio.post(
        'https://api.emailjs.com/api/v1.0/email/send',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'origin': 'http://localhost',
          },
        ),
        data: {
          'service_id': 'service_q7sw7w7',
          'template_id': 'template_j6nbley',
          'user_id': 'kBpJi2toH4-hSqrtZ',
          'accessToken': 'hDfUXKsDxYZ91etL3aIe_',
          'template_params': {
            'email': userEmail,
            'order_id': orderId,
            'items': itemsText,
            'cost_shipping': '40.90',
            'cost_total': (totalPrice + 40.9).toStringAsFixed(2),
          },
        },
      );
    } on DioException catch (e) {
      throw Exception('Failed to send confirmation email: ${e.message}');
    }
  }
}
