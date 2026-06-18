import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:modish_store/core/colors.dart';
import 'package:modish_store/core/fontstyle.dart';
import 'package:modish_store/features/HomePage/data/models/products/products_model.dart';

import 'package:modish_store/features/HomePage/presentation/view/products/widget/feature_product_details.dart';

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
                      ? CachedNetworkImage(
                          imageUrl: product.pictureUrl,
                          fit: BoxFit.cover,
                          height: 180,
                          width: 160,
                          placeholder: (_, __) => Container(
                            color: Colors.grey[200],
                            height: 180,
                            width: 160,
                            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          ),
                          errorWidget: (_, _, _) => Container(
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
                style: t14.copyWith(color: kSecondaryText(context)),
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
                      color: kPrimaryText(context),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        product.rate.toString(),
                        style: t12.copyWith(color: kSecondaryText(context)),
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
