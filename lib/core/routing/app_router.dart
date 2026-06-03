import 'package:flutter/material.dart';
import 'package:product_catalog_application/features/products/domain/entities/product.dart';
import 'package:product_catalog_application/features/products/presentation/screens/product_detail_screen.dart';

void openProductDetail(BuildContext context, Product product) {
  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (context) => ProductDetailScreen(product: product),
    ),
  );
}
