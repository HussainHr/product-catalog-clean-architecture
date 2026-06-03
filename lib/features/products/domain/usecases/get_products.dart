import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/features/products/domain/entities/product.dart';
import 'package:product_catalog_application/features/products/domain/repositories/product_repository.dart';

class GetProducts {
  const GetProducts(this._repository);

  final ProductRepository _repository;

  Future<Result<List<Product>>> call() {
    return _repository.getProducts();
  }
}
