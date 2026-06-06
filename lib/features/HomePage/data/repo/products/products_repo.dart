import 'package:dio/dio.dart';
import 'package:graduation_project/features/HomePage/data/models/products/products_model.dart';

class ProductRepository {
  final Dio _dio = Dio();

  static const String _baseUrl =
      'https://gradutionapi-production.up.railway.app/api/v1';

  Future<ProductsResponseModel> getProducts({
    String? categoryId,
    String? search,
  }) async {
    try {
      final response = await _dio.get('$_baseUrl/products');
      final List allProducts = response.data as List;

      final filtered = allProducts.where((p) {
        final category = p['category'];

        final productCategoryId = category?['id'] ?? category?['_id'] ?? '';

        final matchesCategory =
            categoryId == null ||
            categoryId.isEmpty ||
            productCategoryId.toString().toLowerCase() ==
                categoryId.toLowerCase();

        final matchesSearch =
            search == null ||
            p['name'].toString().toLowerCase().contains(search.toLowerCase());

        return matchesCategory && matchesSearch;
      }).toList();

      return ProductsResponseModel.fromJson(filtered);
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to load products';
      throw Exception(message);
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/products/$id');
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to load product';
      throw Exception(message);
    }
  }

  Future<List<ProductModel>> getRecommended() async {
    try {
      final response = await _dio.get('$_baseUrl/products');
      final List allProducts = response.data as List;

      final sorted = allProducts.where((p) => p['rating'] != null).toList()
        ..sort((a, b) => (b['rating'] as num).compareTo(a['rating'] as num));

      return sorted.take(5).map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Failed to load recommendations';
      throw Exception(message);
    }
  }
}
