import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/constants/api_constants.dart';
import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/features/products/domain/entities/paginated_products.dart';
import 'package:product_catalog_application/features/products/domain/entities/product.dart';
import 'package:product_catalog_application/features/products/domain/repositories/product_repository.dart';
import 'package:product_catalog_application/features/products/presentation/providers/product_providers.dart';
import 'package:product_catalog_application/features/products/presentation/providers/products_list_notifier.dart';
import '../../../../helpers/paged_product_repository.dart';
import '../../../../helpers/wait_for_products_list.dart';

Product _product(int id) => Product(
      id: id,
      title: 'Product $id',
      price: 10,
      description: 'Desc',
      category: 'test',
      imageUrl: 'https://example.com/$id.png',
      rating: 4,
      ratingCount: 1,
    );

List<Product> _manyProducts(int count) =>
    List.generate(count, (index) => _product(index + 1));

void main() {
  test('loads first page on start', () async {
    final container = ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(
          PagedProductRepository(_manyProducts(15)),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(productsListProvider.notifier).load(refresh: true);
    await waitForProductsListIdle(container);

    final state = container.read(productsListProvider);
    expect(state.products, hasLength(ApiConstants.defaultPageSize));
    expect(state.hasMore, isTrue);
  });

  test('load appends next page', () async {
    final container = ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(
          PagedProductRepository(_manyProducts(15)),
        ),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(productsListProvider.notifier);
    await notifier.load(refresh: true);
    await waitForProductsListIdle(container);
    await notifier.load();
    await waitForProductsListIdle(container);

    final state = container.read(productsListProvider);
    expect(state.products, hasLength(15));
    expect(state.hasMore, isFalse);
  });

  test('refresh resets list', () async {
    final repository = PagedProductRepository(_manyProducts(15));
    final container = ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(productsListProvider.notifier);
    await notifier.load(refresh: true);
    await waitForProductsListIdle(container);
    await notifier.load();
    await waitForProductsListIdle(container);
    await notifier.refresh();
    await waitForProductsListIdle(container);

    expect(
      container.read(productsListProvider).products,
      hasLength(ApiConstants.defaultPageSize),
    );
    expect(repository.fetchCount, greaterThan(1));
  });

  test('sets failure when request fails', () async {
    final container = ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(_FailingRepository()),
      ],
    );
    addTearDown(container.dispose);

    await container.read(productsListProvider.notifier).load(refresh: true);
    await waitForProductsListIdle(container);

    final state = container.read(productsListProvider);
    expect(state.hasError, isTrue);
    expect(state.products, isEmpty);
  });
}

class _FailingRepository implements ProductRepository {
  @override
  Future<Result<List<Product>>> getProducts() async {
    return const ErrorResult(ServerFailure('Failed'));
  }

  @override
  Future<Result<PaginatedProducts>> getProductsPage({
    required int limit,
    required int offset,
  }) async {
    return const ErrorResult(ServerFailure('Failed'));
  }

  @override
  Future<Result<Product>> getProductById(int id) async {
    throw UnimplementedError();
  }
}
