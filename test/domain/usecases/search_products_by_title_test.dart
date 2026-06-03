import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/domain/usecases/search_products_by_title.dart';

void main() {
  const products = [
    Product(
      id: 1,
      title: 'Fjallraven Backpack',
      price: 109.95,
      description: 'A',
      category: 'bags',
      imageUrl: 'https://example.com/1.png',
      rating: 4.0,
      ratingCount: 10,
    ),
    Product(
      id: 2,
      title: 'Mens Casual T-Shirt',
      price: 22.3,
      description: 'B',
      category: 'men',
      imageUrl: 'https://example.com/2.png',
      rating: 3.5,
      ratingCount: 5,
    ),
  ];

  const useCase = SearchProductsByTitle();

  test('returns all products when query is empty', () {
    expect(
      useCase(products: products, query: ''),
      products,
    );
  });

  test('filters products by title case-insensitively', () {
    final result = useCase(products: products, query: 'backpack');

    expect(result, hasLength(1));
    expect(result.first.id, 1);
  });

  test('returns empty list when nothing matches', () {
    final result = useCase(products: products, query: 'watch');

    expect(result, isEmpty);
  });
}
