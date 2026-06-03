import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/presentation/providers/product_providers.dart';

class ProductsListNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    return _loadProducts();
  }

  /// Pull-to-refresh: keeps current list visible while reloading.
  Future<void> refresh() async {
    state = await AsyncValue.guard(_loadProducts);
  }

  /// Full-screen reload (e.g. retry from error state).
  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadProducts);
  }

  Future<List<Product>> _loadProducts() async {
    final result = await ref.read(getProductsProvider)();

    switch (result) {
      case Success(:final value):
        return value;
      case ErrorResult(:final failure):
        throw failure;
    }
  }
}

final productsListProvider =
    AsyncNotifierProvider<ProductsListNotifier, List<Product>>(
  ProductsListNotifier.new,
);
