import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';
import 'package:product_catalog_application/core/theme/app_spacing.dart';
import 'package:product_catalog_application/core/utils/price_formatter.dart';
import 'package:product_catalog_application/core/utils/responsive_layout.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/presentation/widgets/favorite_button.dart';
import 'package:product_catalog_application/presentation/widgets/product_image.dart';
import 'package:product_catalog_application/presentation/widgets/product_rating.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.productDetailsTitle),
        actions: [
          FavoriteButton(productId: product.id),
        ],
      ),
      body: ResponsiveContent(
        maxWidth: 720,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return ProductImage(
                    imageUrl: product.imageUrl,
                    width: constraints.maxWidth,
                    height: 240,
                    fit: BoxFit.contain,
                    borderRadius: 12,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                product.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                PriceFormatter.format(product.price),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _DetailChip(
                    label: AppStrings.categoryLabel,
                    value: product.category,
                  ),
                  ProductRating(rating: product.rating),
                  Text(
                    '(${product.ratingCount} ${AppStrings.reviewsLabel})',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                AppStrings.descriptionLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                product.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        Icons.category_outlined,
        size: 18,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: Text('$label: $value'),
    );
  }
}
