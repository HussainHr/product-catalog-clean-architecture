import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/presentation/providers/favorites_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Widget> buildTestApp({
  required Widget child,
  List<Override> overrides = const [],
}) async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();

  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(preferences),
      ...overrides,
    ],
    child: child,
  );
}
