import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> getProducts();

  Future<Result<Product>> getProductById(int id);
}
