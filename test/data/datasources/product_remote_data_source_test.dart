import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:product_catalog_application/core/error/exceptions.dart';
import 'package:product_catalog_application/data/datasources/product_remote_data_source.dart';

void main() {
  const productJson = {
    'id': 1,
    'title': 'Backpack',
    'price': 99.5,
    'description': 'Desc',
    'category': 'bags',
    'image': 'https://example.com/1.png',
    'rating': {'rate': 4.0, 'count': 10},
  };

  group('ProductRemoteDataSourceImpl', () {
    test('getProducts returns parsed models on 200', () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/products');
        return http.Response(jsonEncode([productJson]), 200);
      });

      final dataSource = ProductRemoteDataSourceImpl(client: client);
      final products = await dataSource.getProducts();

      expect(products, hasLength(1));
      expect(products.first.title, 'Backpack');
    });

    test('getProducts throws ServerException on non-200', () async {
      final client = MockClient((request) async {
        return http.Response('error', 500);
      });

      final dataSource = ProductRemoteDataSourceImpl(client: client);

      expect(dataSource.getProducts(), throwsA(isA<ServerException>()));
    });

    test('getProductsPage returns parsed page', () async {
      final client = MockClient((request) async {
        expect(request.url.queryParameters['limit'], '2');
        expect(request.url.queryParameters['offset'], '0');
        return http.Response(jsonEncode([productJson]), 200);
      });

      final dataSource = ProductRemoteDataSourceImpl(client: client);
      final products = await dataSource.getProductsPage(limit: 2, offset: 0);

      expect(products, hasLength(1));
      expect(products.first.title, 'Backpack');
    });

    test('getProductById throws NotFoundException on 404', () async {
      final client = MockClient((request) async {
        return http.Response('not found', 404);
      });

      final dataSource = ProductRemoteDataSourceImpl(client: client);

      expect(
        dataSource.getProductById(99),
        throwsA(isA<NotFoundException>()),
      );
    });
  });
}
