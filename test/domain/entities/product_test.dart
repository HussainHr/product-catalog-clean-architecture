import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/domain/entities/product.dart';

void main() {
  const productA = Product(
    id: 1,
    title: 'Test',
    price: 9.99,
    description: 'Desc',
    category: 'electronics',
    imageUrl: 'https://example.com/img.png',
    rating: 4.5,
    ratingCount: 10,
  );

  const productSameId = Product(
    id: 1,
    title: 'Other title',
    price: 1.0,
    description: 'Other',
    category: 'jewelery',
    imageUrl: 'https://example.com/other.png',
    rating: 3.0,
    ratingCount: 2,
  );

  const productOther = Product(
    id: 2,
    title: 'Test',
    price: 9.99,
    description: 'Desc',
    category: 'electronics',
    imageUrl: 'https://example.com/img.png',
    rating: 4.5,
    ratingCount: 10,
  );

  test('products with same id are equal', () {
    expect(productA, equals(productSameId));
  });

  test('products with different id are not equal', () {
    expect(productA, isNot(equals(productOther)));
  });
}
