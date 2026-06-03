import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/domain/repositories/product_repository.dart';
import 'package:product_catalog_application/domain/usecases/get_products.dart';
import 'package:product_catalog_application/presentation/providers/product_providers.dart';
import 'package:product_catalog_application/presentation/providers/products_list_provider.dart';

class _FakeProductRepository implements ProductRepository {
  _FakeProductRepository(this._productsResult);

  final Result<List<Product>> _productsResult;

  @override
  Future<Result<List<Product>>> getProducts() async => _productsResult;

  @override
  Future<Result<Product>> getProductById(int id) async {
    throw UnimplementedError();
  }
}

const _sampleProduct = Product(
  id: 1,
  title: 'Test Backpack',
  price: 49.99,
  description: 'Description',
  category: 'bags',
  imageUrl: 'https://example.com/image.png',
  rating: 4.5,
  ratingCount: 10,
);

void main() {
  test('loads products on build', () async {
    final container = ProviderContainer(
      overrides: [
        getProductsProvider.overrideWithValue(
          GetProducts(
            _FakeProductRepository(const Success([_sampleProduct])),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final products = await container.read(productsListProvider.future);

    expect(products, [_sampleProduct]);
  });

  test('retry sets loading then reloads', () async {
    var callCount = 0;
    final container = ProviderContainer(
      overrides: [
        getProductsProvider.overrideWithValue(
          GetProducts(
            _FakeProductRepository(
              Success([
                Product(
                  id: ++callCount,
                  title: 'Item $callCount',
                  price: 10,
                  description: 'Desc',
                  category: 'test',
                  imageUrl: 'https://example.com/image.png',
                  rating: 4,
                  ratingCount: 1,
                ),
              ]),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(productsListProvider.future);
    final notifier = container.read(productsListProvider.notifier);

    await notifier.retry();

    expect(container.read(productsListProvider).isLoading, isFalse);
    expect(container.read(productsListProvider).hasValue, isTrue);
  });

  test('throws failure when repository fails', () async {
    final container = ProviderContainer(
      overrides: [
        getProductsProvider.overrideWithValue(
          GetProducts(
            _FakeProductRepository(const ErrorResult(ServerFailure('Failed'))),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await expectLater(
      container.read(productsListProvider.future),
      throwsA(isA<ServerFailure>()),
    );
  });
}
