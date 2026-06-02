import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/domain/repositories/favorites_repository.dart';

class GetFavoriteIds {
  const GetFavoriteIds(this._repository);

  final FavoritesRepository _repository;

  Future<Result<Set<int>>> call() {
    return _repository.getFavoriteIds();
  }
}
