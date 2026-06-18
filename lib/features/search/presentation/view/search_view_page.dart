import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:modish_store/features/HomePage/data/repo/products/products_repo.dart';
import 'package:modish_store/features/HomePage/logic/Navigation_Cubit/navigation_cubit.dart';
import 'package:modish_store/features/HomePage/logic/products/products_cubit.dart';
import 'package:modish_store/features/HomePage/logic/products/products_state.dart';
import 'package:modish_store/features/HomePage/presentation/view/widget/custom_app_bar.dart';
import 'package:modish_store/features/HomePage/presentation/view/products/widget/feature_products_item.dart';
import 'package:modish_store/features/search/presentation/view/widgets/custom_search_text_field.dart';

class Searchviewpage extends StatelessWidget {
  const Searchviewpage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit(GetIt.I<ProductRepository>())..getProducts(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    context.read<ProductCubit>().getProducts(
      search: _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim(),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final crossAxisCount = size.shortestSide > 600 ? 3 : 2;
    final horizontalPadding = size.width * 0.04;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: CustomAppbar(
            leftIcon: "assets/icons/Arrow.svg",
            title: "Search",
            rightIcon: "",
            showIcon: false,
            leftIconOnTap: () => context.read<NavigationCubit>().changeIndex(0),
          ),
        ),
        Gap(size.height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Customsearchtextfield(
            hintText: "Start Searching now..",
            controller: _searchController,
          ),
        ),
        Gap(size.height * 0.02),
        Expanded(
          child: BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductFailure) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (state is ProductSuccess) {
                if (state.products.isEmpty) {
                  return const Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }
                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  itemCount: state.products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: size.height * 0.015,
                    crossAxisSpacing: size.width * 0.03,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    return FeatureProductsItem(product: state.products[index]);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
