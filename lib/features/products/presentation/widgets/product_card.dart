import 'package:flutter/material.dart';
import 'package:product_catalog_application/core/theme/app_spacing.dart';
import 'package:product_catalog_application/core/utils/price_formatter.dart';
import 'package:product_catalog_application/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:product_catalog_application/features/products/domain/entities/product.dart';
import 'package:product_catalog_application/features/products/presentation/widgets/product_image.dart';
import 'package:product_catalog_application/features/products/presentation/widgets/product_rating.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${product.title}, ${PriceFormatter.format(product.price)}',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductImage(imageUrl: product.imageUrl),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        PriceFormatter.format(product.price),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      ProductRating(rating: product.rating),
                    ],
                  ),
                ),
                FavoriteButton(productId: product.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
