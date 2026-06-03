import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/presentation/screens/products/product_detail_screen.dart';
import '../../helpers/test_helpers.dart';

const _product = Product(
  id: 1,
  title: 'Fjallraven Backpack',
  price: 109.95,
  description: 'Your perfect pack for everyday use and walks in the forest.',
  category: 'men\'s clothing',
  imageUrl: 'https://example.com/image.png',
  rating: 3.9,
  ratingCount: 120,
);

void main() {
  testWidgets('shows all product detail fields', (tester) async {
    await tester.pumpWidget(
      await buildTestApp(
        child: const MaterialApp(
          home: ProductDetailScreen(product: _product),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text(AppStrings.productDetailsTitle), findsOneWidget);
    expect(find.text('Fjallraven Backpack'), findsOneWidget);
    expect(find.text('\$109.95'), findsOneWidget);
    expect(find.textContaining('men\'s clothing'), findsOneWidget);
    expect(find.text('3.9'), findsOneWidget);
    expect(find.text('(120 ${AppStrings.reviewsLabel})'), findsOneWidget);
    expect(
      find.text('Your perfect pack for everyday use and walks in the forest.'),
      findsOneWidget,
    );
    expect(find.text(AppStrings.descriptionLabel), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });
}
