import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/error/exceptions.dart';
import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/data/datasources/product_remote_data_source.dart';
import 'package:product_catalog_application/data/models/product_model.dart';
import 'package:product_catalog_application/data/repositories/product_repository_impl.dart';
import 'package:product_catalog_application/domain/entities/paginated_products.dart';
import 'package:product_catalog_application/domain/entities/product.dart';

class _FakeRemoteDataSource implements ProductRemoteDataSource {
  _FakeRemoteDataSource({
    List<ProductModel>? products,
    ProductModel? product,
    Exception? productsError,
    Exception? productError,
  })  : _products = products,
        _product = product,
        _productsError = productsError,
        _productError = productError;

  final List<ProductModel>? _products;
  final ProductModel? _product;
  final Exception? _productsError;
  final Exception? _productError;

  @override
  Future<List<ProductModel>> getProducts() async {
    final error = _productsError;
    if (error != null) {
      throw error;
    }
    return _products ?? [];
  }

  @override
  Future<List<ProductModel>> getProductsPage({
    required int limit,
    required int offset,
  }) async {
    final error = _productsError;
    if (error != null) {
      throw error;
    }
    return _products ?? [];
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final error = _productError;
    if (error != null) {
      throw error;
    }
    return _product as ProductModel;
  }
}

void main() {
  const model = ProductModel(
    id: 1,
    title: 'Backpack',
    price: 50,
    description: 'Desc',
    category: 'bags',
    image: 'https://example.com/1.png',
    rating: 4.5,
    ratingCount: 12,
  );

  test('getProducts returns Success with entities', () async {
    final repository = ProductRepositoryImpl(
      _FakeRemoteDataSource(products: [model]),
    );

    final result = await repository.getProducts();

    expect(result, isA<Success<List<Product>>>());
    final products = (result as Success<List<Product>>).value;
    expect(products.first.title, 'Backpack');
    expect(products.first.imageUrl, model.image);
  });

  test('getProducts maps NetworkException to NetworkFailure', () async {
    final repository = ProductRepositoryImpl(
      _FakeRemoteDataSource(productsError: NetworkException()),
    );

    final result = await repository.getProducts();

    expect(result, isA<ErrorResult<List<Product>>>());
    expect(
      (result as ErrorResult<List<Product>>).failure,
      isA<NetworkFailure>(),
    );
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
      _FakeRemoteDataSource(
        product: model,
        productError: NotFoundException(),
      ),
    );

    final result = await repository.getProductById(1);

    expect(result, isA<ErrorResult<Product>>());
    expect(
      (result as ErrorResult<Product>).failure,
      isA<NotFoundFailure>(),
    );
  });
}
