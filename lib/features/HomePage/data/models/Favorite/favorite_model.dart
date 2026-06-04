class FavoriteItemModel {
  final String id;
  final String productName;
  final String pictureUrl;
  final double price;
  final String category;

  FavoriteItemModel({
    required this.id,
    required this.productName,
    required this.pictureUrl,
    required this.price,
    required this.category,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    return FavoriteItemModel(
      id: json['id'] ?? '',
      productName: json['productName'] ?? '',
      pictureUrl: json['pictureUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
    );
  }
}

class FavoriteResponseModel {
  final String userId;
  final List<FavoriteItemModel> favoriteItems;

  FavoriteResponseModel({required this.userId, required this.favoriteItems});

  factory FavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    return FavoriteResponseModel(
      userId: json['user'] ?? '',
      favoriteItems: (json['favoriteItems'] as List<dynamic>? ?? [])
          .map((e) => FavoriteItemModel.fromJson(e))
          .toList(),
    );
  }
}
