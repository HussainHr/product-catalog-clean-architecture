import 'package:flutter/material.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/presentation/screens/products/product_detail_screen.dart';

abstract final class AppRoutes {
  static const String productDetail = '/product-detail';
}

void openProductDetail(BuildContext context, Product product) {
  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      settings: const RouteSettings(name: AppRoutes.productDetail),
      builder: (context) => ProductDetailScreen(product: product),
    ),
  );
}
