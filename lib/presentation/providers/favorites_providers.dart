import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/data/datasources/favorites_local_data_source.dart';
import 'package:product_catalog_application/data/repositories/favorites_repository_impl.dart';
import 'package:product_catalog_application/domain/repositories/favorites_repository.dart';
import 'package:product_catalog_application/domain/usecases/get_favorite_ids.dart';
import 'package:product_catalog_application/domain/usecases/toggle_favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'SharedPreferences must be initialized in ProviderScope overrides',
  );
});

final favoritesLocalDataSourceProvider = Provider<FavoritesLocalDataSource>((ref) {
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

final showFavoritesOnlyProvider = StateProvider<bool>((ref) => false);

class FavoritesNotifier extends AsyncNotifier<Set<int>> {
  @override
  Future<Set<int>> build() async {
    final result = await ref.read(getFavoriteIdsProvider)();
    return switch (result) {
      Success(:final value) => value,
      ErrorResult() => {},
    };
  }

  Future<void> toggle(int productId) async {
    final result = await ref.read(toggleFavoriteProvider)(productId);
    if (result case ErrorResult()) {
      return;
    }

    final current = Set<int>.from(state.valueOrNull ?? {});
    if (current.contains(productId)) {
      current.remove(productId);
    } else {
      current.add(productId);
    }
    state = AsyncData(current);
  }
}

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, Set<int>>(FavoritesNotifier.new);

final isFavoriteProvider = Provider.family<bool, int>((ref, productId) {
  final favorites = ref.watch(favoritesProvider).valueOrNull ?? {};
  return favorites.contains(productId);
});
