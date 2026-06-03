import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/domain/entities/paginated_products.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/domain/repositories/product_repository.dart';
import 'package:product_catalog_application/domain/usecases/get_product_by_id.dart';
import 'package:product_catalog_application/domain/usecases/search_products_by_title.dart';
import 'package:product_catalog_application/presentation/providers/product_providers.dart';

class _FakeProductRepository implements ProductRepository {
  @override
  Future<Result<List<Product>>> getProducts() async {
    return const Success([]);
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

void main() {
  late ProviderContainer container;

  tearDown(() {
    container.dispose();
  });

  test('getProductsProvider uses overridden repository', () async {
    container = ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(_FakeProductRepository()),
      ],
    );

    final useCase = container.read(getProductsProvider);
    final result = await useCase();

    expect(result, isA<Success<List<Product>>>());
    expect((result as Success<List<Product>>).value, isEmpty);
  });

  test('getProductByIdProvider resolves from container', () {
    container = ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(_FakeProductRepository()),
      ],
    );

    expect(container.read(getProductByIdProvider), isA<GetProductById>());
  });

  test('searchProductsByTitleProvider returns use case instance', () {
    container = ProviderContainer();

    expect(
      container.read(searchProductsByTitleProvider),
      isA<SearchProductsByTitle>(),
    );
  });
}
