class Product {
  final String id;
  final String name;
  final int price;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  // Deserialization from JSON
  factory Product.fromJson(Map<String, dynamic> data, String docId) {
    return Product(
      id: docId,
      name: data['name'] ?? '',
      price: data['price'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
    );
  }

  // Serialization to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'category': category,
      };
}
