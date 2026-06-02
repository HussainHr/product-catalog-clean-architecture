import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/main.dart';

void main() {
  testWidgets('shows product catalog placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(const ProductCatalogApp());

    expect(find.text('Products'), findsOneWidget);
    expect(find.text('Product catalog'), findsOneWidget);
  });
}
