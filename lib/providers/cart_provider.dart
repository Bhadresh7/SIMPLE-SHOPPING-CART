import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/modals/CartItem.dart';
import 'package:shopping_cart/modals/Products.dart';

class CartProvider extends ChangeNotifier {
  CartProvider() {
    fetchProducts();
    loadCartItems(); // Load cart items from SharedPreferences when provider is initialized
  }

  final List<CartItem> _cartItems = [];
  List<Product> _products = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _selectedCategory = "All";

  List<CartItem> get cartItems => _cartItems;
  List<Product> get products => _products;
  List<String> get categories => ["All", ..._categories];
  bool get isLoading => _isLoading;
  String? get selectedCategory => _selectedCategory;

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  //Reset the category
  void resetCategory() {
    _selectedCategory = 'All';
    notifyListeners();
  }

  //anonymous function
  void categoryResetTimer() {
    Future.delayed(const Duration(seconds: 2), () {
      resetCategory();
    });
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

  // Persist cart items in SharedPreferences
  Future<void> saveCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItemsJson =
        _cartItems.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('cartItems', cartItemsJson);
  }

  // Load cart items from SharedPreferences
  Future<void> loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItemsJson = prefs.getStringList('cartItems');

    if (cartItemsJson != null) {
      _cartItems.clear();
      _cartItems.addAll(cartItemsJson
          .map((itemJson) => CartItem.fromJson(jsonDecode(itemJson))));
      notifyListeners();
    }
  }

  // Clear cart items from SharedPreferences
  Future<void> clearCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItems');
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    await Future.delayed(const Duration(seconds: 2));
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .get(const GetOptions(source: Source.serverAndCache));
      _products = snapshot.docs
          .map((doc) =>
              Product.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      _categories =
          _products.map((product) => product.category).toSet().toList();
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
    final index =
        _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      return;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
      saveCartItems(); // Save cart items after adding to cart
    }
    notifyListeners();
  }

  void incrementItem(CartItem cartItem) {
    cartItem.quantity++;
    saveCartItems(); // Save after increment
    notifyListeners();
  }

  void decrementItem(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
    } else {
      _cartItems.remove(cartItem);
    }
    saveCartItems(); // Save after decrement
    notifyListeners();
  }
}
