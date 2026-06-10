import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/features/HomePage/data/repo/products/products_repo.dart';
import 'package:graduation_project/features/HomePage/logic/products/products_cubit.dart';
import 'package:graduation_project/features/HomePage/logic/products/products_state.dart';
import 'package:graduation_project/features/HomePage/presentation/view/products/widget/featureProductDetails.dart';

class RecommendedPage extends StatelessWidget {
  const RecommendedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit(GetIt.I<ProductRepository>())..getRecommended(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Builder(
              builder: (context) {
                return Icon(
                  Icons.arrow_back_ios,
                  color: kPrimaryText(context),
                );
              }
            ),
          ),
          title: Builder(
            builder: (context) {
              return Text(
                "Recommended",
                style: t18.copyWith(
                  color: kPrimaryText(context),
                  fontWeight: FontWeight.w700,
                ),
              );
            }
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
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
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProductCubit>().getRecommended(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            } else if (state is ProductSuccess) {
              final products = state.products;
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Featureproductdetails(product: product),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kCardColor(context),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Hero(
                              tag: 'product-image-${product.productId}',
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: product.pictureUrl.startsWith('http')
                                    ? CachedNetworkImage(
                                        imageUrl: product.pictureUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        placeholder: (_, __) => Container(
                                          color: Colors.grey[200],
                                          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                        ),
                                        errorWidget:
                                            (_, _, _) =>
                                                Container(
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
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: t14.copyWith(
                                    color: kPrimaryText(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.categoryName,
                                  style: t12.copyWith(
                                    color: kSecondaryText(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$ ${product.price}',
                                      style: t14.copyWith(
                                        color: kPrimaryText(context),
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          product.rate.toString(),
                                          style: t12.copyWith(
                                            color: kSecondaryText(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
