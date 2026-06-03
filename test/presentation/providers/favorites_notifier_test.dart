import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/presentation/providers/favorites_providers.dart';
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

    await container.read(favoritesProvider.future);
    final notifier = container.read(favoritesProvider.notifier);

    await notifier.toggle(5);
    expect(container.read(favoritesProvider).value, {5});

    await notifier.toggle(5);
    expect(container.read(favoritesProvider).value, isEmpty);
  });
}
