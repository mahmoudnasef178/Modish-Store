import 'package:dio/dio.dart';
import 'package:graduation_project/features/HomePage/data/models/category/category_model.dart';

class CategoryRepository {
  final Dio _dio = Dio();

  static const String _baseUrl =
      'https://gradutionapi-production.up.railway.app/api/v1';

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get('$_baseUrl/categories');
      final List data = response.data;
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Failed to load categories';
      throw Exception(message);
    }
  }
}
