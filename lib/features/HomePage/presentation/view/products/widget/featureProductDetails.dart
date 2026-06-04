import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/core/utils.dart';
import 'package:graduation_project/features/HomePage/data/models/products/products_model.dart';
import 'package:graduation_project/features/HomePage/logic/Favorite_Cubit/favorite_cubit.dart';
import 'package:graduation_project/features/HomePage/logic/Favorite_Cubit/favorite_state.dart';
import 'package:graduation_project/features/HomePage/presentation/view/products/widget/product_color.dart';
import 'package:graduation_project/features/HomePage/presentation/view/products/widget/product_price.dart';
import 'package:graduation_project/features/HomePage/presentation/view/products/widget/row_payment.dart';

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
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(26),
                  child: product.pictureUrl.startsWith('http')
                      ? Image.network(
                          product.pictureUrl,
                          fit: BoxFit.fill,
                          height: context.height * .5,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey[200]),
                        )
                      : Image.asset(
                          product.pictureUrl,
                          fit: BoxFit.fill,
                          height: context.height * .5,
                          width: double.infinity,
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
                      // ✅ بنقرأ من الـ state مش من context.read
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
                      style: t12.copyWith(color: secondaryColorText),
                    ),
                  ),
                  Gap(18),
                  ProductColor(),
                  Gap(18),
                  Align(
                    alignment: AlignmentGeometry.centerStart,
                    child: Text(
                      "Description",
                      style: t14.copyWith(
                        color: primaryColorText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Gap(12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      product.description.isNotEmpty
                          ? product.description
                          : "No description available.",
                      style: t14.copyWith(
                        color: secondaryColorText,
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
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(64),
      ),
      child: Center(child: SvgPicture.asset("assets/icons/Arrow.svg")),
    );
  }

  Widget _customFavoriteContainer(bool isSelected) {
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(64),
      ),
      child: Center(
        child: isSelected
            ? SvgPicture.asset(
                "assets/icons/isSelectedFavorite.svg",
                height: 22,
              )
            : SvgPicture.asset("assets/icons/drawer_icon/Path.svg", height: 22),
      ),
    );
  }
}
