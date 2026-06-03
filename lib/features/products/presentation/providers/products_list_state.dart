import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/features/products/domain/entities/product.dart';

class ProductsListState {
  const ProductsListState({
    this.products = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.failure,
  });

  final List<Product> products;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final Failure? failure;

  bool get isInitialLoading => isLoading && products.isEmpty;

  bool get hasError => failure != null;

  bool get showEmptyState => products.isEmpty && !isLoading && !hasError;

  ProductsListState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return ProductsListState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
