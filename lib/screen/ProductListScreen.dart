import 'package:flutter/material.dart';
import 'package:shopping_cart/screen/ProductCartScreen.dart';

import '../Modal/Products.dart';
import 'ProductDetailScreen.dart';

class ProductGridScreen extends StatefulWidget {
  @override
  _ProductGridScreenState createState() => _ProductGridScreenState();
}

class _ProductGridScreenState extends State<ProductGridScreen> {
  final List<String> categories = [
    'All',
    'Computers',
    'Accessories',
    'Headphones',
    'Smartphones',
  ];

  final List<Product> allProducts = [
    Product(
      id: '1',
      name: 'Buds',
      price: 29.99,
      imageUrl: 'assets/buds.png',
      category: 'Accessories',
    ),
    Product(
      id: '2',
      name: 'Headset',
      price: 19.99,
      imageUrl: 'assets/headset.png',
      category: 'Headphones',
    ),
    Product(
      id: '4',
      name: 'Wired',
      price: 49.99,
      imageUrl: 'assets/headset-wired.png',
      category: 'Headphones',
    ),
    Product(
      id: '5',
      name: 'Neckband',
      price: 59.99,
      imageUrl: 'assets/neckband.png',
      category: 'Accessories',
    ),
    Product(
      id: '6',
      name: 'Iphone14 Pro Max',
      price: 24.99,
      imageUrl: 'assets/iphone14.png',
      category: 'Smartphones',
    ),
    Product(
      id: '7',
      name: 'Gaming Keyboard',
      price: 24.99,
      imageUrl: 'assets/keyboard.png',
      category: 'Computers',
    ),
  ];

  String selectedCategory = 'All';

  // Filter the products based on the selected category
  List<Product> get filteredProducts {
    if (selectedCategory == 'All') {
      return allProducts;
    } else {
      return allProducts
          .where((product) => product.category == selectedCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    )),
                icon: const Icon(Icons.shopping_cart)),
          )
        ],
        title: const Text(
          'Product Page',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scrollable Category List
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = categories[index]; // Update category
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Chip(
                        label: Text(categories[index]),
                        backgroundColor: selectedCategory == categories[index]
                            ? Colors.pinkAccent[100]
                            : Colors.white,
                        labelStyle: TextStyle(
                          color: selectedCategory == categories[index]
                              ? Colors.white
                              : Colors.pinkAccent,
                        ),
                        side: const BorderSide(
                          color: Colors.pinkAccent,
                          width: 1,
                        ), // Pink border
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Grid of Products
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 10, // Space between columns
                  mainAxisSpacing: 10, // Space between rows
                  childAspectRatio: 3 / 4, // Aspect ratio of the grid items
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
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
                              child: Image.asset(product.imageUrl),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
