import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/utils/responsive_layout.dart';

void main() {
  test('gridColumnCount returns 1 for phone width', () {
    expect(ResponsiveLayout.gridColumnCount(400), 1);
  });

  test('gridColumnCount returns 2 for tablet width', () {
    expect(ResponsiveLayout.gridColumnCount(700), 2);
  });

  test('gridColumnCount returns 3 for desktop width', () {
    expect(ResponsiveLayout.gridColumnCount(1000), 3);
  });
}
