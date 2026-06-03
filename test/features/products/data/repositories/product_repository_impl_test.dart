import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/error/exceptions.dart';
import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/features/products/data/datasources/product_remote_data_source.dart';
import 'package:product_catalog_application/features/products/data/models/product_model.dart';
import 'package:product_catalog_application/features/products/data/repositories/product_repository_impl.dart';
import 'package:product_catalog_application/features/products/domain/entities/paginated_products.dart';
import 'package:product_catalog_application/features/products/domain/entities/product.dart';

void main() {
  const model = ProductModel(
    id: 1,
    title: 'Test',
    price: 10,
    description: 'Desc',
    category: 'cat',
    image: 'https://example.com/image.png',
    rating: 4,
    ratingCount: 1,
  );

  test('getProducts returns Success with entities', () async {
    final repository = ProductRepositoryImpl(
      _FakeRemoteDataSource(products: [model]),
    );

    final result = await repository.getProducts();

    expect(result, isA<Success<List<Product>>>());
    expect((result as Success).value, hasLength(1));
  });

  test('getProductsPage returns Success with hasMore flag', () async {
    final repository = ProductRepositoryImpl(
      _FakeRemoteDataSource(products: [model, model]),
    );

    final result = await repository.getProductsPage(limit: 2, offset: 0);

    expect(result, isA<Success<PaginatedProducts>>());
    final page = (result as Success<PaginatedProducts>).value;
    expect(page.products, hasLength(2));
    expect(page.hasMore, isTrue);
  });

  test('getProductById maps NotFoundException to NotFoundFailure', () async {
    final repository = ProductRepositoryImpl(
      _FakeRemoteDataSource(notFound: true),
    );

    final result = await repository.getProductById(99);

    expect(result, isA<ErrorResult<Product>>());
    expect((result as ErrorResult).failure, isA<NotFoundFailure>());
  });

  test('getProductsPage maps NetworkException to NetworkFailure', () async {
    final repository = ProductRepositoryImpl(
      _FakeRemoteDataSource(networkError: true),
    );

    final result = await repository.getProductsPage(limit: 10, offset: 0);

    expect(result, isA<ErrorResult<PaginatedProducts>>());
    expect((result as ErrorResult).failure, isA<NetworkFailure>());
  });
}

class _FakeRemoteDataSource implements ProductRemoteDataSource {
  _FakeRemoteDataSource({
    this.products,
    this.notFound = false,
    this.networkError = false,
  });

  final List<ProductModel>? products;
  final bool notFound;
  final bool networkError;

  @override
  Future<List<ProductModel>> getProducts() async {
    if (networkError) {
      throw NetworkException();
    }
    return products ?? [];
  }

  @override
  Future<List<ProductModel>> getProductsPage({
    required int limit,
    required int offset,
  }) async {
    if (networkError) {
      throw NetworkException();
    }
    return products ?? [];
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    if (notFound) {
      throw NotFoundException();
    }
    return products!.first;
  }
}
