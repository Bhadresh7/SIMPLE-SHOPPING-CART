import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: cartProvider.cartItems.isEmpty
          ? const Center(
              child: Text(
              "Your cart is empty",
              style: TextStyle(fontSize: 20),
            ))
          : ListView.builder(
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartProvider.cartItems[index];
                return ListTile(
                  leading: Image.asset(cartItem.product.imageUrl,
                      width: 50, height: 50),
                  title: Text(cartItem.product.name),
                  subtitle: Text(
                      'Price: \$${cartItem.product.price.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          cartProvider.decrementItem(cartItem);
                        },
                      ),
                      Text(cartItem.quantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          cartProvider.incrementItem(cartItem);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Conditionally render total price and checkout button
            if (cartProvider.cartItems.isNotEmpty)
              Row(
                children: [
                  const SizedBox(width: 5),
                  Text(
                    "Total:\n\$${cartProvider.totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

            if (cartProvider.cartItems.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  // Action for proceeding to checkout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent[200],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Checkout",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(width: 10), // Space between text and icon
                      Icon(Icons.arrow_forward_rounded, color: Colors.white),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
