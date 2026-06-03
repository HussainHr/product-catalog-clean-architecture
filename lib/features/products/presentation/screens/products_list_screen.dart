import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';
import 'package:product_catalog_application/core/theme/app_theme.dart';
import 'package:product_catalog_application/core/utils/responsive_layout.dart';
import 'package:product_catalog_application/core/widgets/error_view.dart';
import 'package:product_catalog_application/core/widgets/loading_view.dart';
import 'package:product_catalog_application/features/favorites/presentation/providers/favorites_notifier.dart';
import 'package:product_catalog_application/features/products/domain/usecases/search_products_by_title.dart';
import 'package:product_catalog_application/features/products/presentation/providers/product_providers.dart';
import 'package:product_catalog_application/features/products/presentation/providers/products_list_notifier.dart';
import 'package:product_catalog_application/features/products/presentation/providers/products_list_state.dart';
import 'package:product_catalog_application/features/products/presentation/providers/search_query_provider.dart';
import 'package:product_catalog_application/features/products/presentation/widgets/product_search_bar.dart';
import 'package:product_catalog_application/features/products/presentation/widgets/products_list_content.dart';
import 'package:product_catalog_application/features/theme/presentation/widgets/theme_mode_toggle_button.dart';

class ProductsListScreen extends ConsumerStatefulWidget {
  const ProductsListScreen({super.key});

  @override
  ConsumerState<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends ConsumerState<ProductsListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(productsListProvider.notifier).load(refresh: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(productsListProvider);
    final showFavoritesOnly = ref.watch(showFavoritesOnlyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.productsTitle),
        actions: [
          const ThemeModeToggleButton(),
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
        child: _buildBody(listState),
      ),
    );
  }

  Widget _buildBody(ProductsListState listState) {
    if (listState.isInitialLoading) {
      return const LoadingView(message: AppStrings.loadingProducts);
    }

    if (listState.hasError && listState.products.isEmpty) {
      return ErrorView(
        message: listState.failure!.message,
        onRetry: () => ref.read(productsListProvider.notifier).retry(),
      );
    }

    return Column(
      children: [
        const ProductSearchBar(),
        if (listState.hasError && listState.products.isNotEmpty)
          _InlineErrorBanner(
            message: listState.failure!.message,
            onRetry: () => ref.read(productsListProvider.notifier).retry(),
          ),
        Expanded(
          child: _ProductsBody(listState: listState),
        ),
      ],
    );
  }
}

class _InlineErrorBanner extends StatelessWidget {
  const _InlineErrorBanner({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      content: Text(message),
      leading: const Icon(Icons.error_outline),
      actions: [
        TextButton(
          onPressed: onRetry,
          child: const Text(AppStrings.retry),
        ),
      ],
    );
  }
}

class _ProductsBody extends ConsumerWidget {
  const _ProductsBody({required this.listState});

  final ProductsListState listState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(productSearchQueryProvider);
    final searchUseCase = ref.read(searchProductsByTitleProvider);
    final showFavoritesOnly = ref.watch(showFavoritesOnlyProvider);
    final favoriteIds = ref.watch(favoritesProvider).ids;

    final searchedProducts = filterProductsBySearch(
      products: listState.products,
      query: query,
      searchUseCase: searchUseCase,
    );
    final products = showFavoritesOnly
        ? searchedProducts.where((p) => favoriteIds.contains(p.id)).toList()
        : searchedProducts;

    final isSearching = query.trim().isNotEmpty;
    final canPaginate = !isSearching && !showFavoritesOnly;

    Future<void> onRefresh() =>
        ref.read(productsListProvider.notifier).refresh();

    void onLoadMore() {
      if (canPaginate) {
        ref.read(productsListProvider.notifier).load();
      }
    }

    if (listState.showEmptyState) {
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
      onLoadMore: canPaginate ? onLoadMore : null,
      isLoadingMore: canPaginate && listState.isLoadingMore,
      hasMore: canPaginate && listState.hasMore,
    );
  }
}
