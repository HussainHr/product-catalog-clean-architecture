import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/constants/api_constants.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/features/products/domain/repositories/product_repository.dart';
import 'package:product_catalog_application/features/products/presentation/providers/product_providers.dart';
import 'package:product_catalog_application/features/products/presentation/providers/products_list_state.dart';

class ProductsListNotifier extends StateNotifier<ProductsListState> {
  ProductsListNotifier(this._repository) : super(const ProductsListState());

  final ProductRepository _repository;

  Future<void> load({bool refresh = false}) async {
    final current = state;
    if (current.isLoading || current.isLoadingMore) {
      return;
    }
    if (!refresh && !current.hasMore && current.products.isNotEmpty) {
      return;
    }

    final isFirstPage = refresh || current.products.isEmpty;
    state = current.copyWith(
      isLoading: isFirstPage,
      isLoadingMore: !isFirstPage,
      clearFailure: true,
    );

    final offset = refresh ? 0 : state.products.length;
    final result = await _repository.getProductsPage(
      limit: ApiConstants.defaultPageSize,
      offset: offset,
    );

    switch (result) {
      case Success(:final value):
        final products = refresh
            ? value.products
            : [...state.products, ...value.products];
        state = ProductsListState(
          products: products,
          hasMore: value.hasMore,
        );
      case ErrorResult(:final failure):
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          failure: failure,
        );
    }
  }

  Future<void> refresh() => load(refresh: true);

  Future<void> retry() {
    if (state.products.isEmpty) {
      return load(refresh: true);
    }
    return load();
  }
}

final productsListProvider =
    StateNotifierProvider<ProductsListNotifier, ProductsListState>((ref) {
  return ProductsListNotifier(ref.watch(productRepositoryProvider));
});
