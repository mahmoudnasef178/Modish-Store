import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/core/utils.dart';
import 'package:graduation_project/features/HomePage/data/models/category/category_model.dart';
import 'package:graduation_project/features/HomePage/presentation/view/products/products_page.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.category});
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsPage(
              categoryId: category.id,
              categoryName: category.name,
            ),
          ),
        );
      },
      child: SizedBox(
        height: context.height * .1,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: kPrimaryColor),
                borderRadius: BorderRadius.circular(64),
                color: Color(int.parse(category.color.replaceAll('#', '0xFF'))),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Text(category.icon, style: const TextStyle(fontSize: 24)),
            ),
            const Gap(16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120, minWidth: 80),
              child: Text(
                category.name,
                softWrap: true,
                maxLines: 2,
                style: t12.copyWith(color: secondaryColorText),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
