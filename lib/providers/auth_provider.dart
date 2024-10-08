import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier {
  final auth = FirebaseAuth.instance;

  Future<void> signOut() async {
    await auth.signOut();
    notifyListeners();
  }
}
