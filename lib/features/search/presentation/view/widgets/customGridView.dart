import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/HomePage/data/repo/products/products_repo.dart';
import 'package:graduation_project/features/HomePage/logic/products/products_cubit.dart';
import 'package:graduation_project/features/HomePage/logic/products/products_state.dart';
import 'package:graduation_project/features/HomePage/presentation/view/products/widget/featureProductsItem.dart';

class Customgridview extends StatelessWidget {
  final String? categoryId;
  final String? search;

  const Customgridview({super.key, this.categoryId, this.search});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // ✅ تابلت 3 كولامز، موبايل 2
    final crossAxisCount = size.shortestSide > 600 ? 3 : 2;
    final horizontalPadding = size.width * 0.04;

    return BlocProvider(
      create: (_) =>
          ProductCubit(ProductRepository())
            ..getProducts(categoryId: categoryId, search: search),
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Expanded(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ProductFailure) {
            return Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: size.shortestSide * 0.12,
                      color: Colors.red,
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: size.shortestSide * 0.035,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    ElevatedButton(
                      onPressed: () => context.read<ProductCubit>().getProducts(
                        categoryId: categoryId,
                        search: search,
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ProductSuccess) {
            final products = state.products;

            if (products.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    'No products found',
                    style: TextStyle(fontSize: size.shortestSide * 0.04),
                  ),
                ),
              );
            }

            return Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount, // ✅ dynamic
                  mainAxisSpacing: size.height * 0.015,
                  crossAxisSpacing: size.width * 0.03,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  return FeatureProductsItem(product: products[index]);
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
