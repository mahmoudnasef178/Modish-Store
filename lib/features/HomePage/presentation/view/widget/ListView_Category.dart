import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/utils.dart';
import 'package:graduation_project/features/HomePage/data/repo/category/category_repo.dart';
import 'package:graduation_project/features/HomePage/logic/category/category_cubit.dart';
import 'package:graduation_project/features/HomePage/logic/category/category_state.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/category_item.dart';

class ListviewCategory extends StatelessWidget {
  const ListviewCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit(CategoryRepository())..getCategories(),
      child: SizedBox(
        height: context.height * .15,
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
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                separatorBuilder: (_, _) => const SizedBox(width: 28),
                itemCount: state.categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CategoryItem(category: state.categories[index]);
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
