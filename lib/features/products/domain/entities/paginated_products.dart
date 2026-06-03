import 'package:product_catalog_application/features/products/domain/entities/product.dart';

class PaginatedProducts {
  const PaginatedProducts({
    required this.products,
    required this.hasMore,
  });

  final List<Product> products;
  final bool hasMore;
}
