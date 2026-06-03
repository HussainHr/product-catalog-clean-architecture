import 'package:product_catalog_application/core/error/exceptions.dart';
import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/data/datasources/product_remote_data_source.dart';
import 'package:product_catalog_application/domain/entities/paginated_products.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._remoteDataSource);

  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<Product>>> getProducts() async {
    try {
      final models = await _remoteDataSource.getProducts();
      return Success(models.map((model) => model.toEntity()).toList());
    } on NetworkException catch (error) {
      return ErrorResult(NetworkFailure(error.message));
    } on ServerException catch (error) {
      return ErrorResult(ServerFailure(error.message));
    } catch (_) {
      return const ErrorResult(ServerFailure());
    }
  }

  @override
  Future<Result<PaginatedProducts>> getProductsPage({
    required int limit,
    required int offset,
  }) async {
    try {
      final models = await _remoteDataSource.getProductsPage(
        limit: limit,
        offset: offset,
      );
      final products = models.map((model) => model.toEntity()).toList();
      return Success(
        PaginatedProducts(
          products: products,
          hasMore: products.length >= limit,
        ),
      );
    } on NetworkException catch (error) {
      return ErrorResult(NetworkFailure(error.message));
    } on ServerException catch (error) {
      return ErrorResult(ServerFailure(error.message));
    } catch (_) {
      return const ErrorResult(ServerFailure());
    }
  }

  @override
  Future<Result<Product>> getProductById(int id) async {
    try {
      final model = await _remoteDataSource.getProductById(id);
      return Success(model.toEntity());
    } on NetworkException catch (error) {
      return ErrorResult(NetworkFailure(error.message));
    } on NotFoundException catch (error) {
      return ErrorResult(NotFoundFailure(error.message));
    } on ServerException catch (error) {
      return ErrorResult(ServerFailure(error.message));
    } catch (_) {
      return const ErrorResult(ServerFailure());
    }
  }
}
