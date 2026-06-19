import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:modish_store/core/utils.dart';
import 'package:modish_store/features/HomePage/data/repo/products/products_repo.dart';
import 'package:modish_store/features/HomePage/logic/products/products_cubit.dart';
import 'package:modish_store/features/HomePage/logic/products/products_state.dart';
import 'package:modish_store/features/HomePage/presentation/view/home/widgets/recommendation_item.dart';

class RecommendationListview extends StatelessWidget {
  const RecommendationListview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit(GetIt.I<ProductRepository>())..getRecommended(),
      child: SizedBox(
        height: 90,
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductSuccess) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  return RecommedationItem(product: state.products[index]);
                },
              );
            } else if (state is ProductFailure) {
              return Center(child: Text(state.errorMessage));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
