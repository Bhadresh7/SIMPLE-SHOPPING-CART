import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/database_connection.dart';
import 'package:shopping_cart/providers/auth_provider.dart';
import 'package:shopping_cart/providers/cart_provider.dart';
import 'package:shopping_cart/screen/product_list_screen.dart';

void main() async {
  await databaseConnection();
  if (databaseConnection()) {
    print("connected successfully");
  } else {
    print("Not Connected");
    return;
  }
  runApp(const myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthenticationProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.pinkAccent,
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white)),
        debugShowCheckedModeBanner: false,
        home: const ProductGridScreen(),
      ),
    );
  }
}
