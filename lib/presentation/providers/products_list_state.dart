import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/domain/entities/product.dart';

class ProductsListState {
  const ProductsListState({
    this.products = const [],
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.failure,
  });

  final List<Product> products;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final Failure? failure;

  bool get hasError => failure != null;

  bool get showEmptyState =>
      products.isEmpty && !isInitialLoading && !hasError;

  ProductsListState copyWith({
    List<Product>? products,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? hasMore,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return ProductsListState(
      products: products ?? this.products,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
