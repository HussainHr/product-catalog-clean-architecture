import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/storage/shared_preferences_provider.dart';
import 'package:product_catalog_application/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:product_catalog_application/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:product_catalog_application/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:product_catalog_application/features/favorites/domain/usecases/get_favorite_ids.dart';
import 'package:product_catalog_application/features/favorites/domain/usecases/toggle_favorite.dart';

final favoritesLocalDataSourceProvider =
    Provider<FavoritesLocalDataSource>((ref) {
  return FavoritesLocalDataSourceImpl(ref.watch(sharedPreferencesProvider));
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(ref.watch(favoritesLocalDataSourceProvider));
});

final getFavoriteIdsProvider = Provider<GetFavoriteIds>((ref) {
  return GetFavoriteIds(ref.watch(favoritesRepositoryProvider));
});

final toggleFavoriteProvider = Provider<ToggleFavorite>((ref) {
  return ToggleFavorite(ref.watch(favoritesRepositoryProvider));
});
