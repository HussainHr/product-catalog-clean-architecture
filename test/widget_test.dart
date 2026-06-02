import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/app.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';

void main() {
  testWidgets('shows products list placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ProductCatalogApp(),
      ),
    );

    expect(find.text(AppStrings.productsTitle), findsOneWidget);
    expect(find.text(AppStrings.productsPlaceholder), findsOneWidget);
  });
}
