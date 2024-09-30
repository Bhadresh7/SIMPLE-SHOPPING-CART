import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/providers/cart_provider.dart';
import 'package:shopping_cart/screen/ProductListScreen.dart';

void main() {
  // await databaseConnection();
  // if (databaseConnection()) {
  //   print("connected successfully");
  //   return;
  // }
  runApp(const myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => CartProvider())],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.pinkAccent,
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white)),
        debugShowCheckedModeBanner: false,
        home: ProductGridScreen(),
      ),
    );
  }
}
