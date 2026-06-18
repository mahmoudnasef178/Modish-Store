import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';
import 'package:modish_store/features/Cart/data/repo/cart_repo.dart';
import 'package:modish_store/features/Cart/logic/cart_cubit/cart_cubit.dart';
import 'package:modish_store/features/Cart/logic/cart_cubit/cart_state.dart';
import 'package:modish_store/features/Cart/presentation/view/cart/widgets/bottom_summary.dart';
import 'package:modish_store/features/Cart/presentation/view/cart/widgets/cart_item.dart';
import 'package:modish_store/features/HomePage/logic/Navigation_Cubit/navigation_cubit.dart';
import 'package:modish_store/features/HomePage/presentation/view/widget/custom_app_bar.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(GetIt.I<CartRepository>())..getCart(),
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

                final cart = switch (state) {
                  CartLoaded() => state.cart,
                  CartItemAdded() => state.cart,
                  _ => null,
                };

                if (cart == null) return const SizedBox.shrink();

                if (cart.cartItems.isEmpty) {
                  return _EmptyCart();
                }

                return Column(
                  children: [
                    const Gap(16),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: cart.cartItems.length,
                        separatorBuilder: (_, _) => const Gap(12),
                        itemBuilder: (context, index) {
                          return CartItem(item: cart.cartItems[index]);
                        },
                      ),
                    ),
                    BottomSummary(cart: cart),
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

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
