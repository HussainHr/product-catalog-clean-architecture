import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/theme/app_theme.dart';
import 'package:product_catalog_application/presentation/providers/favorites_providers.dart';
import 'package:product_catalog_application/presentation/providers/theme_mode_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestMaterialApp extends ConsumerWidget {
  const TestMaterialApp({
    super.key,
    required this.home,
  });

  final Widget home;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      home: home,
    );
  }
}

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
