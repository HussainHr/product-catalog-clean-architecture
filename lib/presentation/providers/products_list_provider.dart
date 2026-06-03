import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/constants/api_constants.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/presentation/providers/product_providers.dart';
import 'package:product_catalog_application/presentation/providers/products_list_state.dart';

class ProductsListNotifier extends Notifier<ProductsListState> {
  int _offset = 0;

  @override
  ProductsListState build() {
    Future.microtask(loadFirstPage);
    return const ProductsListState(isInitialLoading: true);
  }

  Future<void> loadFirstPage() async {
    _offset = 0;
    state = const ProductsListState(
      isInitialLoading: true,
      products: [],
      hasMore: true,
    );

    await _fetchPage(append: false);
  }

  Future<void> loadNextPage() async {
    final current = state;
    if (current.isInitialLoading ||
        current.isLoadingMore ||
        !current.hasMore ||
        current.hasError) {
      return;
    }

    state = current.copyWith(isLoadingMore: true);
    await _fetchPage(append: true);
  }

  Future<void> refresh() async {
    _offset = 0;
    final currentProducts = state.products;

    state = ProductsListState(
      products: currentProducts,
      hasMore: true,
    );

    await _fetchPage(append: false);
  }

  Future<void> retry() async {
    if (state.products.isEmpty) {
      await loadFirstPage();
      return;
    }
    await loadNextPage();
  }

  Future<void> _fetchPage({required bool append}) async {
    final result = await ref.read(getProductsPageProvider)(
      limit: ApiConstants.defaultPageSize,
      offset: _offset,
    );

    switch (result) {
      case Success(:final value):
        final updatedProducts = append
            ? [...state.products, ...value.products]
            : value.products;
        _offset = updatedProducts.length;

        state = ProductsListState(
          products: updatedProducts,
          hasMore: value.hasMore,
          isInitialLoading: false,
          isLoadingMore: false,
        );
      case ErrorResult(:final failure):
        if (append && state.products.isNotEmpty) {
          state = state.copyWith(
            isLoadingMore: false,
            failure: failure,
          );
        } else {
          state = ProductsListState(failure: failure);
        }
    }
  }
}

final productsListProvider =
    NotifierProvider<ProductsListNotifier, ProductsListState>(
  ProductsListNotifier.new,
);
