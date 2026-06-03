import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog_application/core/constants/app_strings.dart';
import 'package:product_catalog_application/core/error/failures.dart';
import 'package:product_catalog_application/domain/entities/product.dart';
import 'package:product_catalog_application/presentation/providers/products_list_provider.dart';
import 'package:product_catalog_application/presentation/widgets/empty_view.dart';
import 'package:product_catalog_application/presentation/widgets/error_view.dart';
import 'package:product_catalog_application/presentation/widgets/loading_view.dart';
import 'package:product_catalog_application/presentation/widgets/product_card.dart';

class ProductsListScreen extends ConsumerWidget {
  const ProductsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.productsTitle),
      ),
      body: productsState.when(
        loading: () => const LoadingView(message: AppStrings.loadingProducts),
        error: (error, _) => ErrorView(
          message: _errorMessage(error),
          onRetry: () => ref.read(productsListProvider.notifier).refresh(),
        ),
        data: (products) => _ProductsBody(products: products),
      ),
    );
  }

  String _errorMessage(Object error) {
    if (error is Failure) {
      return error.message;
    }
    return AppStrings.genericError;
  }
}

class _ProductsBody extends StatelessWidget {
  const _ProductsBody({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const EmptyView();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final useGrid = constraints.maxWidth >= 600;

        if (useGrid) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.4,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return ProductCard(product: products[index]);
          },
        );
      },
    );
  }
}
