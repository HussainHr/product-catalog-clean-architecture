import 'package:product_catalog_application/core/error/exceptions.dart';
import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/data/datasources/favorites_local_data_source.dart';
import 'package:product_catalog_application/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl(this._localDataSource);

  final FavoritesLocalDataSource _localDataSource;

  @override
  Future<Result<Set<int>>> getFavoriteIds() async {
    try {
      final ids = await _localDataSource.getFavoriteIds();
      return Success(ids);
    } on CacheException catch (error) {
      return ErrorResult(CacheFailure(error.message));
    } catch (_) {
      return const ErrorResult(CacheFailure());
    }
  }

  @override
  Future<Result<bool>> isFavorite(int productId) async {
    final idsResult = await getFavoriteIds();
    return switch (idsResult) {
      Success(:final value) => Success(value.contains(productId)),
      ErrorResult(:final failure) => ErrorResult<bool>(failure),
    };
  }

  @override
  Future<Result<void>> toggleFavorite(int productId) async {
    try {
      final ids = await _localDataSource.getFavoriteIds();
      final updated = Set<int>.from(ids);
      if (updated.contains(productId)) {
        updated.remove(productId);
      } else {
        updated.add(productId);
      }
      await _localDataSource.saveFavoriteIds(updated);
      return const Success(null);
    } on CacheException catch (error) {
      return ErrorResult(CacheFailure(error.message));
    } catch (_) {
      return const ErrorResult(CacheFailure());
    }
  }
}
