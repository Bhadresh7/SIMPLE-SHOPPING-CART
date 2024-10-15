import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
