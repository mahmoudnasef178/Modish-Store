import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/Cart/data/models/cart_model.dart';
import 'package:graduation_project/features/Cart/data/repo/cart_repo.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _repo;

  CartCubit(this._repo) : super(CartInitial());

  Future<void> getCart() async {
    if (isClosed) return;
    emit(CartLoading());
    try {
      final cart = await _repo.getCart();
      if (isClosed) return;
      emit(CartLoaded(cart));
    } catch (e) {
      if (isClosed) return;
      emit(CartError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> addToCart({
    required String productId,
    required double price,
  }) async {
    try {
      final cart = await _repo.addToCart(productId: productId, price: price);
      if (isClosed) return;
      emit(CartItemAdded(cart));
    } catch (e) {
      if (isClosed) return;
      emit(CartError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> removeFromCart(String productId) async {
    // ✅ حدث الـ UI فوراً
    final currentCart = (state is CartLoaded)
        ? (state as CartLoaded).cart
        : (state as CartItemAdded).cart;

    final updatedItems = currentCart.cartItems
        .where((item) => item.productId != productId)
        .toList();

    final newTotal = updatedItems.fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity,
    );

    if (isClosed) return;
    emit(
      CartLoaded(
        CartModel(
          userId: currentCart.userId,
          cartItems: updatedItems,
          totalPrice: newTotal,
        ),
      ),
    );

    try {
      await _repo.removeFromCart(productId);
    } catch (e) {
      // لو فشل مش مشكلة
    }
  }

  Future<void> updateQuantity({
    required String productId,
    required int quantity,
  }) async {
    // ✅ حدث الـ UI فوراً من غير ما تنتظر الـ API
    final currentCart = (state is CartLoaded)
        ? (state as CartLoaded).cart
        : (state as CartItemAdded).cart;

    final updatedItems = currentCart.cartItems.map((item) {
      if (item.productId == productId) {
        item.quantity = quantity;
      }
      return item;
    }).toList();

    final newTotal = updatedItems.fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity,
    );

    if (isClosed) return;
    emit(
      CartLoaded(
        CartModel(
          userId: currentCart.userId,
          cartItems: updatedItems,
          totalPrice: newTotal,
        ),
      ),
    );

    // ✅ كلم الـ API في الخلفية بس
    try {
      await _repo.updateQuantity(productId: productId, quantity: quantity);
    } catch (e) {
      // لو فشل مش مشكلة، الـ UI اتحدث بالفعل
    }
  }

  Future<void> clearCart() async {
    try {
      await _repo.clearCart();
      if (isClosed) return;
      emit(CartLoaded(await _repo.getCart()));
    } catch (e) {
      if (isClosed) return;
      emit(CartError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
