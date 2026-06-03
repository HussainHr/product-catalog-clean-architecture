import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/features/favorites/domain/usecases/get_favorite_ids.dart';
import 'package:product_catalog_application/features/favorites/domain/usecases/toggle_favorite.dart';
import 'package:product_catalog_application/features/favorites/presentation/providers/favorites_providers.dart';
import 'package:product_catalog_application/features/favorites/presentation/providers/favorites_state.dart';
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  FavoritesNotifier(this._getFavoriteIds, this._toggleFavorite)
      : super(const FavoritesState(isLoading: true)) {
    _load();
  }

  final GetFavoriteIds _getFavoriteIds;
  final ToggleFavorite _toggleFavorite;

  Future<void> _load() async {
    final result = await _getFavoriteIds();
    state = FavoritesState(
      ids: switch (result) {
        Success(:final value) => value,
        ErrorResult() => {},
      },
    );
  }

  Future<void> toggle(int productId) async {
    final result = await _toggleFavorite(productId);
    if (result case ErrorResult()) {
      return;
    }

    final ids = Set<int>.from(state.ids);
    if (ids.contains(productId)) {
      ids.remove(productId);
    } else {
      ids.add(productId);
    }
    state = state.copyWith(ids: ids);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  return FavoritesNotifier(
    ref.watch(getFavoriteIdsProvider),
    ref.watch(toggleFavoriteProvider),
  );
});

final showFavoritesOnlyProvider = StateProvider<bool>((ref) => false);

final isFavoriteProvider = Provider.family<bool, int>((ref, productId) {
  return ref.watch(favoritesProvider).ids.contains(productId);
});
