import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shopping_cart/components/custom_login_btn.dart';
import 'package:shopping_cart/helpers/debounce_helper.dart'; // Import the DebounceHelper
import 'package:shopping_cart/helpers/toast_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>(); // Key for the FormBuilder
  final DebounceHelper _debounceHelper =
      DebounceHelper(); // Create an instance of DebounceHelper

  // User sign-in method
  void userSignIn() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final email = _formKey.currentState?.fields['email']?.value;
      final password = _formKey.currentState?.fields['password']?.value;

      _debounceHelper.debounce(() async {
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
            email: email,
            password: password,
          );
          navigator.pop();
          ToastHelper.showSuccessToast(
              context: context, message: "Login Successful");
        } on FirebaseAuthException catch (e) {
          navigator.pop();
          ToastHelper.showErrorToast(
              context: context, message: e.code.toString());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Back"),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 200.0,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 20),
                // Wrapping the form in FormBuilder
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'email',
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ]),
                      ),
                      const SizedBox(height: 25),
                      FormBuilderTextField(
                        name: 'password',
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.password(),
                        ]),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                CustomLoginbtn(
                  onTap: userSignIn,
                ),
                const SizedBox(height: 25),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member?"),
                    SizedBox(width: 10),
                    Text(
                      "Register Now",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
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
