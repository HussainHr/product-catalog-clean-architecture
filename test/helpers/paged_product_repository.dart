import 'package:product_catalog_application/core/error/result.dart';
import 'package:product_catalog_application/features/products/domain/entities/paginated_products.dart';
import 'package:product_catalog_application/features/products/domain/entities/product.dart';
import 'package:product_catalog_application/features/products/domain/repositories/product_repository.dart';

class PagedProductRepository implements ProductRepository {
  PagedProductRepository(this._allProducts);

  final List<Product> _allProducts;
  var fetchCount = 0;

  @override
  Future<Result<List<Product>>> getProducts() async {
    return Success(List<Product>.from(_allProducts));
  }

  @override
  Future<Result<PaginatedProducts>> getProductsPage({
    required int limit,
    required int offset,
  }) async {
    fetchCount++;
    if (offset >= _allProducts.length) {
      return const Success(
        PaginatedProducts(products: [], hasMore: false),
      );
    }

    final page = _allProducts.skip(offset).take(limit).toList();
    return Success(
      PaginatedProducts(
        products: page,
        hasMore: offset + page.length < _allProducts.length,
      ),
    );
  }

  @override
  Future<Result<Product>> getProductById(int id) async {
    throw UnimplementedError();
  }
}
