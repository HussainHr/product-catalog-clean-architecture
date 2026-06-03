import 'package:product_catalog_application/features/products/domain/entities/product.dart';

class SearchProductsByTitle {
  const SearchProductsByTitle();

  List<Product> call({
    required List<Product> products,
    required String query,
  }) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return products;
    }

    final lowerQuery = trimmed.toLowerCase();
    return products
        .where((product) => product.title.toLowerCase().contains(lowerQuery))
        .toList();
  }
}

List<Product> filterProductsBySearch({
  required List<Product> products,
  required String query,
  required SearchProductsByTitle searchUseCase,
}) {
  return searchUseCase(products: products, query: query);
}
