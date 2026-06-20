class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String? orderId;
  final double? totalPrice;
  final String? shippingAddress;
  final List<NotificationOrderItem>? items;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.orderId,
    this.totalPrice,
    this.shippingAddress,
    this.items,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'orderId': orderId,
      'totalPrice': totalPrice,
      'shippingAddress': shippingAddress,
      'items': items?.map((item) => item.toJson()).toList(),
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      orderId: json['orderId'],
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      shippingAddress: json['shippingAddress'],
      items: json['items'] != null
          ? (json['items'] as List).map((e) => NotificationOrderItem.fromJson(e)).toList()
          : null,
      isRead: json['isRead'] ?? false,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    String? orderId,
    double? totalPrice,
    String? shippingAddress,
    List<NotificationOrderItem>? items,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      orderId: orderId ?? this.orderId,
      totalPrice: totalPrice ?? this.totalPrice,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      items: items ?? this.items,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationOrderItem {
  final String productName;
  final int quantity;
  final double price;
  final String? productImage;

  NotificationOrderItem({
    required this.productName,
    required this.quantity,
    required this.price,
    this.productImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'productImage': productImage,
    };
  }

  factory NotificationOrderItem.fromJson(Map<String, dynamic> json) {
    return NotificationOrderItem(
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      productImage: json['productImage'],
    );
  }
}
