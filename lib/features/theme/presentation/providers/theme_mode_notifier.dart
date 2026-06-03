import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/constants/storage_constants.dart';
import 'package:product_catalog_application/core/storage/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._preferences) : super(_readTheme(_preferences));

  final SharedPreferences _preferences;

  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = next;
    await _preferences.setString(
      StorageConstants.themeModeKey,
      next == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  static ThemeMode _readTheme(SharedPreferences preferences) {
    return preferences.getString(StorageConstants.themeModeKey) == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(ref.watch(sharedPreferencesProvider)),
);
