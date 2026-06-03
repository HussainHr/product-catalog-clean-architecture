abstract final class PriceFormatter {
  static String format(double price) => '\$${price.toStringAsFixed(2)}';
}
