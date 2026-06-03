import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';
import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/domain/usecases/get_products_page.dart';
import 'package:product_catalog_application/presentation/providers/product_providers.dart';
import 'package:product_catalog_application/presentation/providers/products_list_provider.dart';
import 'package:product_catalog_application/presentation/providers/products_list_state.dart';
import 'package:product_catalog_application/presentation/screens/products/product_detail_screen.dart';
import 'package:product_catalog_application/presentation/screens/products/products_list_screen.dart';
import 'package:product_catalog_application/presentation/widgets/favorite_button.dart';
import 'package:product_catalog_application/presentation/widgets/product_card.dart';
import '../../helpers/paged_product_repository.dart';
import '../../helpers/test_helpers.dart';

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

const _shirtProduct = Product(
  id: 2,
  title: 'Mens Casual T-Shirt',
  price: 22.3,
  description: 'Description',
  category: 'men',
  imageUrl: 'https://example.com/shirt.png',
  rating: 3.5,
  ratingCount: 5,
);

class _LoadingNotifier extends ProductsListNotifier {
  @override
  ProductsListState build() => const ProductsListState(isInitialLoading: true);
}

class _ErrorNotifier extends ProductsListNotifier {
  @override
  ProductsListState build() => const ProductsListState(
        failure: ServerFailure('Network unavailable'),
      );
}

class _EmptyNotifier extends ProductsListNotifier {
  @override
  ProductsListState build() => const ProductsListState(products: []);
}

Future<Widget> _buildScreen({
  List<Override> overrides = const [],
  List<Product> products = const [_sampleProduct],
  PagedProductRepository? repository,
}) {
  final repo = repository ?? PagedProductRepository(products);

  return buildTestApp(
    overrides: [
      getProductsPageProvider.overrideWithValue(GetProductsPage(repo)),
      ...overrides,
    ],
    child: const TestMaterialApp(
      home: ProductsListScreen(),
    ),
  );
}

Future<void> _pumpUntilSettled(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  testWidgets('shows loading indicator while fetching', (tester) async {
    await tester.pumpWidget(
      await _buildScreen(
        overrides: [
          productsListProvider.overrideWith(_LoadingNotifier.new),
        ],
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);
    expect(find.text(AppStrings.loadingProducts), findsOneWidget);
  });

  testWidgets('shows product list on success', (tester) async {
    await tester.pumpWidget(await _buildScreen());
    await _pumpUntilSettled(tester);

    expect(find.byType(ProductCard), findsOneWidget);
    expect(find.text('Test Backpack'), findsOneWidget);
    expect(find.text('\$49.99'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
  });

  testWidgets('navigates to product detail on tap', (tester) async {
    await tester.pumpWidget(await _buildScreen());
    await _pumpUntilSettled(tester);

    await tester.tap(find.byType(ProductCard));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(ProductDetailScreen), findsOneWidget);
    expect(find.text(AppStrings.productDetailsTitle), findsOneWidget);
  });

  testWidgets('shows empty state when no products', (tester) async {
    await tester.pumpWidget(
      await _buildScreen(
        overrides: [productsListProvider.overrideWith(_EmptyNotifier.new)],
        products: const [],
      ),
    );
    await _pumpUntilSettled(tester);

    expect(find.text(AppStrings.noProductsFound), findsOneWidget);
  });

  testWidgets('filters products locally while typing', (tester) async {
    await tester.pumpWidget(
      await _buildScreen(products: const [_sampleProduct, _shirtProduct]),
    );
    await _pumpUntilSettled(tester);

    expect(find.text('Test Backpack'), findsOneWidget);
    expect(find.text('Mens Casual T-Shirt'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('product_search_field')),
      'backpack',
    );
    await tester.pump();

    expect(find.text('Test Backpack'), findsOneWidget);
    expect(find.text('Mens Casual T-Shirt'), findsNothing);
  });

  testWidgets('shows empty state when search has no matches', (tester) async {
    await tester.pumpWidget(
      await _buildScreen(products: const [_sampleProduct, _shirtProduct]),
    );
    await _pumpUntilSettled(tester);

    await tester.enterText(
      find.byKey(const Key('product_search_field')),
      'watch',
    );
    await tester.pump();

    expect(find.text(AppStrings.noSearchResults), findsOneWidget);
    expect(find.byType(ProductCard), findsNothing);
  });

  testWidgets('wraps list with RefreshIndicator for pull to refresh', (tester) async {
    final repository = PagedProductRepository([_sampleProduct]);

    await tester.pumpWidget(
      await _buildScreen(
        products: const [_sampleProduct],
        repository: repository,
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

    expect(repository.fetchCount, greaterThan(1));
  });

  testWidgets('toggles favorite on product card', (tester) async {
    await tester.pumpWidget(await _buildScreen());
    await _pumpUntilSettled(tester);

    expect(find.byIcon(Icons.favorite_border), findsWidgets);

    await tester.tap(find.byType(FavoriteButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byIcon(Icons.favorite), findsWidgets);
  });

  testWidgets('shows only favorites when filter is enabled', (tester) async {
    await tester.pumpWidget(
      await _buildScreen(products: const [_sampleProduct, _shirtProduct]),
    );
    await _pumpUntilSettled(tester);

    await tester.tap(find.byType(FavoriteButton).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.byKey(const Key('favorites_filter_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Test Backpack'), findsOneWidget);
    expect(find.text('Mens Casual T-Shirt'), findsNothing);
  });

  testWidgets('toggles between light and dark theme', (tester) async {
    await tester.pumpWidget(await _buildScreen());
    await _pumpUntilSettled(tester);

    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);

    await tester.tap(find.byKey(const Key('theme_mode_toggle')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );

    await tester.tap(find.byKey(const Key('theme_mode_toggle')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
  });

  testWidgets('shows error view with retry button', (tester) async {
    await tester.pumpWidget(
      await _buildScreen(
        overrides: [productsListProvider.overrideWith(_ErrorNotifier.new)],
      ),
    );
    await _pumpUntilSettled(tester);

    expect(find.text('Network unavailable'), findsOneWidget);
    expect(find.text(AppStrings.retry), findsOneWidget);
  });
}
