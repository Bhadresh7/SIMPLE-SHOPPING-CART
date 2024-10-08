import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/providers/auth_provider.dart';
import 'package:shopping_cart/providers/cart_provider.dart';
import 'package:shopping_cart/screen/product_cart_screen.dart';

import 'product_details_screen.dart';

class ProductGridScreen extends StatefulWidget {
  const ProductGridScreen({super.key});

  @override
  _ProductGridScreenState createState() => _ProductGridScreenState();
}

class _ProductGridScreenState extends State<ProductGridScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<AuthenticationProvider>(
              builder: (context, authProvider, child) {
            return IconButton(
                onPressed: () {
                  authProvider.signOut();
                },
                icon: const Icon(Icons.logout));
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              ),
              icon: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scrollable Category List
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cartProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = cartProvider.categories[index];
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              cartProvider.selectCategory(
                                  category); // Implement this method in CartProvider
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Chip(
                              label: Text(category),
                              backgroundColor:
                                  cartProvider.selectedCategory == category
                                      ? Colors.pinkAccent[100]
                                      : Colors.white,
                              labelStyle: TextStyle(
                                color: cartProvider.selectedCategory == category
                                    ? Colors.white
                                    : Colors.pinkAccent,
                              ),
                              side: const BorderSide(
                                color: Colors.pinkAccent,
                                width: 1,
                              ),
                            ),
                          ));
                    },
                  ),
                ),
              ),

              // Grid of Products
              // Grid of Products
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 10, // Space between columns
                      mainAxisSpacing: 10, // Space between rows
                      childAspectRatio: 3 / 4, // Aspect ratio of the grid items
                    ),
                    itemCount: cartProvider.filteredProducts
                        .length, // Ensure this matches the actual length
                    itemBuilder: (context, index) {
                      if (index >= cartProvider.filteredProducts.length) {
                        return Container(); // Or handle the case when there are no products
                      }

                      final product = cartProvider.filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(product.imageUrl),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(),
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
