import 'package:product_catalog_application/core/constants/storage_constants.dart';
import 'package:product_catalog_application/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FavoritesLocalDataSource {
  Future<Set<int>> getFavoriteIds();

  Future<void> saveFavoriteIds(Set<int> ids);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  FavoritesLocalDataSourceImpl(this._preferences);

  final SharedPreferences _preferences;

  @override
  Future<Set<int>> getFavoriteIds() async {
    try {
      final stored = _preferences.getStringList(
            StorageConstants.favoriteProductIdsKey,
          ) ??
          [];
      return stored.map(int.parse).toSet();
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveFavoriteIds(Set<int> ids) async {
    try {
      final saved = await _preferences.setStringList(
        StorageConstants.favoriteProductIdsKey,
        ids.map((id) => id.toString()).toList(),
      );
      if (!saved) {
        throw CacheException('Failed to save favorites');
      }
    } catch (error) {
      if (error is CacheException) {
        rethrow;
      }
      throw CacheException();
    }
  }
}
