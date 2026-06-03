import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/features/products/domain/entities/paginated_products.dart';
import 'package:product_catalog_application/features/products/domain/entities/product.dart';
import 'package:product_catalog_application/features/products/domain/repositories/product_repository.dart';
import 'package:product_catalog_application/features/products/domain/usecases/get_products.dart';

void main() {
  test('returns products when repository succeeds', () async {
    const products = [
      Product(
        id: 1,
        title: 'Test',
        price: 10,
        description: 'Desc',
        category: 'cat',
        imageUrl: 'https://example.com/image.png',
        rating: 4,
        ratingCount: 1,
      ),
    ];
    final useCase = GetProducts(_FakeProductRepository(products));

    final result = await useCase();

    expect(result, isA<Success<List<Product>>>());
    expect((result as Success).value, products);
  });

  test('returns failure when repository fails', () async {
    final useCase = GetProducts(_FakeProductRepository.failure());

    final result = await useCase();

    expect(result, isA<ErrorResult<List<Product>>>());
    expect((result as ErrorResult).failure, isA<ServerFailure>());
  });
}

class _FakeProductRepository implements ProductRepository {
  _FakeProductRepository(this._products) : _failure = null;

  _FakeProductRepository.failure()
      : _products = null,
        _failure = const ServerFailure('Failed');

  final List<Product>? _products;
  final Failure? _failure;

  @override
  Future<Result<List<Product>>> getProducts() async {
    final failure = _failure;
    if (failure != null) {
      return ErrorResult(failure);
    }
    return Success(_products ?? const []);
  }

  @override
  Future<Result<PaginatedProducts>> getProductsPage({
    required int limit,
    required int offset,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<Product>> getProductById(int id) async {
    throw UnimplementedError();
  }
}
