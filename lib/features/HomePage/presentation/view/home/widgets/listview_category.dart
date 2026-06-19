import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modish_store/features/HomePage/data/repo/category/category_repo.dart';
import 'package:modish_store/features/HomePage/logic/category/category_cubit.dart';
import 'package:modish_store/features/HomePage/logic/category/category_state.dart';
import 'package:modish_store/features/HomePage/presentation/view/home/widgets/category_item.dart';

class ListviewCategory extends StatelessWidget {
  const ListviewCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit(CategoryRepository())..getCategories(),
      child: SizedBox(
        height: 115,
        child: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoryFailure) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              );
            } else if (state is CategorySuccess) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: state.categories.asMap().entries.map((entry) {
                          int idx = entry.key;
                          var category = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(
                              left: idx == 0 ? 24 : 28,
                              right: idx == state.categories.length - 1
                                  ? 24
                                  : 0,
                            ),
                            child: CategoryItem(category: category),
                          );
                        }).toList(),
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
