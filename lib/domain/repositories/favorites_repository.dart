import 'package:product_catalog_application/core/error/result.dart';

abstract class FavoritesRepository {
  Future<Result<Set<int>>> getFavoriteIds();

  Future<Result<bool>> isFavorite(int productId);

  Future<Result<void>> toggleFavorite(int productId);
}
