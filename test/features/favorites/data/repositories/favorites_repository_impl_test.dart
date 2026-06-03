import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:product_catalog_application/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences preferences;
  late FavoritesRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    repository = FavoritesRepositoryImpl(
      FavoritesLocalDataSourceImpl(preferences),
    );
  });

  test('toggleFavorite adds and removes product id', () async {
    final addResult = await repository.toggleFavorite(1);
    expect(addResult, isA<Success<void>>());

    final idsAfterAdd = await repository.getFavoriteIds();
    expect((idsAfterAdd as Success<Set<int>>).value, {1});

    final removeResult = await repository.toggleFavorite(1);
    expect(removeResult, isA<Success<void>>());

    final idsAfterRemove = await repository.getFavoriteIds();
    expect((idsAfterRemove as Success<Set<int>>).value, isEmpty);
  });

  test('favorites persist across repository instances', () async {
    await repository.toggleFavorite(42);

    final anotherRepository = FavoritesRepositoryImpl(
      FavoritesLocalDataSourceImpl(preferences),
    );

    final result = await anotherRepository.getFavoriteIds();
    expect((result as Success<Set<int>>).value, {42});
  });

  test('isFavorite returns correct status', () async {
    await repository.toggleFavorite(7);

    final result = await repository.isFavorite(7);
    expect((result as Success<bool>).value, isTrue);
  });
}
