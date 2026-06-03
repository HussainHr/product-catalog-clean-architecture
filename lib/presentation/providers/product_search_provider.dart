import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/domain/usecases/search_products_by_title.dart';

final productSearchQueryProvider = StateProvider<String>((ref) => '');

List<Product> filterProductsBySearch({
  required List<Product> products,
  required String query,
  required SearchProductsByTitle searchUseCase,
}) {
  return searchUseCase(products: products, query: query);
}
