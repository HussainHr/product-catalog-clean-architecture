import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/domain/repositories/favorites_repository.dart';

class IsFavorite {
  const IsFavorite(this._repository);

  final FavoritesRepository _repository;

  Future<Result<bool>> call(int productId) {
    return _repository.isFavorite(productId);
  }
}
