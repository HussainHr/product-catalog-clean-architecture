import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/app.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/domain/usecases/get_products_page.dart';
import 'package:product_catalog_application/presentation/providers/product_providers.dart';
import 'helpers/paged_product_repository.dart';
import 'helpers/test_helpers.dart';

void main() {
  testWidgets('app loads products list screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      await buildTestApp(
        overrides: [
          getProductsPageProvider.overrideWithValue(
            GetProductsPage(
              PagedProductRepository(const [
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
              ]),
            ),
          ),
        ],
        child: const ProductCatalogApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text(AppStrings.productsTitle), findsOneWidget);
    expect(find.text('Widget Test Product'), findsOneWidget);
  });
}
