import 'package:flutter/material.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/core/theme/app_spacing.dart';
import 'package:product_catalog_application/core/utils/responsive_layout.dart';
import 'package:product_catalog_application/presentation/routing/app_router.dart';
import 'package:product_catalog_application/presentation/widgets/empty_view.dart';
import 'package:product_catalog_application/presentation/widgets/product_card.dart';

class ProductsListContent extends StatelessWidget {
  const ProductsListContent({
    super.key,
    required this.products,
    required this.onRefresh,
    required this.onLoadMore,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.emptyMessage,
    this.emptyIcon,
  });

  final List<Product> products;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  final bool isLoadingMore;
  final bool hasMore;
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
        final itemCount = products.length + (hasMore ? 1 : 0);

        if (columnCount == 1) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: padding,
              itemCount: itemCount,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.listItemGap),
              itemBuilder: (context, index) {
                return _buildItem(context, index, columnCount);
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
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return _buildItem(context, index, columnCount);
            },
          ),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, int index, int columnCount) {
    if (index >= products.length) {
      return _PaginationFooter(
        isLoadingMore: isLoadingMore,
        onLoadMore: onLoadMore,
        isGrid: columnCount > 1,
      );
    }

    if (index == products.length - 1 && hasMore && !isLoadingMore) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onLoadMore());
    }

    final product = products[index];
    return ProductCard(
      product: product,
      onTap: () => openProductDetail(context, product),
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.isGrid,
  });

  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    if (!isLoadingMore) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onLoadMore());
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: isGrid ? AppSpacing.sm : 0,
      ),
      child: Center(
        child: isLoadingMore
            ? const SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Text(
                AppStrings.loadingMoreProducts,
                style: Theme.of(context).textTheme.bodySmall,
              ),
      ),
    );
  }
}
