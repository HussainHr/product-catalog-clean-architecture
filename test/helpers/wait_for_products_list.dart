import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/features/products/presentation/providers/products_list_notifier.dart';

Future<void> waitForProductsListIdle(ProviderContainer container) async {
  for (var attempt = 0; attempt < 50; attempt++) {
    final state = container.read(productsListProvider);
    if (!state.isLoading && !state.isLoadingMore) {
      return;
    }
    await Future<void>.delayed(Duration.zero);
  }
  throw StateError('Timed out waiting for products list');
}
