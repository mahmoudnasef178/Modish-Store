import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/features/HomePage/data/models/category/category_model.dart';
import 'package:graduation_project/features/HomePage/data/repo/category/category_repo.dart';
import 'package:graduation_project/features/HomePage/logic/category/category_cubit.dart';
import 'package:graduation_project/features/HomePage/logic/category/category_state.dart';
import 'package:graduation_project/features/HomePage/presentation/view/products/products_page.dart';
import 'package:graduation_project/features/HomePage/presentation/view/widget/custom_AppBar.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit(CategoryRepository())..getCategories(),
      child: const _CategoryView(),
    );
  }
}

class _CategoryView extends StatelessWidget {
  const _CategoryView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide > 600;
    final crossAxisCount = isTablet ? 3 : 2;
    final horizontalPadding = size.width * 0.06;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
            child: CustomAppbar(
              leftIcon: "assets/icons/Arrow.svg",
              title: "Category",
              rightIcon: "",
              showIcon: false,
              leftIconOnTap: () => Navigator.pop(context),
            ),
          ),
          SizedBox(height: size.height * 0.04),
          Expanded(
            child: BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CategoryFailure) {
                  return Center(
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
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: size.shortestSide * 0.04,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: size.height * 0.02),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<CategoryCubit>().getCategories(),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                } else if (state is CategorySuccess) {
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    itemCount: state.categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount, // ✅ dynamic
                      mainAxisSpacing: size.height * 0.015,
                      crossAxisSpacing: size.width * 0.03,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) =>
                        _CategoryItem(category: state.categories[index]),
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

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category});
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleSize = size.shortestSide * 0.16;
    final emojiSize = circleSize * 0.45;
    final nameFontSize = size.shortestSide * 0.035;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductsPage(
              categoryId: category.id,
              categoryName: category.name,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, // ✅ dark mode
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.025,
          horizontal: size.width * 0.04,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: circleSize,
              width: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(int.parse(category.color.replaceAll('#', '0xFF'))),
              ),
              child: Center(
                child: Text(
                  category.icon,
                  style: TextStyle(fontSize: emojiSize),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.012),
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: nameFontSize,
                fontWeight: FontWeight.w600,
                color: primaryColorText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
