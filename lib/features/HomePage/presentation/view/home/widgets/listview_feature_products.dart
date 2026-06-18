import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:modish_store/features/HomePage/data/repo/products/products_repo.dart';
import 'package:modish_store/features/HomePage/logic/products/products_cubit.dart';
import 'package:modish_store/features/HomePage/logic/products/products_state.dart';
import 'package:modish_store/features/HomePage/presentation/view/products/widget/feature_products_item.dart';

class ListviewFeatureProducts extends StatelessWidget {
  const ListviewFeatureProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit(GetIt.I<ProductRepository>())..getProducts(),
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const SizedBox(
              height: 280,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProductFailure) {
            return SizedBox(
              height: 280,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProductCubit>().getProducts(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ProductSuccess) {
            return SizedBox(
              height: 280,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  return FeatureProductsItem(product: state.products[index]);
                },
              ),
            );
          }
          return const SizedBox(height: 280);
        },
      ),
    );
  }
}
