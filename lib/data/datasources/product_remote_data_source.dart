import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:product_catalog_application/core/constants/api_constants.dart';
import 'package:product_catalog_application/core/error/exceptions.dart';
import 'package:product_catalog_application/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();

  Future<List<ProductModel>> getProductsPage({
    required int limit,
    required int offset,
  });

  Future<ProductModel> getProductById(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl({
    required http.Client client,
    String baseUrl = ApiConstants.baseUrl,
  })  : _client = client,
        _baseUrl = baseUrl;

  final http.Client _client;
  final String _baseUrl;

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _client.get(_uri(ApiConstants.productsPath));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as List<dynamic>;
        return decoded
            .map(
              (item) => ProductModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }

      throw ServerException('Failed to load products (${response.statusCode})');
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw ServerException('Invalid response from server');
    }
  }

  @override
  Future<List<ProductModel>> getProductsPage({
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await _client.get(
        _uri(ApiConstants.productsPath).replace(
          queryParameters: {
            'limit': '$limit',
            'offset': '$offset',
          },
        ),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as List<dynamic>;
        return decoded
            .map(
              (item) => ProductModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }

      throw ServerException(
        'Failed to load products page (${response.statusCode})',
      );
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw ServerException('Invalid response from server');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _client.get(
        _uri('${ApiConstants.productsPath}/$id'),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return ProductModel.fromJson(decoded);
      }

      if (response.statusCode == 404) {
        throw NotFoundException();
      }

      throw ServerException('Failed to load product (${response.statusCode})');
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw ServerException('Invalid response from server');
    }
  }
}
