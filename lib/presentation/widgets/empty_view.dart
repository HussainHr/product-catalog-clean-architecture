import 'package:flutter/material.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.message = AppStrings.noProductsFound,
    this.icon = Icons.inventory_2_outlined,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
