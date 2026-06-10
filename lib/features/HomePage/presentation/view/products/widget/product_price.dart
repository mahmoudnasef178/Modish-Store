import 'package:flutter/material.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/features/HomePage/data/models/products/products_model.dart';

class ProductPrice extends StatelessWidget {
  const ProductPrice({super.key, required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          product.name,
          style: t20.copyWith(
            color: kPrimaryText(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        Text(
          "\$ ${product.price}",
          style: t20.copyWith(
            color: kPrimaryText(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
