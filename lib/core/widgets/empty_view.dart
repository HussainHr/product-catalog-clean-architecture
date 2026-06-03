import 'package:flutter/material.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';
import 'package:product_catalog_application/core/theme/app_spacing.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    String? message,
    IconData? icon,
  })  : message = message ?? defaultMessage,
        icon = icon ?? defaultIcon;

  static const String defaultMessage = AppStrings.noProductsFound;
  static const IconData defaultIcon = Icons.inventory_2_outlined;

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
