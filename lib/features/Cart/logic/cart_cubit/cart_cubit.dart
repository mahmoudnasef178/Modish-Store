import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modish_store/features/Cart/data/models/cart_model.dart';
import 'package:modish_store/features/Cart/data/repo/cart_repo.dart';
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
    // Optimistically update the UI before the API call
    final currentCart = _currentCart;
    if (currentCart == null) return;

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

    // Fire-and-forget the backend call; UI is already updated
    try {
      await _repo.removeFromCart(productId);
    } catch (_) {}
  }

  Future<void> updateQuantity({
    required String productId,
    required int quantity,
  }) async {
    // Optimistically update the UI before the API call
    final currentCart = _currentCart;
    if (currentCart == null) return;

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

    // Fire-and-forget the backend call; UI is already updated
    try {
      await _repo.updateQuantity(productId: productId, quantity: quantity);
    } catch (_) {}
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

  /// Returns the active [CartModel] from either [CartLoaded] or [CartItemAdded].
  CartModel? get _currentCart => switch (state) {
        CartLoaded() => (state as CartLoaded).cart,
        CartItemAdded() => (state as CartItemAdded).cart,
        _ => null,
      };
}
