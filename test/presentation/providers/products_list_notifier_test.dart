import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/constants/api_constants.dart';
import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/domain/entities/paginated_products.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/domain/usecases/get_products_page.dart';
import 'package:product_catalog_application/presentation/providers/product_providers.dart';
import 'package:product_catalog_application/presentation/providers/products_list_provider.dart';
import '../../helpers/paged_product_repository.dart';
import '../../helpers/wait_for_products_list.dart';

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
    final repository = PagedProductRepository(_manyProducts(15));
    final container = ProviderContainer(
      overrides: [
        getProductsPageProvider.overrideWithValue(GetProductsPage(repository)),
      ],
    );
    addTearDown(container.dispose);

    await waitForProductsListIdle(container);

    final state = container.read(productsListProvider);
    expect(state.products, hasLength(ApiConstants.defaultPageSize));
    expect(state.hasMore, isTrue);
    expect(state.isInitialLoading, isFalse);
  });

  test('loadNextPage appends products', () async {
    final repository = PagedProductRepository(_manyProducts(15));
    final container = ProviderContainer(
      overrides: [
        getProductsPageProvider.overrideWithValue(GetProductsPage(repository)),
      ],
    );
    addTearDown(container.dispose);

    await waitForProductsListIdle(container);

    await container.read(productsListProvider.notifier).loadNextPage();
    await waitForProductsListIdle(container);

    final state = container.read(productsListProvider);
    expect(state.products, hasLength(15));
    expect(state.hasMore, isFalse);
  });

  test('refresh resets list', () async {
    final repository = PagedProductRepository(_manyProducts(15));
    final container = ProviderContainer(
      overrides: [
        getProductsPageProvider.overrideWithValue(GetProductsPage(repository)),
      ],
    );
    addTearDown(container.dispose);

    await waitForProductsListIdle(container);

    await container.read(productsListProvider.notifier).loadNextPage();
    await waitForProductsListIdle(container);

    await container.read(productsListProvider.notifier).refresh();
    await waitForProductsListIdle(container);

    final state = container.read(productsListProvider);
    expect(state.products, hasLength(ApiConstants.defaultPageSize));
    expect(repository.fetchCount, greaterThan(1));
  });

  test('sets failure when first page fails', () async {
    final container = ProviderContainer(
      overrides: [
        getProductsPageProvider.overrideWithValue(
          GetProductsPage(_FailingRepository()),
        ),
      ],
    );
    addTearDown(container.dispose);

    await waitForProductsListIdle(container);

    final state = container.read(productsListProvider);
    expect(state.hasError, isTrue);
    expect(state.products, isEmpty);
  });
}

class _FailingRepository extends PagedProductRepository {
  _FailingRepository() : super(const []);

  @override
  Future<Result<PaginatedProducts>> getProductsPage({
    required int limit,
    required int offset,
  }) async {
    return const ErrorResult(ServerFailure('Failed'));
  }
}
