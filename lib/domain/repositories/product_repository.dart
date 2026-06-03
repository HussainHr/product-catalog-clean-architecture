import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/domain/entities/paginated_products.dart';
import 'package:product_catalog_application/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> getProducts();

  Future<Result<PaginatedProducts>> getProductsPage({
    required int limit,
    required int offset,
  });

  Future<Result<Product>> getProductById(int id);
}
