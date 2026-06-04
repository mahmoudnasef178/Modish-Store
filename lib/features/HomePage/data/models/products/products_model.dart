class ProductModel {
  final String productId;
  final String name;
  final String pictureUrl;
  final int stockQuantity;
  final double price;
  final String categoryId;
  final String categoryName;
  final double rate;
  final String description;

  ProductModel({
    required this.productId,
    required this.name,
    required this.pictureUrl,
    required this.stockQuantity,
    required this.price,
    required this.categoryId,
    required this.categoryName,
    required this.rate,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    return ProductModel(
      productId: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      pictureUrl: json['image'] ?? '',
      stockQuantity: json['countInStock'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      categoryId: category?['id'] ?? category?['_id'] ?? '',
      categoryName: category?['name'] ?? '',
      rate: (json['rating'] ?? 0).toDouble(),
      description: json['description'] ?? '',
    );
  }

  // ✅ لازم تفضل موجودة عشان الـ favorite بيستخدمها
  factory ProductModel.dummy({
    required String productId,
    required String name,
    required String pictureUrl,
    required double price,
  }) {
    return ProductModel(
      productId: productId,
      name: name,
      pictureUrl: pictureUrl,
      stockQuantity: 0,
      price: price,
      categoryId: '',
      categoryName: '',
      rate: 0,
      description: '',
    );
  }
}

class ProductsResponseModel {
  final List<ProductModel> data;

  ProductsResponseModel({required this.data});

  factory ProductsResponseModel.fromJson(List<dynamic> json) {
    return ProductsResponseModel(
      data: json.map((e) => ProductModel.fromJson(e)).toList(),
    );
  }
}
