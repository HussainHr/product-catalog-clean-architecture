import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/domain/entities/paginated_products.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/domain/repositories/product_repository.dart';
import 'package:product_catalog_application/domain/usecases/get_products.dart';

class _FakeProductRepository implements ProductRepository {
  _FakeProductRepository(this._result);

  final Result<List<Product>> _result;

  @override
  Future<Result<List<Product>>> getProducts() async => _result;

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

void main() {
  const sampleProduct = Product(
    id: 1,
    title: 'Backpack',
    price: 109.95,
    description: 'Description',
    category: 'bags',
    imageUrl: 'https://example.com/image.png',
    rating: 4.2,
    ratingCount: 50,
  );

  test('returns products when repository succeeds', () async {
    final useCase = GetProducts(
      _FakeProductRepository(const Success([sampleProduct])),
    );

    final result = await useCase();

    expect(result, isA<Success<List<Product>>>());
    expect((result as Success<List<Product>>).value, [sampleProduct]);
  });

  test('returns failure when repository fails', () async {
    final useCase = GetProducts(
      _FakeProductRepository(
        ErrorResult(ServerFailure()),
      ),
    );

    final result = await useCase();

    expect(result, isA<ErrorResult<List<Product>>>());
  });
}
