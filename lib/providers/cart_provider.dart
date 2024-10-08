import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_cart/modals/CartItem.dart';
import 'package:shopping_cart/modals/Products.dart';

class CartProvider extends ChangeNotifier {
  CartProvider() {
    fetchProducts();
  }

  final List<CartItem> _cartItems = [];
  List<Product> _products = [];
  List<String> _categories = [];
  bool _isLoading = false;

  // New properties
  String? _selectedCategory = "All";

  List<CartItem> get cartItems => _cartItems;

  List<Product> get products => _products;

  List<String> get categories => ["All", ..._categories];

  bool get isLoading => _isLoading;

  String? get selectedCategory => _selectedCategory;

  // Method to change the selected category
  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Filtered products based on the selected category
  List<Product> get filteredProducts {
    if (_selectedCategory == null ||
        _selectedCategory!.isEmpty ||
        _selectedCategory == "All") {
      return _products;
    }
    return _products
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    await Future.delayed(const Duration(seconds: 2));
    notifyListeners();

    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('products').get();
      _products = snapshot.docs
          .map((doc) =>
              Product.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      _categories =
          _products.map((products) => products.category).toSet().toList();
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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
