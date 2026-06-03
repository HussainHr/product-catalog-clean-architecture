import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';
import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/core/theme/app_theme.dart';
import 'package:product_catalog_application/core/utils/responsive_layout.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/presentation/providers/favorites_providers.dart';
import 'package:product_catalog_application/presentation/providers/product_providers.dart';
import 'package:product_catalog_application/presentation/providers/product_search_provider.dart';
import 'package:product_catalog_application/presentation/providers/products_list_provider.dart';
import 'package:product_catalog_application/presentation/widgets/error_view.dart';
import 'package:product_catalog_application/presentation/widgets/loading_view.dart';
import 'package:product_catalog_application/presentation/widgets/product_search_bar.dart';
import 'package:product_catalog_application/presentation/widgets/products_list_content.dart';

class ProductsListScreen extends ConsumerWidget {
  const ProductsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsListProvider);
    final showFavoritesOnly = ref.watch(showFavoritesOnlyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.productsTitle),
        actions: [
          IconButton(
            key: const Key('favorites_filter_button'),
            icon: Icon(
              showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
              color: showFavoritesOnly ? AppTheme.favoriteColor : null,
            ),
            tooltip: showFavoritesOnly
                ? AppStrings.showAllProducts
                : AppStrings.showFavoritesOnly,
            onPressed: () {
              ref.read(showFavoritesOnlyProvider.notifier).state =
                  !showFavoritesOnly;
            },
          ),
        ],
      ),
      body: ResponsiveContent(
        child: productsState.when(
          loading: () => const LoadingView(message: AppStrings.loadingProducts),
          error: (error, _) => ErrorView(
            message: _errorMessage(error),
            onRetry: () => ref.read(productsListProvider.notifier).retry(),
          ),
          data: (products) => Column(
            children: [
              const ProductSearchBar(),
              Expanded(
                child: _ProductsBody(allProducts: products),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _errorMessage(Object error) {
    if (error is Failure) {
      return error.message;
    }
    return AppStrings.genericError;
  }
}

class _ProductsBody extends ConsumerWidget {
  const _ProductsBody({required this.allProducts});

  final List<Product> allProducts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(productSearchQueryProvider);
    final searchUseCase = ref.read(searchProductsByTitleProvider);
    final showFavoritesOnly = ref.watch(showFavoritesOnlyProvider);
    final favoriteIds = ref.watch(favoritesProvider).valueOrNull ?? {};

    final searchedProducts = filterProductsBySearch(
      products: allProducts,
      query: query,
      searchUseCase: searchUseCase,
    );
    final products = showFavoritesOnly
        ? searchedProducts.where((p) => favoriteIds.contains(p.id)).toList()
        : searchedProducts;

    final isSearching = query.trim().isNotEmpty;

    Future<void> onRefresh() =>
        ref.read(productsListProvider.notifier).refresh();

    if (allProducts.isEmpty) {
      return ProductsListContent(
        products: const [],
        onRefresh: onRefresh,
      );
    }

    if (products.isEmpty && showFavoritesOnly) {
      return ProductsListContent(
        products: const [],
        onRefresh: onRefresh,
        emptyMessage: AppStrings.noFavoritesFound,
        emptyIcon: Icons.favorite_border,
      );
    }

    if (products.isEmpty && isSearching) {
      return ProductsListContent(
        products: const [],
        onRefresh: onRefresh,
        emptyMessage: AppStrings.noSearchResults,
        emptyIcon: Icons.search_off,
      );
    }

    return ProductsListContent(
      products: products,
      onRefresh: onRefresh,
    );
  }
}
