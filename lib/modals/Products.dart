class Product {
  final String id;
  final String name;
  final int price;
  final String imageUrl;
  final String category;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.imageUrl,
      required this.category});

  factory Product.fromJson(Map<String, dynamic> data, String docId) {
    return Product(
        id: docId,
        name: data['name'] ?? '',
        price: data['price'] ?? '',
        imageUrl: data['image'] ?? '',
        category: data['category'] ?? '');
  }
}
