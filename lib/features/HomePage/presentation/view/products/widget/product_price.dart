import 'package:flutter/material.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';
import 'package:modish_store/features/HomePage/data/models/products/products_model.dart';

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
