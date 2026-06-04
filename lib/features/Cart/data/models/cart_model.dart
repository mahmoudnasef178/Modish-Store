class CartItemModel {
  final String productId;
  final String productName;
  final String productImage;
  int quantity;
  final double price;

  CartItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'];

    // لو product جه كـ String (ID بس) مش Object
    if (product is String) {
      return CartItemModel(
        productId: product,
        productName: '',
        productImage: '',
        quantity: json['quantity'] ?? 1,
        price: (json['price'] ?? 0).toDouble(),
      );
    }

    return CartItemModel(
      productId: product?['_id'] ?? product?['id'] ?? '',
      productName: product?['name'] ?? '',
      productImage: product?['image'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  double get totalPrice => price * quantity;
}

class CartModel {
  final String userId;
  final List<CartItemModel> cartItems;
  final double totalPrice;

  CartModel({
    required this.userId,
    required this.cartItems,
    required this.totalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      userId: json['user'] ?? '',
      cartItems: (json['cartItems'] as List? ?? [])
          .map((e) => CartItemModel.fromJson(e))
          .toList(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }

  factory CartModel.empty(String userId) {
    return CartModel(userId: userId, cartItems: [], totalPrice: 0);
  }
}
