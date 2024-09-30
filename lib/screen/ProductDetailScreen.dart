import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/Modal/Products.dart';
import 'package:shopping_cart/providers/cart_provider.dart';
import 'package:shopping_cart/screen/ProductCartScreen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset(product.imageUrl, height: 550),
                  const SizedBox(height: 10),
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, color: Colors.grey)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent[200],
                      ),
                      onPressed: () {
                        cartProvider.addToCart(product);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartScreen()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Add to Cart",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Add spacing between the buttons
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Colors.pinkAccent),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartScreen()));
                      },
                      child: const Text(
                        "Go to Cart",
                        style:
                            TextStyle(color: Colors.pinkAccent, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
