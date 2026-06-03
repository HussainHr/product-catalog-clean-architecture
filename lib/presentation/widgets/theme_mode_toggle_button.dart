import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';
import 'package:product_catalog_application/presentation/providers/theme_mode_provider.dart';

class ThemeModeToggleButton extends ConsumerWidget {
  const ThemeModeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return IconButton(
      key: const Key('theme_mode_toggle'),
      icon: Icon(
        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
      ),
      tooltip: isDark
          ? AppStrings.switchToLightMode
          : AppStrings.switchToDarkMode,
      onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
    );
  }
}
