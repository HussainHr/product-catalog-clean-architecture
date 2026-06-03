class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
  });

  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int ratingCount;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Product &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
