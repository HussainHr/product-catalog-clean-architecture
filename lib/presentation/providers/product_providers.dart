import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/data/datasources/product_remote_data_source.dart';
import 'package:product_catalog_application/data/repositories/product_repository_impl.dart';
import 'package:product_catalog_application/domain/repositories/product_repository.dart';
import 'package:product_catalog_application/domain/usecases/get_product_by_id.dart';
import 'package:product_catalog_application/domain/usecases/get_products.dart';
import 'package:product_catalog_application/domain/usecases/get_products_page.dart';
import 'package:product_catalog_application/domain/usecases/search_products_by_title.dart';
import 'package:product_catalog_application/presentation/providers/http_client_provider.dart';

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSourceImpl(
    client: ref.watch(httpClientProvider),
  );
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    ref.watch(productRemoteDataSourceProvider),
  );
});

final getProductsProvider = Provider<GetProducts>((ref) {
  return GetProducts(ref.watch(productRepositoryProvider));
});

final getProductsPageProvider = Provider<GetProductsPage>((ref) {
  return GetProductsPage(ref.watch(productRepositoryProvider));
});

final getProductByIdProvider = Provider<GetProductById>((ref) {
  return GetProductById(ref.watch(productRepositoryProvider));
});

final searchProductsByTitleProvider = Provider<SearchProductsByTitle>((ref) {
  return const SearchProductsByTitle();
});
