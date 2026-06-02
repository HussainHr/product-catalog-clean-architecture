import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/domain/repositories/favorites_repository.dart';

class ToggleFavorite {
  const ToggleFavorite(this._repository);

  final FavoritesRepository _repository;

  Future<Result<void>> call(int productId) {
    return _repository.toggleFavorite(productId);
  }
}
