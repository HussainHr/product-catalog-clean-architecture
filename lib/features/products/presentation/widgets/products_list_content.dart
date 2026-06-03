import 'package:flutter/material.dart';
import 'package:product_catalog_application/core/theme/app_spacing.dart';
import 'package:product_catalog_application/core/utils/responsive_layout.dart';
import 'package:product_catalog_application/core/widgets/empty_view.dart';
import 'package:product_catalog_application/core/routing/app_router.dart';
import 'package:product_catalog_application/features/products/domain/entities/product.dart';
import 'package:product_catalog_application/features/products/presentation/widgets/product_card.dart';

class ProductsListContent extends StatelessWidget {
  const ProductsListContent({
    super.key,
    required this.products,
    required this.onRefresh,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.emptyMessage,
    this.emptyIcon,
  });

  final List<Product> products;
  final Future<void> Function() onRefresh;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final bool hasMore;
  final String? emptyMessage;
  final IconData? emptyIcon;

  static const _loadMoreThreshold = 200.0;

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
        final showFooter = hasMore || isLoadingMore;
        final itemCount = products.length + (showFooter ? 1 : 0);

        Widget list;
        if (columnCount == 1) {
          list = ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: padding,
            itemCount: itemCount,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.listItemGap),
            itemBuilder: (context, index) => _buildItem(context, index),
          );
        } else {
          list = GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: padding,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              mainAxisSpacing: AppSpacing.listItemGap,
              crossAxisSpacing: AppSpacing.listItemGap,
              childAspectRatio: columnCount >= 3 ? 2.1 : 2.3,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) => _buildItem(context, index),
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (onLoadMore == null || isLoadingMore || !hasMore) {
                return false;
              }
              final metrics = notification.metrics;
              if (metrics.pixels >= metrics.maxScrollExtent - _loadMoreThreshold) {
                onLoadMore!();
              }
              return false;
            },
            child: list,
          ),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index >= products.length) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Center(
          child: SizedBox(
            height: 28,
            width: 28,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      );
    }

    final product = products[index];
    return ProductCard(
      product: product,
      onTap: () => openProductDetail(context, product),
    );
  }
}
