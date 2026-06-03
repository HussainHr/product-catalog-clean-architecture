import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';
import 'package:product_catalog_application/core/theme/app_theme.dart';
import 'package:product_catalog_application/presentation/providers/theme_mode_provider.dart';
import 'package:product_catalog_application/presentation/screens/products/products_list_screen.dart';

class ProductCatalogApp extends ConsumerWidget {
  const ProductCatalogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const ProductsListScreen(),
    );
  }
}
