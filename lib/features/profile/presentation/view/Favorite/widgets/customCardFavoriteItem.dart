import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/colors.dart';
import 'package:graduation_project/features/HomePage/data/models/Favorite/favorite_model.dart';
import 'package:graduation_project/features/HomePage/data/models/products/products_model.dart';
import 'package:graduation_project/features/HomePage/logic/Favorite_Cubit/favorite_cubit.dart';
import 'package:graduation_project/features/HomePage/presentation/view/products/widget/featureProductDetails.dart';

class CustomCardFavoriteItem extends StatelessWidget {
  const CustomCardFavoriteItem({super.key, required this.item});
  final FavoriteItemModel item;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.shortestSide * 0.24;
    final titleFontSize = size.shortestSide * 0.04;
    final subFontSize = size.shortestSide * 0.033;
    final btnSize = size.shortestSide * 0.11;
    final iconSize = btnSize * 0.5;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Featureproductdetails(
              product: ProductModel.dummy(
                productId: item.id,
                name: item.productName,
                pictureUrl: item.pictureUrl,
                price: item.price,
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.012),
        child: Row(
          children: [
            Hero(
              tag: 'product-image-${item.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.pictureUrl.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: item.pictureUrl,
                        height: imageSize,
                        width: imageSize,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          height: imageSize,
                          width: imageSize,
                          color: Colors.grey[200],
                        ),
                        errorWidget: (_, _, _) => Container(
                          height: imageSize,
                          width: imageSize,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: imageSize * 0.4,
                          ),
                        ),
                      )
                    : Image.asset(
                        item.pictureUrl,
                        height: imageSize,
                        width: imageSize,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(width: size.width * 0.04),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w600,
                      color: primaryColorText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: size.height * 0.008),
                  Text(
                    item.category,
                    style: TextStyle(
                      fontSize: subFontSize,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  SizedBox(height: size.height * 0.008),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () =>
                  context.read<FavoriteCubit>().toggleFavoriteById(item.id),
              child: Container(
                height: btnSize,
                width: btnSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red.shade900),
                  color: Colors.white,
                ),
                child: Icon(Icons.favorite, color: Colors.red, size: iconSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
