import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/domain/entities/paginated_products.dart';
import 'package:product_catalog_application/domain/repositories/product_repository.dart';

class GetProductsPage {
  const GetProductsPage(this._repository);

  final ProductRepository _repository;

  Future<Result<PaginatedProducts>> call({
    required int limit,
    required int offset,
  }) {
    return _repository.getProductsPage(limit: limit, offset: offset);
  }
}
