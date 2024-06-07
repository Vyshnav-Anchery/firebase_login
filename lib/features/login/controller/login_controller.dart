// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/core/utils/firebaseauth_impl.dart';
import 'package:firebase_login/features/home/view/home_screen.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  bool isObscure = true;
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  login(String email, String pass, BuildContext context) async {
    User? userCred =
        await firebaseAuthService.signInWithEmail(email.trim(), pass.trim());
    if (userCred != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    } else {
      log("not done");
    }
  }

  toggleVisibility() {
    isObscure = !isObscure;
    notifyListeners();
  }

  resetPassword(BuildContext context, String email) {
    firebaseAuthService.passReset(email);
    Navigator.pop(context);
  }
}
