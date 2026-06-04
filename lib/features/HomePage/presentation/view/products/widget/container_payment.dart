import 'package:flutter/material.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/core/utils.dart';
import 'package:graduation_project/features/Cart/data/models/cart_model.dart';
import 'package:graduation_project/features/Cart/presentation/view/checkout_page.dart';
import 'package:graduation_project/features/HomePage/data/models/products/products_model.dart';

class ContainerPayment extends StatelessWidget {
  const ContainerPayment({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final cart = CartModel(
          userId: '',
          cartItems: [
            CartItemModel(
              productId: product.productId,
              productName: product.name,
              productImage: product.pictureUrl,
              quantity: 1,
              price: product.price,
            ),
          ],
          totalPrice: product.price,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CheckoutPage(cart: cart)),
        );
      },
      child: Container(
        width: context.width * .7,
        height: 62,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          color: kPrimaryColor,
        ),
        child: Center(
          child: Text(
            "Buy Now",
            style: t18.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
