import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';
import 'package:modish_store/core/utils.dart';
import 'package:modish_store/features/HomePage/data/models/category/category_model.dart';
import 'package:modish_store/features/HomePage/presentation/view/products/products_page.dart';

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const Gap(8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120, minWidth: 80),
            child: Text(
              category.name,
              softWrap: true,
              maxLines: 2,
              style: t12.copyWith(color: kSecondaryText(context)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
