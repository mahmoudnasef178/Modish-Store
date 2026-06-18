import 'package:modish_store/features/Cart/data/models/cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartModel cart;
  CartLoaded(this.cart);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}

class CartItemAdded extends CartState {
  final CartModel cart;
  CartItemAdded(this.cart);
}
