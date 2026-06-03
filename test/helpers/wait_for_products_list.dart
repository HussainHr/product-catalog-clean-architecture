import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/presentation/providers/products_list_provider.dart';

Future<void> waitForProductsListIdle(ProviderContainer container) async {
  for (var attempt = 0; attempt < 50; attempt++) {
    final state = container.read(productsListProvider);
    if (!state.isInitialLoading && !state.isLoadingMore) {
      return;
    }
    await Future<void>.delayed(Duration.zero);
  }
  fail('Timed out waiting for products list to finish loading');
}
