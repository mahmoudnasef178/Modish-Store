import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modish_store/features/Cart/data/repo/order_repo.dart';
import 'package:modish_store/features/Cart/data/repo/cart_repo.dart';
import 'package:modish_store/features/Cart/data/models/cart_model.dart';
import 'package:modish_store/features/HomePage/data/models/notification/notification_model.dart';
import 'package:modish_store/core/services/notification_storage_service.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final OrderRepository _orderRepo;
  final CartRepository _cartRepo;

  CheckoutCubit(this._orderRepo, this._cartRepo) : super(CheckoutInitial());

  Future<void> placeOrder({
    required CartModel cart,
    required String address,
    required String city,
    required String zip,
    required String phone,
  }) async {
    emit(CheckoutLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId') ?? '';
      final userEmail = prefs.getString('email') ?? '';
      final displayName = prefs.getString('displayName') ?? 'Customer';

      final orderItems = cart.cartItems
          .map((item) => {'product': item.productId, 'quantity': item.quantity})
          .toList();

      // Place order via API
      final orderData = await _orderRepo.placeOrder(
        address: address,
        city: city,
        zip: zip,
        phone: phone,
        country: 'Egypt',
        userId: userId,
        displayName: displayName,
        orderItems: orderItems,
      );

      final orderId = orderData['id'] ?? orderData['_id'] ?? '';

      // Save notification locally
      try {
        final newNotification = NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Order Placed Successfully',
          message: 'Your order #$orderId has been placed successfully!',
          timestamp: DateTime.now(),
          orderId: orderId,
          totalPrice: cart.totalPrice + 40.90, // including shipping fee
          shippingAddress: '$address, $city, Egypt',
          items: cart.cartItems
              .map((item) => NotificationOrderItem(
                    productName: item.productName,
                    quantity: item.quantity,
                    price: item.price,
                    productImage: item.productImage,
                  ))
              .toList(),
        );
        await NotificationStorageService.addNotification(newNotification);
      } catch (e) {
        debugPrint('⚠️ Saving notification failed: $e');
      }

      // Send email verification
      final itemsText = cart.cartItems
          .map((item) => '${item.productName} x${item.quantity} = \$${item.totalPrice.toStringAsFixed(2)}')
          .join('\n');

      try {
        await _orderRepo.sendOrderEmail(
          userEmail: userEmail,
          orderId: orderId,
          itemsText: itemsText,
          totalPrice: cart.totalPrice,
        );
      } catch (e) {
        // Log email error, but do not fail checkout flow for the user since the order was placed
        debugPrint('📧 Email send failed: $e');
      }

      // Clear local/remote cart
      try {
        await _cartRepo.clearCart();
      } catch (e) {
        debugPrint('⚠️ Cart clear failed but order was placed: $e');
      }

      emit(CheckoutSuccess(orderId));
    } catch (e) {
      emit(CheckoutError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
