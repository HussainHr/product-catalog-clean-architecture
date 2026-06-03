import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/app.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/presentation/providers/products_list_provider.dart';
import 'helpers/test_helpers.dart';

class _TestProductsListNotifier extends ProductsListNotifier {
  @override
  Future<List<Product>> build() async => const [
        Product(
          id: 1,
          title: 'Widget Test Product',
          price: 10,
          description: 'Desc',
          category: 'test',
          imageUrl: 'https://example.com/image.png',
          rating: 4.0,
          ratingCount: 1,
        ),
      ];
}

void main() {
  testWidgets('app loads products list screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      await buildTestApp(
        overrides: [
          productsListProvider.overrideWith(_TestProductsListNotifier.new),
        ],
        child: const ProductCatalogApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text(AppStrings.productsTitle), findsOneWidget);
    expect(find.text('Widget Test Product'), findsOneWidget);
  });
}
