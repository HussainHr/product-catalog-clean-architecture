import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';
import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/presentation/providers/products_list_provider.dart';
import 'package:product_catalog_application/presentation/screens/products/product_detail_screen.dart';
import 'package:product_catalog_application/presentation/screens/products/products_list_screen.dart';
import 'package:product_catalog_application/presentation/widgets/product_card.dart';

const _sampleProduct = Product(
  id: 1,
  title: 'Test Backpack',
  price: 49.99,
  description: 'Description',
  category: 'bags',
  imageUrl: 'https://example.com/image.png',
  rating: 4.5,
  ratingCount: 10,
);

class _SuccessProductsListNotifier extends ProductsListNotifier {
  @override
  Future<List<Product>> build() async => const [_sampleProduct];
}

class _RefreshTrackingNotifier extends ProductsListNotifier {
  var refreshCallCount = 0;

  @override
  Future<List<Product>> build() async => const [_sampleProduct];

  @override
  Future<void> refresh() async {
    refreshCallCount++;
    await super.refresh();
  }
}

class _EmptyProductsListNotifier extends ProductsListNotifier {
  @override
  Future<List<Product>> build() async => [];
}

class _ErrorProductsListNotifier extends ProductsListNotifier {
  @override
  Future<List<Product>> build() async {
    throw const ServerFailure('Network unavailable');
  }
}

class _LoadingProductsListNotifier extends ProductsListNotifier {
  static final _completer = Completer<List<Product>>();

  @override
  Future<List<Product>> build() => _completer.future;
}

Widget _buildScreen(List<Override> overrides) {
  return ProviderScope(
    overrides: overrides,
    child: const MaterialApp(
      home: ProductsListScreen(),
    ),
  );
}

Future<void> _pumpUntilSettled(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  testWidgets('shows loading indicator while fetching', (tester) async {
    await tester.pumpWidget(
      _buildScreen([
        productsListProvider.overrideWith(_LoadingProductsListNotifier.new),
      ]),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);
    expect(find.text(AppStrings.loadingProducts), findsOneWidget);
  });

  testWidgets('shows product list on success', (tester) async {
    await tester.pumpWidget(
      _buildScreen([
        productsListProvider.overrideWith(_SuccessProductsListNotifier.new),
      ]),
    );
    await _pumpUntilSettled(tester);

    expect(find.byType(ProductCard), findsOneWidget);
    expect(find.text('Test Backpack'), findsOneWidget);
    expect(find.text('\$49.99'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
  });

  testWidgets('navigates to product detail on tap', (tester) async {
    await tester.pumpWidget(
      _buildScreen([
        productsListProvider.overrideWith(_SuccessProductsListNotifier.new),
      ]),
    );
    await _pumpUntilSettled(tester);

    await tester.tap(find.byType(ProductCard));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(ProductDetailScreen), findsOneWidget);
    expect(find.text(AppStrings.productDetailsTitle), findsOneWidget);
  });

  testWidgets('shows empty state when no products', (tester) async {
    await tester.pumpWidget(
      _buildScreen([
        productsListProvider.overrideWith(_EmptyProductsListNotifier.new),
      ]),
    );
    await _pumpUntilSettled(tester);

    expect(find.text(AppStrings.noProductsFound), findsOneWidget);
  });

  testWidgets('wraps list with RefreshIndicator for pull to refresh', (tester) async {
    late _RefreshTrackingNotifier notifier;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productsListProvider.overrideWith(() {
            notifier = _RefreshTrackingNotifier();
            return notifier;
          }),
        ],
        child: const MaterialApp(
          home: ProductsListScreen(),
        ),
      ),
    );
    await _pumpUntilSettled(tester);

    expect(find.byType(RefreshIndicator), findsOneWidget);

    await tester.drag(
      find.descendant(
        of: find.byType(RefreshIndicator),
        matching: find.byType(Scrollable),
      ),
      const Offset(0, 300),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(notifier.refreshCallCount, 1);
  });

  testWidgets('shows error view with retry button', (tester) async {
    await tester.pumpWidget(
      _buildScreen([
        productsListProvider.overrideWith(_ErrorProductsListNotifier.new),
      ]),
    );
    await _pumpUntilSettled(tester);

    expect(find.text('Network unavailable'), findsOneWidget);
    expect(find.text(AppStrings.retry), findsOneWidget);
  });
}
