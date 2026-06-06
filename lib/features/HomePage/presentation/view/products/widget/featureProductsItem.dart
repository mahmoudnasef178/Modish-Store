import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/features/HomePage/data/models/products/products_model.dart';

import 'package:graduation_project/features/HomePage/presentation/view/products/widget/featureProductDetails.dart';

class FeatureProductsItem extends StatelessWidget {
  const FeatureProductsItem({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Featureproductdetails(product: product),
            ),
          );
        },
        child: SizedBox(
          height: 270,
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'product-image-${product.productId}',
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(16),
                  child: product.pictureUrl.startsWith('http')
                      ? Image.network(
                          product.pictureUrl,
                          fit: BoxFit.cover,
                          height: 180,
                          width: 160,
                          errorBuilder: (_, _, _) => Container(
                            color: Colors.grey[200],
                            height: 180,
                            width: 160,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Image.asset(
                          product.pictureUrl,
                          fit: BoxFit.cover,
                          height: 180,
                          width: 160,
                        ),
                ),
              ),
              const Gap(8),
              Text(
                product.name,
                style: t14.copyWith(color: secondaryColorText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$ ${product.price}',
                    style: t14.copyWith(
                      color: primaryColorText,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        product.rate.toString(),
                        style: t12.copyWith(color: secondaryColorText),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
