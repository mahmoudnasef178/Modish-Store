import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/core/fontstyle.dart';
import 'package:graduation_project/features/HomePage/data/models/products/products_model.dart';
import 'package:graduation_project/features/HomePage/presentation/view/products/widget/featureProductDetails.dart';

class RecommedationItem extends StatelessWidget {
  const RecommedationItem({super.key, required this.product});
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
        child: Container(
          height: 68,
          width: 240,
          decoration: BoxDecoration(
            color: kCardColor(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Hero(
                tag: 'product-image-${product.productId}',
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(8),
                  child: product.pictureUrl.startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: product.pictureUrl,
                          height: 68,
                          width: 68,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: Colors.grey[200],
                            height: 68,
                            width: 68,
                          ),
                          errorWidget: (_, _, _) => Container(
                            color: Colors.grey[200],
                            height: 68,
                            width: 68,
                            child: const Icon(Icons.image_not_supported),
                          ),
                        )
                      : Image.asset(
                          product.pictureUrl,
                          height: 68,
                          width: 68,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const Gap(9),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: t16.copyWith(color: kSecondaryText(context)),
                      softWrap: true,
                      maxLines: 2,
                    ),
                    const Gap(16),
                    Text(
                      '\$ ${product.price}',
                      style: t16.copyWith(
                        color: kPrimaryText(context),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
