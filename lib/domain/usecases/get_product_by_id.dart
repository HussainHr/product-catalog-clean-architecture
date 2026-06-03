import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/domain/repositories/product_repository.dart';

class GetProductById {
  const GetProductById(this._repository);

  final ProductRepository _repository;

  Future<Result<Product>> call(int id) {
    return _repository.getProductById(id);
  }
}
