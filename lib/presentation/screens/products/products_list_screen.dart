import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';
import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/presentation/providers/product_providers.dart';
import 'package:product_catalog_application/presentation/providers/product_search_provider.dart';
import 'package:product_catalog_application/presentation/providers/products_list_provider.dart';
import 'package:product_catalog_application/presentation/routing/app_router.dart';
import 'package:product_catalog_application/presentation/widgets/empty_view.dart';
import 'package:product_catalog_application/presentation/widgets/error_view.dart';
import 'package:product_catalog_application/presentation/widgets/loading_view.dart';
import 'package:product_catalog_application/presentation/widgets/product_card.dart';
import 'package:product_catalog_application/presentation/widgets/product_search_bar.dart';

class ProductsListScreen extends ConsumerWidget {
  const ProductsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.productsTitle),
      ),
      body: productsState.when(
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
    final products = filterProductsBySearch(
      products: allProducts,
      query: query,
      searchUseCase: searchUseCase,
    );
    final isSearching = query.trim().isNotEmpty;

    Future<void> onRefresh() =>
        ref.read(productsListProvider.notifier).refresh();

    if (allProducts.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(
              height: 320,
              child: EmptyView(),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty && isSearching) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(
              height: 280,
              child: EmptyView(
                message: AppStrings.noSearchResults,
                icon: Icons.search_off,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final useGrid = constraints.maxWidth >= 600;

        if (useGrid) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.4,
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
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
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
