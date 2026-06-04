import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/features/HomePage/data/models/products/products_model.dart';
import 'package:graduation_project/features/HomePage/data/repo/products/products_repo.dart';
import 'package:graduation_project/features/HomePage/logic/products/products_cubit.dart';
import 'package:graduation_project/features/HomePage/logic/products/products_state.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/custom_AppBar.dart';
import 'package:graduation_project/features/HomePage/presentation/view/products/widget/featureProductDetails.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  final String categoryId;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductCubit(ProductRepository())
            ..getProducts(categoryId: categoryId),
      child: _ProductsView(categoryName: categoryName, categoryId: categoryId),
    );
  }
}

class _ProductsView extends StatelessWidget {
  const _ProductsView({required this.categoryName, required this.categoryId});
  final String categoryName;
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: CustomAppbar(
              leftIcon: "assets/icons/Arrow.svg",
              title: categoryName,
              rightIcon: "",
              showIcon: false,
              leftIconOnTap: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.errorMessage,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context
                              .read<ProductCubit>()
                              .getProducts(categoryId: categoryId),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                } else if (state is ProductSuccess) {
                  if (state.products.isEmpty) {
                    return const Center(
                      child: Text(
                        'No products found in this category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColorText,
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      return _ProductItem(product: state.products[index]);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Featureproductdetails(product: product),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: product.pictureUrl.startsWith('http')
                  ? Image.network(
                      product.pictureUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Image.asset(
                      product.pictureUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
            ),
          ),
          const Gap(8),
          Text(
            product.name,
            style: t14.copyWith(color: secondaryColorText),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$ ${product.price.toStringAsFixed(2)}',
                style: t14.copyWith(
                  color: primaryColorText,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    product.rate.toString(),
                    style: t12.copyWith(color: secondaryColorText),
                  ),
                  SizedBox(width: 12),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
