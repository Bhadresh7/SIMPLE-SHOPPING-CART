import 'package:shopping_cart/modals/Products.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  // Deserialization from JSON
  factory CartItem.fromJson(Map<String, dynamic> data) {
    return CartItem(
      product: Product.fromJson(data['product'], data['product']['id']),
      quantity: data['quantity'] ?? 1,
    );
  }

  // Serialization to JSON
  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };
}
