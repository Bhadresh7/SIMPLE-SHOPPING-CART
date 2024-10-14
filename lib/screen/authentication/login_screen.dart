import 'dart:async'; // Correctly import the async library for Timer

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_cart/components/custom_login_btn.dart';
import 'package:shopping_cart/components/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Timer? _debounce; // Timer variable for debounce

  // User sign-in method
  void userSignIn() {
    // Cancel the previous timer if it's still running
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Set a new timer to delay the sign-in action
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final navigator = Navigator.of(context);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      try {
        // Attempt to sign in
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        navigator.pop(); // Close loading dialog
      } on FirebaseAuthException catch (e) {
        navigator.pop(); // Close loading dialog
        showMessage(e.code.toString()); // Show error message
      }
    });
  }

  void showMessage(String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
        );
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Back"),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        // Changed to ListView
        padding: const EdgeInsets.all(20.0), // Added padding to ListView
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
              children: [
                Icon(
                  Icons.account_circle,
                  size: 200.0,
                  color: Colors.grey[300],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: emailController,
                  lableText: "Email",
                  obscureText: false,
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(
                  obscureText: true,
                  lableText: "Password",
                  controller: passwordController,
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forget Password?",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomLoginbtn(
                  onTap: userSignIn,
                ),
                const SizedBox(
                  height: 25,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member?"),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Register Now",
                      style: TextStyle(color: Colors.blueAccent),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
