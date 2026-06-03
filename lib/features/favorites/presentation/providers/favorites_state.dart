class FavoritesState {
  const FavoritesState({
    this.ids = const {},
    this.isLoading = false,
  });

  final Set<int> ids;
  final bool isLoading;

  FavoritesState copyWith({
    Set<int>? ids,
    bool? isLoading,
  }) {
    return FavoritesState(
      ids: ids ?? this.ids,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
