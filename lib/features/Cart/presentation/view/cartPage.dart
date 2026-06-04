import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/features/Cart/data/models/cart_model.dart';
import 'package:graduation_project/features/Cart/data/repo/cart_repo.dart';
import 'package:graduation_project/features/Cart/logic/cart_cubit/cart_cubit.dart';
import 'package:graduation_project/features/Cart/logic/cart_cubit/cart_state.dart';
import 'package:graduation_project/features/HomePage/data/models/products/products_model.dart';
import 'package:graduation_project/features/HomePage/logic/Navigation_Cubit/navigation_cubit.dart';
import 'package:graduation_project/features/HomePage/presentation/view/products/widget/featureProductDetails.dart';

import 'package:graduation_project/features/HomePage/presentation/view/widget/custom_AppBar.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(CartRepository())..getCart(),
      child: const _CartView(),
    );
  }
}

class _CartView extends StatelessWidget {
  const _CartView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: CustomAppbar(
              leftIcon: "assets/icons/Arrow.svg",
              title: "Cart",
              rightIcon: "",
              showIcon: false,
              leftIconOnTap: () =>
                  context.read<NavigationCubit>().changeIndex(0),
            ),
          ),
          Expanded(
            child: BlocConsumer<CartCubit, CartState>(
              listener: (context, state) {
                if (state is CartError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is CartLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final cart = state is CartLoaded
                    ? state.cart
                    : state is CartItemAdded
                    ? state.cart
                    : null;

                if (cart == null) return const SizedBox.shrink();

                if (cart.cartItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          color: secondaryColorText,
                        ),
                        const Gap(16),
                        Text(
                          'Your cart is empty',
                          style: t18.copyWith(color: secondaryColorText),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    const Gap(16),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: cart.cartItems.length,
                        separatorBuilder: (_, __) => const Gap(12),
                        itemBuilder: (context, index) {
                          return _CartItem(item: cart.cartItems[index]);
                        },
                      ),
                    ),
                    _BottomSummary(cart: cart),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final CartItemModel item;
  const _CartItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final product = ProductModel.dummy(
          productId: item.productId,
          name: item.productName,
          pictureUrl: item.productImage,
          price: item.price,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Featureproductdetails(product: product),
          ),
        );
      },
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.productImage.startsWith('http')
                  ? Image.network(
                      item.productImage,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 100,
                        height: 100,
                        color: Theme.of(context).cardColor,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: Theme.of(context).cardColor,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
            ),
            const Gap(18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.productName,
                    style: t14.copyWith(
                      color: primaryColorText,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: t14.copyWith(color: secondaryColorText),
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      _QtyButton(
                        icon: Icons.remove,
                        onTap: () {
                          if (item.quantity > 1) {
                            context.read<CartCubit>().updateQuantity(
                              productId: item.productId,
                              quantity: item.quantity - 1,
                            );
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.quantity}',
                          style: t14.copyWith(
                            color: primaryColorText,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _QtyButton(
                        icon: Icons.add,
                        onTap: () => context.read<CartCubit>().updateQuantity(
                          productId: item.productId,
                          quantity: item.quantity + 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () =>
                  context.read<CartCubit>().removeFromCart(item.productId),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.asset("assets/icons/Icon.svg"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}

class _BottomSummary extends StatelessWidget {
  final CartModel cart;
  const _BottomSummary({required this.cart});

  static const double shippingFee = 40.90;

  @override
  Widget build(BuildContext context) {
    final total = cart.totalPrice + shippingFee;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Subtotal',
            value: '\$${cart.totalPrice.toStringAsFixed(2)}',
          ),
          const Gap(8),
          _SummaryRow(
            label: 'Shipping',
            value: '\$${shippingFee.toStringAsFixed(2)}',
          ),
          const Gap(12),
          const Divider(height: 1, color: Color(0xffEEEEEE)),
          const Gap(12),
          _SummaryRow(
            label: 'Total Cost',
            value: '\$${total.toStringAsFixed(2)}',
            isBold: true,
          ),
          const Gap(20),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CheckoutPage(cart: cart)),
            ),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: kPrimaryColor,
              ),
              child: Center(
                child: Text(
                  'Checkout',
                  style: t18.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: t14.copyWith(
            color: isBold ? primaryColorText : secondaryColorText,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: t14.copyWith(
            color: primaryColorText,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
