import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/features/products/domain/entities/paginated_products.dart';
import 'package:product_catalog_application/features/products/domain/entities/product.dart';
import 'package:product_catalog_application/features/products/domain/repositories/product_repository.dart';
import 'package:product_catalog_application/features/products/domain/usecases/get_products.dart';
import 'package:product_catalog_application/features/products/domain/usecases/get_product_by_id.dart';
import 'package:product_catalog_application/features/products/domain/usecases/search_products_by_title.dart';
import 'package:product_catalog_application/features/products/presentation/providers/product_providers.dart';

void main() {
  test('getProductsProvider uses overridden repository', () {
    final container = ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(_FakeProductRepository()),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(getProductsProvider), isA<GetProducts>());
  });

  test('getProductByIdProvider resolves from container', () {
    final container = ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(_FakeProductRepository()),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(getProductByIdProvider), isA<GetProductById>());
  });

  test('searchProductsByTitleProvider returns use case instance', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(searchProductsByTitleProvider),
      isA<SearchProductsByTitle>(),
    );
  });
}

class _FakeProductRepository implements ProductRepository {
  @override
  Future<Result<List<Product>>> getProducts() async {
    throw UnimplementedError();
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
