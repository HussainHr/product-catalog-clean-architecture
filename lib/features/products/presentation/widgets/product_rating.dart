import 'package:flutter/material.dart';

class ProductRating extends StatelessWidget {
  const ProductRating({
    super.key,
    required this.rating,
  });

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          size: 18,
          color: Colors.amber.shade700,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
