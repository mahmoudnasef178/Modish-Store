import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';
import 'package:modish_store/core/utils.dart';
import 'package:modish_store/features/HomePage/data/models/products/products_model.dart';
import 'package:modish_store/features/HomePage/logic/Favorite_Cubit/favorite_cubit.dart';
import 'package:modish_store/features/HomePage/logic/Favorite_Cubit/favorite_state.dart';
import 'package:modish_store/features/HomePage/presentation/view/products/widget/product_color.dart';
import 'package:modish_store/features/HomePage/presentation/view/products/widget/product_price.dart';
import 'package:modish_store/features/HomePage/presentation/view/products/widget/row_payment.dart';

class Featureproductdetails extends StatelessWidget {
  const Featureproductdetails({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            width: double.infinity,
            child: Stack(
              children: [
                Hero(
                  tag: 'product-image-${product.productId}',
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(26),
                    child: product.pictureUrl.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: product.pictureUrl,
                            fit: BoxFit.fill,
                            height: context.height * .5,
                            width: double.infinity,
                            placeholder: (_, _) => Container(color: Colors.grey[200]),
                            errorWidget: (context, error, stackTrace) =>
                                Container(color: Colors.grey[200]),
                          )
                        : Image.asset(
                            product.pictureUrl,
                            fit: BoxFit.fill,
                            height: context.height * .5,
                            width: double.infinity,
                          ),
                  ),
                ),
                Positioned(
                  left: context.height * .04,
                  top: context.height * .06,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: _customArrowContainer(),
                  ),
                ),
                Positioned(
                  right: context.height * .04,
                  top: context.height * .06,
                  child: BlocBuilder<FavoriteCubit, FavoriteState>(
                    builder: (context, state) {
                      final isSelected = state is FavoriteSuccess
                          ? state.items.any((e) => e.id == product.productId)
                          : false;
                      return GestureDetector(
                        onTap: () => context
                            .read<FavoriteCubit>()
                            .toggleFavorite(product),
                        child: _customFavoriteContainer(isSelected),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: [
                  Gap(32),
                  ProductPrice(product: product),
                  Gap(8),
                  Align(
                    alignment: AlignmentGeometry.centerStart,
                    child: Text(
                      product.categoryName,
                      style: t12.copyWith(color: kSecondaryText(context)),
                    ),
                  ),
                  Gap(18),
                  ProductColor(productId: product.productId),
                  Gap(18),
                  Align(
                    alignment: AlignmentGeometry.centerStart,
                    child: Text(
                      "Description",
                      style: t14.copyWith(
                        color: kPrimaryText(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Gap(12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xff2A2A3E)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      product.description.isNotEmpty
                          ? product.description
                          : "No description available.",
                      style: t14.copyWith(
                        color: kSecondaryText(context),
                        height: 1.6,
                      ),
                    ),
                  ),
                  Spacer(),
                  RowPayment(product: product),
                  Gap(32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customArrowContainer() {
    return Builder(
      builder: (context) {
        return Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(64),
          ),
          child: Center(
            child: SvgPicture.asset(
              "assets/icons/Arrow.svg",
              colorFilter: ColorFilter.mode(
                  kPrimaryText(context), BlendMode.srcIn),
            ),
          ),
        );
      }
    );
  }

  Widget _customFavoriteContainer(bool isSelected) {
    return Builder(
      builder: (context) {
        return Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(64),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: Tween<double>(begin: 0.7, end: 1.0).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                  ),
                  child: child,
                );
              },
              child: isSelected
                  ? SvgPicture.asset(
                      "assets/icons/isSelectedFavorite.svg",
                      key: const ValueKey('selected'),
                      height: 22,
                    )
                  : SvgPicture.asset(
                      "assets/icons/drawer_icon/Path.svg",
                      key: const ValueKey('unselected'),
                      height: 22,
                      colorFilter: ColorFilter.mode(
                          kPrimaryText(context), BlendMode.srcIn),
                    ),
            ),
          ),
        );
      }
    );
  }
}
