import 'package:flutter/material.dart';
import 'package:shopping_cart/Modal/CartItem.dart';
import 'package:shopping_cart/Modal/Products.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  double get totalPrice {
    return _cartItems.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  void addToCart(Product product) {
    final index = _cartItems.indexWhere((item) =>
        item.product.id ==
        product
            .id); // checking the card if the item is already added in the cart
    // indexWhere function returns the index or -1 if the spcified is not there
    if (index != -1) {
      return;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void incrementItem(CartItem cartItem) {
    cartItem.quantity++;
    notifyListeners();
  }

  void decrementItem(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
    } else {
      _cartItems.remove(cartItem);
    }
    notifyListeners();
  }
}
