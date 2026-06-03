import 'package:flutter/material.dart';
import 'package:product_catalog_application/core/theme/app_spacing.dart';
import 'package:product_catalog_application/core/utils/responsive_layout.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/presentation/routing/app_router.dart';
import 'package:product_catalog_application/presentation/widgets/empty_view.dart';
import 'package:product_catalog_application/presentation/widgets/product_card.dart';

class ProductsListContent extends StatelessWidget {
  const ProductsListContent({
    super.key,
    required this.products,
    required this.onRefresh,
    this.emptyMessage,
    this.emptyIcon,
  });

  final List<Product> products;
  final Future<void> Function() onRefresh;
  final String? emptyMessage;
  final IconData? emptyIcon;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return ResponsiveScrollableEmpty(
        onRefresh: onRefresh,
        child: EmptyView(
          message: emptyMessage ?? EmptyView.defaultMessage,
          icon: emptyIcon ?? EmptyView.defaultIcon,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = ResponsiveLayout.gridColumnCount(
          constraints.maxWidth,
        );
        final padding = responsiveScreenPadding(constraints.maxWidth);

        if (columnCount == 1) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: padding,
              itemCount: products.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.listItemGap),
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () => openProductDetail(context, product),
                );
              },
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: padding,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              mainAxisSpacing: AppSpacing.listItemGap,
              crossAxisSpacing: AppSpacing.listItemGap,
              childAspectRatio: columnCount >= 3 ? 2.1 : 2.3,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () => openProductDetail(context, product),
              );
            },
          ),
        );
      },
    );
  }
}
