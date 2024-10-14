import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Add shimmer import
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
          Consumer2<AuthenticationProvider, CartProvider>(
              builder: (context, authProvider, cartprovider, child) {
            return IconButton(
              onPressed: () {
                authProvider.signOut();
                cartprovider.categoryResetTimer();
              },
              icon: const Icon(Icons.logout),
            );
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
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  child: cartProvider
                          .isLoading // Assuming you have a loading flag for categories
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Chip(
                                  label: Container(
                                    width: 50, // Set shimmer width for the chip
                                    height: 16,
                                    color: Colors.grey[300],
                                  ),
                                  backgroundColor: Colors.grey[300],
                                  side: const BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: cartProvider.categories.length,
                          itemBuilder: (context, index) {
                            final category = cartProvider.categories[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  cartProvider.selectCategory(category);
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
                                    color: cartProvider.selectedCategory ==
                                            category
                                        ? Colors.white
                                        : Colors.pinkAccent,
                                  ),
                                  side: const BorderSide(
                                    color: Colors.pinkAccent,
                                    width: 1,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),

              // Grid of Products with Skeleton Loader
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: cartProvider.isLoading
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 3 / 4,
                          ),
                          itemCount: 6, // Display 6 shimmer items while loading
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Card(
                                elevation: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color: Colors.grey[300],
                                        margin: const EdgeInsets.all(8.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Container(
                                        height: 16,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    Container(
                                      height: 16,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 3 / 4,
                          ),
                          itemCount: cartProvider.filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product =
                                cartProvider.filteredProducts[index];
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
                                        child: CachedNetworkImage(
                                          imageUrl: product.imageUrl,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
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
                                    const SizedBox(height: 20),
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
