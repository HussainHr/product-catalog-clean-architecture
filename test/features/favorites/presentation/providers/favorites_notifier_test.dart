import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/storage/shared_preferences_provider.dart';
import 'package:product_catalog_application/features/favorites/presentation/providers/favorites_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('toggle updates favorite ids', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
    );
    addTearDown(container.dispose);

    await Future<void>.delayed(Duration.zero);

    expect(container.read(favoritesProvider).ids, isEmpty);

    await container.read(favoritesProvider.notifier).toggle(1);

    expect(container.read(favoritesProvider).ids, {1});
    expect(container.read(isFavoriteProvider(1)), isTrue);

    await container.read(favoritesProvider.notifier).toggle(1);

    expect(container.read(favoritesProvider).ids, isEmpty);
    expect(container.read(isFavoriteProvider(1)), isFalse);
  });
}
