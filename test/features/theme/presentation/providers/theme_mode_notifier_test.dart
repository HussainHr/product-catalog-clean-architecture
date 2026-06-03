import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_application/core/constants/storage_constants.dart';
import 'package:product_catalog_application/core/storage/shared_preferences_provider.dart';
import 'package:product_catalog_application/features/theme/presentation/providers/theme_mode_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('defaults to light theme', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(themeModeProvider), ThemeMode.light);
  });

  test('loads stored dark theme on start', () async {
    SharedPreferences.setMockInitialValues({
      StorageConstants.themeModeKey: 'dark',
    });
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(themeModeProvider), ThemeMode.dark);
  });

  test('toggle switches theme and persists', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
    );
    addTearDown(container.dispose);

    await container.read(themeModeProvider.notifier).toggle();

    expect(container.read(themeModeProvider), ThemeMode.dark);
    expect(preferences.getString(StorageConstants.themeModeKey), 'dark');

    await container.read(themeModeProvider.notifier).toggle();

    expect(container.read(themeModeProvider), ThemeMode.light);
    expect(preferences.getString(StorageConstants.themeModeKey), 'light');
  });
}
