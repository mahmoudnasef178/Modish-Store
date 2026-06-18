import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';
import 'package:modish_store/features/Cart/data/models/cart_model.dart';
import 'package:modish_store/features/Cart/logic/cart_cubit/cart_cubit.dart';
import 'package:modish_store/features/HomePage/data/models/products/products_model.dart';
import 'package:modish_store/features/HomePage/presentation/view/products/widget/feature_product_details.dart';

class CartItem extends StatelessWidget {
  final CartItemModel item;
  const CartItem({super.key, required this.item});

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
            Hero(
              tag: 'product-image-${item.productId}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.productImage.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: item.productImage,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          width: 100,
                          height: 100,
                          color: Theme.of(context).cardColor,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (_, _, _) => Container(
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
                      QtyButton(
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
                      QtyButton(
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

class QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const QtyButton({super.key, required this.icon, required this.onTap});

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
