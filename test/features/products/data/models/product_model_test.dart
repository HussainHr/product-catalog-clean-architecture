import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/features/products/data/models/product_model.dart';

void main() {
  final json = {
    'id': 1,
    'title': 'Fjallraven Backpack',
    'price': 109.95,
    'description': 'Your perfect pack for everyday use.',
    'category': 'men\'s clothing',
    'image': 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
    'rating': {'rate': 3.9, 'count': 120},
  };

  test('fromJson maps all fields correctly', () {
    final model = ProductModel.fromJson(json);

    expect(model.id, 1);
    expect(model.title, 'Fjallraven Backpack');
    expect(model.price, 109.95);
    expect(model.image, json['image']);
    expect(model.rating, 3.9);
    expect(model.ratingCount, 120);
  });

  test('toEntity maps image to imageUrl', () {
    final model = ProductModel.fromJson(json);
    final entity = model.toEntity();

    expect(entity.imageUrl, json['image']);
    expect(entity.title, model.title);
  });
}
