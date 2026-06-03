import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/constants/storage_constants.dart';
import 'package:product_catalog_application/presentation/providers/favorites_providers.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final stored = ref.read(sharedPreferencesProvider).getString(
          StorageConstants.themeModeKey,
        );
    return _fromStorage(stored);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) {
      return;
    }

    state = mode;
    await ref.read(sharedPreferencesProvider).setString(
          StorageConstants.themeModeKey,
          _toStorage(mode),
        );
  }

  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(next);
  }

  static ThemeMode _fromStorage(String? value) {
    return value == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  static String _toStorage(ThemeMode mode) {
    return mode == ThemeMode.dark ? 'dark' : 'light';
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
